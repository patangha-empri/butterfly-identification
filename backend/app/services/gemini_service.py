"""
AI butterfly identification — Google Gemini Vision API.

Public interface (unchanged — callers / tests need no edits):
    identify_butterfly(image_bytes_list)  -> dict
    download_image_bytes(url)             -> bytes
    find_species_id(scientific_name, common_name) -> str | None
"""
import io
import json
import logging
import re
import time
from difflib import SequenceMatcher

import requests as http
from flask import current_app
from PIL import Image

log = logging.getLogger(__name__)

# ── Prompt ─────────────────────────────────────────────────────────────────────

_SYSTEM_PROMPT = """You are an expert entomologist, lepidopterist, wildlife biologist, and biodiversity data specialist.

Your task is to analyze an uploaded butterfly image and return a professional JSON response suitable for a production mobile application.

The response should not only identify the butterfly but also explain why the identification was made and provide educational information for the user.

---

## Primary Tasks

1. Analyze the uploaded image.
2. Determine whether the image contains a true BUTTERFLY (order Lepidoptera,
   suborder Rhopalocera — i.e. Papilionoidea). Classify the subject as one of:

   * Butterfly (adult)
   * Moth
   * Caterpillar / larva
   * Chrysalis / pupa
   * Egg
   * Other animal (bird, spider, other insect, etc.)
   * Non-living object (phone, leaf, flower, background, etc.)
   * No subject / empty
3. `detection.contains_butterfly` MUST be true ONLY when the main subject is a
   living ADULT BUTTERFLY. Set it to false for moths, caterpillars, pupae,
   eggs, other animals, objects (phones, hands, screens, furniture), plants,
   or empty frames.
4. Butterfly vs moth is critical. Butterflies have thin bodies, clubbed
   (knobbed) antennae, and usually rest with wings closed and upright. Moths
   have feathery/thread-like antennae, stout furry bodies, and rest with wings
   flat. When in doubt between butterfly and moth, set contains_butterfly to
   false and identify it as a moth.
5. If confidence is low, clearly indicate that the result is uncertain.
6. Return ONLY valid JSON.
7. Never hallucinate. If information is unknown, return null. NEVER invent a
   butterfly when the subject is not a butterfly.
8. Scientific names must use accepted taxonomy.
9. Confidence must be a number between 0 and 100.
10. Explanations should be concise and scientifically accurate.

---

## Required JSON Structure

{
  "success": true,
  "image_quality": {
    "score": 0,
    "rating": "",
    "lighting": "",
    "sharpness": "",
    "visibility": "",
    "background_complexity": "",
    "recommendation": ""
  },
  "detection": {
    "contains_butterfly": true,
    "life_stage": "",
    "number_of_individuals": 1,
    "is_partial_view": false,
    "occluded": false
  },
  "identification": {
    "common_name": "",
    "scientific_name": "",
    "family": "",
    "genus": "",
    "species": "",
    "confidence": 0,
    "confidence_level": "",
    "identification_status": ""
  },
  "alternative_matches": [
    {
      "common_name": "",
      "scientific_name": "",
      "confidence": 0,
      "reason": ""
    }
  ],
  "identification_reason": {
    "summary": "",
    "key_features": [
      "",
      "",
      ""
    ],
    "visual_features_detected": {
      "wing_shape": "",
      "wing_pattern": "",
      "primary_colors": [],
      "secondary_colors": [],
      "tail_present": false,
      "eye_spots": false,
      "antenna_type": "",
      "body_shape": "",
      "wing_texture": ""
    }
  },
  "species_profile": {
    "description": "",
    "taxonomy": {
      "kingdom": "",
      "phylum": "",
      "class": "",
      "order": "",
      "family": "",
      "genus": "",
      "species": ""
    },
    "physical_characteristics": {
      "average_wingspan_cm": "",
      "male_description": "",
      "female_description": "",
      "sexual_dimorphism": ""
    },
    "habitat": [],
    "distribution": {
      "countries": [],
      "regions": [],
      "native": true
    },
    "seasonality": {
      "active_months": [],
      "peak_season": ""
    },
    "host_plants": [],
    "nectar_plants": [],
    "behavior": {
      "flight_pattern": "",
      "migration": "",
      "feeding": "",
      "activity": ""
    },
    "life_cycle": {
      "egg": "",
      "larva": "",
      "pupa": "",
      "adult": ""
    },
    "lifespan": "",
    "conservation": {
      "status": "",
      "population_trend": "",
      "rare": false,
      "protected": false
    },
    "ecological_role": "",
    "interesting_facts": [
      "",
      "",
      ""
    ]
  },
  "similar_species": [
    {
      "name": "",
      "difference": ""
    }
  ],
  "user_guidance": {
    "how_to_identify_next_time": "",
    "best_photo_tips": "",
    "certainty_explanation": ""
  },
  "warnings": [],
  "disclaimer": ""
}

---

## Identification Guidelines

The AI must explain WHY the butterfly was identified.

Example:

* Wing shape matches Papilio species.
* Black forewings with white spots.
* Distinct swallowtail extensions.
* Characteristic vein structure.
* Typical body coloration.
* Antenna shape.
* Eye spot arrangement.

Do not simply return the name.

---

## Image Quality Analysis

Evaluate:

* Lighting
* Blur
* Distance
* Visibility
* Butterfly size in frame
* Wing visibility
* Background complexity
* Camera angle

Provide recommendations if image quality affects confidence.

---

## Confidence Rules

95–100%
Very High Confidence

85–94%
High Confidence

70–84%
Moderate Confidence

Below 70%
Low Confidence

Below 50%
Do not claim exact identification.
Suggest likely matches instead.

---

## Safety Rules

If the image does not contain a true adult butterfly, you MUST set
`detection.contains_butterfly` to false, set `detection.life_stage` to what you
actually see (e.g. "moth", "caterpillar", "bird", "object", "none"), and leave
`identification.scientific_name` and `identification.common_name` empty/null.

Never fabricate a butterfly identification for:

* moth
* caterpillar / larva / chrysalis / pupa / egg
* bird, spider, or any other animal
* flower, leaf, plant, or background
* phone, screen, hand, or any man-made object
* blurry / empty frames

A moth is NOT a butterfly — do not report a butterfly species for a moth.

---

## Output Requirements

* Return ONLY valid JSON.
* No Markdown.
* No explanations outside JSON.
* Do not invent scientific facts.
* Use null where data cannot be determined.
* Ensure all keys are present, even if values are null.
"""


# ── Public API ─────────────────────────────────────────────────────────────────

def identify_butterfly(image_bytes_list: list[bytes]) -> dict:
    """
    Call Google Gemini Vision and return a normalised identification dict:
    {
        "is_butterfly": bool,
        "identified": bool,
        "image_quality": str,
        "matches": [{"common_name", "scientific_name", "confidence",
                     "reasoning", "visible_features"}, ...],
        "notes": str,
        "raw_text": str,
        "raw_json": dict,
    }
    Raises ValueError if the API key is missing or the call fails fatally.
    """
    api_key = current_app.config.get("VERTEX_AI_API_KEY", "")
    model_name = current_app.config.get("VERTEX_AI_MODEL", "gemini-1.5-flash")

    if not api_key:
        raise ValueError(
            "VERTEX_AI_API_KEY is not configured. "
            "Add it to your .env file to enable AI identification."
        )

    # Build the contents: text instruction prompt + decoded image(s).
    parts = [{"text": "Identify this butterfly."}]
    import base64
    valid_images = 0
    
    for raw in image_bytes_list[:3]:
        jpeg = _to_jpeg_bytes(raw)
        if jpeg is None:
            continue
        
        valid_images += 1
        b64_img = base64.b64encode(jpeg).decode('utf-8')
        parts.append({
            "inlineData": {
                "mimeType": "image/jpeg",
                "data": b64_img
            }
        })

    if valid_images == 0:
        raise ValueError("No valid images could be decoded for Gemini Vision.")

    endpoint = f"https://generativelanguage.googleapis.com/v1beta/models/{model_name}:generateContent"
    
    payload = {
        "contents": [
            {
                "role": "user",
                "parts": parts
            }
        ],
        "systemInstruction": {
            "role": "system",
            "parts": [
                {"text": _SYSTEM_PROMPT}
            ]
        },
        "generationConfig": {
            "temperature": 0.1,
            "responseMimeType": "application/json"
        }
    }

    url = f"{endpoint}?key={api_key}"

    # Call the API with exponential backoff on transient errors
    resp_text = None
    input_tokens = None
    output_tokens = None
    total_tokens = None
    for attempt in range(3):
        try:
            response = http.post(url, json=payload, timeout=30)
            response.raise_for_status()
            resp_json = response.json()
            if "candidates" in resp_json and len(resp_json["candidates"]) > 0:
                resp_text = resp_json["candidates"][0]["content"]["parts"][0]["text"]
                usage_metadata = resp_json.get("usageMetadata", {})
                input_tokens = usage_metadata.get("promptTokenCount")
                output_tokens = usage_metadata.get("candidatesTokenCount")
                total_tokens = usage_metadata.get("totalTokenCount")
            else:
                raise ValueError(f"Unexpected response format: {resp_json}")
            break
        except Exception as exc:
            # Check for transient/quota errors (429, 503, etc.)
            exc_str = str(exc).lower()
            if hasattr(exc, 'response') and exc.response is not None:
                exc_str += " " + exc.response.text.lower()
                
            is_transient = any(code in exc_str for code in ["429", "503", "quota", "rate limit"])
            if is_transient and attempt < 2:
                time.sleep(2 * (attempt + 1))
                continue
            raise ValueError(f"Gemini API returned error: {exc_str}")

    if not resp_text:
        raise ValueError("Gemini returned an empty response.")

    parsed = _parse_response(resp_text)

    # ── Map the new extensive JSON format to the internal expected structure ──
    detection = parsed.get("detection", {})
    # Fail-safe: default to False. If Gemini can't positively confirm a
    # butterfly, we must NOT accept the identification (a phone/leaf/bird must
    # never be labelled as a butterfly).
    is_butterfly = bool(detection.get("contains_butterfly", False))

    # The image may contain a moth, caterpillar, chrysalis, or egg. This app
    # tracks adult butterflies only — reject every other life stage / order.
    life_stage = str(detection.get("life_stage") or "").strip().lower()
    if _is_non_butterfly_stage(life_stage):
        is_butterfly = False

    raw_matches = []

    # Only build matches when we actually detected a butterfly. This guarantees
    # a non-butterfly image can never surface a species name to the user.
    if is_butterfly:
        # 1. Main Identification
        main_id = parsed.get("identification", {})
        if main_id and main_id.get("scientific_name"):
            # The new prompt outputs confidence as 0-100. Map back to 0.0-1.0.
            conf_val = main_id.get("confidence", 0)
            conf = conf_val / 100.0 if isinstance(conf_val, (int, float)) else 0.0

            reasoning = parsed.get("identification_reason", {}).get("summary", "")
            raw_matches.append({
                "common_name": main_id.get("common_name", ""),
                "scientific_name": main_id.get("scientific_name", ""),
                "confidence": conf,
                "reasoning": reasoning,
                "visible_features": parsed.get("identification_reason", {}).get("key_features", [])
            })

        # 2. Alternative Matches
        for alt in parsed.get("alternative_matches", []):
            if not isinstance(alt, dict) or not alt.get("scientific_name"):
                continue
            conf_val = alt.get("confidence", 0)
            conf = conf_val / 100.0 if isinstance(conf_val, (int, float)) else 0.0
            raw_matches.append({
                "common_name": alt.get("common_name", ""),
                "scientific_name": alt.get("scientific_name", ""),
                "confidence": conf,
                "reasoning": alt.get("reason", ""),
                "visible_features": []
            })

    main_id = parsed.get("identification", {})
    identified = bool(is_butterfly and main_id.get("scientific_name"))

    return {
        "is_butterfly": is_butterfly,
        "identified":   identified,
        "image_quality": str(parsed.get("image_quality", {}).get("rating", "unknown")),
        "matches":      _normalise_matches(raw_matches),
        "notes":        str(parsed.get("user_guidance", {}).get("certainty_explanation", "")),
        "raw_text":     resp_text,
        "raw_json":     parsed,
        "input_token_count": input_tokens,
        "output_token_count": output_tokens,
        "total_token_count": total_tokens,
    }


def download_image_bytes(url: str) -> bytes:
    """
    Download image from a URL.
    Handles both CDN URLs (http/https) and local dev paths (/uploads/...).
    """
    if "/uploads/" in url:
        from pathlib import Path
        rel = url.split("/uploads/", 1)[1]
        configured = current_app.config.get("UPLOAD_DIR", "")
        uploads_root = Path(configured) if configured else \
            Path(current_app.root_path).parent / "uploads"
        local_path = uploads_root / rel
        if not local_path.exists():
            raise FileNotFoundError(f"Local image not found: {local_path}")
        return local_path.read_bytes()

    resp = http.get(url, timeout=20)
    resp.raise_for_status()
    return resp.content


# ── Species DB matching ────────────────────────────────────────────────────────

def find_species_id(scientific_name: str, common_name: str) -> str | None:
    """
    Resolve a returned name to a Species.id in our database.
    Matching priority:
      1. Exact scientific name (case-insensitive)
      2. Difflib similarity ≥ 0.85 on scientific name
      3. Genus-level fallback with similarity ≥ 0.75
      4. Common name contains / similarity ≥ 0.80
    Returns None if no confident match is found.
    """
    from app.supabase_client import get_supabase

    sci_lower  = (scientific_name or "").strip().lower()
    comm_lower = (common_name or "").strip().lower()
    genus      = sci_lower.split()[0] if sci_lower else ""

    sb = get_supabase()
    candidates = (
        sb.table("species").select("id, scientific_name, common_name")
        .eq("is_active", True).limit(10000).execute().data
    )
    best_id    = None
    best_score = 0.0

    for sp in candidates:
        sp_sci  = sp["scientific_name"].lower()
        sp_comm = sp["common_name"].lower()

        if sci_lower and sp_sci == sci_lower:
            return sp["id"]

        if sci_lower:
            sim = SequenceMatcher(None, sp_sci, sci_lower).ratio()
            if sim > best_score:
                best_score = sim
                best_id    = sp["id"]

        if genus and sp_sci.startswith(genus):
            score = 0.75 + SequenceMatcher(None, sp_sci, sci_lower).ratio() * 0.25
            if score > best_score:
                best_score = score
                best_id    = sp["id"]

        if comm_lower:
            sim_c = SequenceMatcher(None, sp_comm, comm_lower).ratio()
            if comm_lower in sp_comm or sp_comm in comm_lower:
                sim_c = max(sim_c, 0.85)
            if sim_c > best_score:
                best_score = sim_c
                best_id    = sp["id"]

    return best_id if best_score >= 0.75 else None


# ── Internal helpers ───────────────────────────────────────────────────────────

def _is_non_butterfly_stage(life_stage: str) -> bool:
    """
    True when the detected life stage / order is anything other than an adult
    butterfly. Moths, caterpillars, chrysalises and eggs are all rejected —
    this app only tracks adult butterflies.
    """
    if not life_stage:
        return False
    disallowed = ("moth", "caterpillar", "larva", "chrysalis",
                  "pupa", "egg", "cocoon")
    return any(word in life_stage for word in disallowed)


def _to_jpeg_bytes(raw: bytes) -> bytes | None:
    """Decode arbitrary image bytes and re-encode as RGB JPEG."""
    try:
        pil_img = Image.open(io.BytesIO(raw))
        if pil_img.mode not in ("RGB", "L"):
            pil_img = pil_img.convert("RGB")
        buf = io.BytesIO()
        pil_img.save(buf, format="JPEG", quality=90)
        return buf.getvalue()
    except Exception as exc:
        log.warning("Could not decode image: %s", exc)
        return None


def _parse_response(raw_text: str) -> dict:
    """Parse the JSON response, with a fallback regex extraction."""
    try:
        return json.loads(raw_text)
    except json.JSONDecodeError:
        pass

    m = re.search(r"\{.*\}", raw_text, re.DOTALL)
    if m:
        try:
            return json.loads(m.group())
        except json.JSONDecodeError:
            pass

    log.error("Gemini returned unparseable response: %.300s", raw_text)
    raise ValueError(f"Gemini returned a non-JSON response: {raw_text[:200]!r}")


def _normalise_matches(raw_matches: list) -> list:
    """Clamp confidence to [0, 1] and ensure required fields exist."""
    normalised = []
    for m in raw_matches:
        if not isinstance(m, dict):
            continue
        normalised.append({
            "common_name":     str(m.get("common_name", "Unknown")),
            "scientific_name": str(m.get("scientific_name", "Unknown")),
            "confidence":      max(0.0, min(1.0, float(m.get("confidence", 0.0)))),
            "reasoning":       str(m.get("reasoning", "")),
            "visible_features": list(m.get("visible_features", [])),
        })
    normalised.sort(key=lambda x: x["confidence"], reverse=True)
    return normalised[:3]
