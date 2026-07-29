"use client";

import { useEffect, useRef, useState } from "react";
import Link from "next/link";
import ButterflyFlyers from "../components/ButterflyFlyers";
import FlightPathButterfly from "../components/FlightPathButterfly";

const BANDS = [
  {
    min: 90,
    name: "Certain",
    colour: "#2ECC71",
    advice: "File it and move on",
    note: "Above 90% the model has locked onto diagnostic wing markings. The species is filled in for you; you just confirm.",
  },
  {
    min: 70,
    name: "Likely",
    colour: "#2D9E82",
    advice: "Worth a second look",
    note: "Between 70 and 90 the top match is probably right, but the app shows you the runners-up so you can compare underwings yourself.",
  },
  {
    min: 50,
    name: "Possible",
    colour: "#F39C12",
    advice: "Add another photo",
    note: "Between 50 and 70 the shot is usually the problem, not the butterfly. Another angle — especially the underside — normally settles it.",
  },
  {
    min: 30,
    name: "Uncertain",
    colour: "#E74C3C",
    advice: "Log it anyway",
    note: "Under 50 the app says so plainly. Submit the sighting regardless: a human moderator can identify from photographs the model finds hard.",
  },
  {
    min: 0,
    name: "No match",
    colour: "#7E9188",
    advice: "Below the floor",
    note: "Anything under 30% is never surfaced as a suggestion at all. The app would rather show you nothing than show you something wrong.",
  },
];

export default function Home() {
  const [confidence, setConfidence] = useState(94);
  const [currentYear, setCurrentYear] = useState(2026);
  const showcaseTrackRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    setCurrentYear(new Date().getFullYear());
  }, []);

  const activeBand = BANDS.find((b) => confidence >= b.min) || BANDS[BANDS.length - 1];

  const handlePointerMove = (e: React.PointerEvent<HTMLElement>) => {
    const card = e.currentTarget;
    const r = card.getBoundingClientRect();
    const x = ((e.clientX - r.left) / r.width) * 100;
    const y = ((e.clientY - r.top) / r.height) * 100;
    card.style.setProperty("--mx", `${x}%`);
    card.style.setProperty("--my", `${y}%`);
  };

  const handleScrollShowcase = (dir: number) => {
    if (showcaseTrackRef.current) {
      const card = showcaseTrackRef.current.firstElementChild as HTMLElement;
      if (card) {
        const cardWidth = card.offsetWidth + 24; // Card width + gap
        showcaseTrackRef.current.scrollBy({
          left: dir * cardWidth * 2,
          behavior: "smooth",
        });
      }
    }
  };

  return (
    <>
      {/* ══════════ NAV ══════════ */}
      <nav className="nav">
        <div className="nav-in">
          <a className="brand" href="#top">
            <img className="mark" src="images/pathanga_logo.png" alt="Pathanga Logo" />
            <span className="wordmark">
              Pathanga<small>Butterfly India</small>
            </span>
          </a>
          <div className="nav-links">
            <a href="#features">Features</a>
            <a href="#how">How it works</a>
            <a href="#ai">The AI</a>
            <a href="#explorer">Explorer</a>
            <a href="#science">Science</a>
            <a href="#showcase">Gallery</a>
          </div>
          <a href="#get" className="btn btn-solid">
            Get the app
          </a>
        </div>
      </nav>

      {/* ══════════ HERO ══════════ */}
      <header className="hero" id="top">
        <ButterflyFlyers host="hero" />
        <div className="wrap hero-grid">
          <div>
            <span className="hero-eyebrow fade-up" style={{ "--d": ".05s" } as React.CSSProperties}>
              <i className="dot"></i>
              <span className="tag" style={{ letterSpacing: ".2em" }}>
                Free · Citizen science · India
              </span>
            </span>

            <h1>
              <span className="line">
                <span style={{ "--i": 0 } as React.CSSProperties}>Every wing</span>
              </span>
              <span className="line">
                <span style={{ "--i": 1 } as React.CSSProperties}>carries a</span>
              </span>
              <span className="line">
                <span style={{ "--i": 2 } as React.CSSProperties}>
                  <em className="script">record.</em>
                </span>
              </span>
            </h1>

            <p className="lede fade-up" style={{ "--d": ".5s" } as React.CSSProperties}>
              Pathanga turns your phone into a field lab. Photograph a butterfly, get an AI identification in seconds, and log a sighting that becomes real biodiversity data — reviewed by experts, mapped across all 28 states.
            </p>

            <div className="hero-cta fade-up" style={{ "--d": ".62s" } as React.CSSProperties}>
              <div className="stores">
                <a
                  className="store"
                  href="https://play.google.com/store/apps/details?id=com.thardeye.butterfly_india"
                  aria-label="Get Pathanga on Google Play"
                >
                  <svg viewBox="0 0 512 512" aria-hidden="true">
                    <path fill="#2D9E82" d="M47 24c-6 6-9 15-9 27v410c0 12 3 21 9 27l2 2 229-229v-11L49 22z" />
                    <path fill="#E8B84B" d="M354 343l-77-77v-11l77-77 2 1 91 52c26 15 26 39 0 54l-91 52z" />
                    <path fill="#FF8A3D" d="M356 344l-79-79L47 495c9 9 23 10 39 1l270-152" />
                    <path fill="#4A90E2" d="M356 168L86 16C70 7 56 8 47 17l230 230z" />
                  </svg>
                  <span className="txt">
                    <small>Get it on</small>
                    <strong>Google Play</strong>
                  </span>
                </a>

                <span className="store soon">
                  <svg viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
                    <path d="M17.05 12.54c-.03-2.9 2.37-4.3 2.48-4.36-1.35-1.98-3.46-2.25-4.21-2.28-1.79-.18-3.5 1.05-4.41 1.05-.91 0-2.31-1.03-3.8-1-1.96.03-3.76 1.14-4.77 2.89-2.03 3.53-.52 8.75 1.46 11.61.97 1.4 2.12 2.97 3.63 2.91 1.46-.06 2.01-.94 3.77-.94s2.26.94 3.8.91c1.57-.03 2.56-1.42 3.52-2.83 1.11-1.62 1.57-3.19 1.59-3.27-.03-.02-3.05-1.17-3.08-4.65zM14.2 4.08c.8-.98 1.35-2.33 1.2-3.68-1.16.05-2.57.77-3.4 1.74-.74.86-1.39 2.24-1.22 3.56 1.3.1 2.62-.66 3.42-1.62z" />
                  </svg>
                  <span className="txt">
                    <small>Coming to</small>
                    <strong>
                      App Store <b className="badge">Soon</b>
                    </strong>
                  </span>
                </span>
              </div>
              <p className="hero-note">Android 8.0+ · 1,500+ species offline · No ads, no paywall</p>
            </div>
          </div>

          {/* Phone */}
          <div className="device-stage fade-up" style={{ "--d": ".35s" } as React.CSSProperties}>
            <div className="phone">
              <div className="screen">
                <div className="notch"></div>
                <div className="statusbar">
                  <span>9:41</span>
                  <span>◍ ▮▮▮</span>
                </div>

                <div className="viewfinder">
                  <svg className="leafy" viewBox="0 0 200 260" preserveAspectRatio="xMidYMid slice" aria-hidden="true">
                    <path
                      d="M-10 220 C40 150 70 190 120 120 C150 80 180 90 210 40"
                      stroke="#3d6b4c"
                      strokeWidth="9"
                      fill="none"
                      opacity=".55"
                    />
                    <path
                      d="M-10 260 C60 220 90 240 140 200 C170 175 200 180 220 150"
                      stroke="#2c5138"
                      strokeWidth="14"
                      fill="none"
                      opacity=".5"
                    />
                    <ellipse cx="52" cy="176" rx="26" ry="12" fill="#3f7350" opacity=".55" transform="rotate(-28 52 176)" />
                    <ellipse cx="146" cy="112" rx="30" ry="13" fill="#478058" opacity=".5" transform="rotate(22 146 112)" />
                  </svg>

                  <svg
                    className="subject bfly"
                    viewBox="0 0 120 100"
                    aria-hidden="true"
                    style={{ "--flap": ".6s" } as React.CSSProperties}
                  >
                    <g className="w wl">
                      <path d="M59,33 C50,17 30,3 14,7 C2,10 1,32 13,44 C25,55 48,54 58,50 Z" fill="#F4EEE3" />
                      <path d="M14,7 C2,10 1,32 13,44 C22,51 34,53 43,52 C31,40 20,24 14,7 Z" fill="#FF8A3D" />
                      <path d="M58,52 C44,54 25,58 19,69 C13,81 26,93 38,88 C50,83 57,67 59,56 Z" fill="#EDE3D2" />
                    </g>
                    <g transform="translate(120,0) scale(-1,1)">
                      <g className="w wr">
                        <path d="M59,33 C50,17 30,3 14,7 C2,10 1,32 13,44 C25,55 48,54 58,50 Z" fill="#F4EEE3" />
                        <path d="M14,7 C2,10 1,32 13,44 C22,51 34,53 43,52 C31,40 20,24 14,7 Z" fill="#FF8A3D" />
                        <path d="M58,52 C44,54 25,58 19,69 C13,81 26,93 38,88 C50,83 57,67 59,56 Z" fill="#EDE3D2" />
                      </g>
                    </g>
                    <ellipse cx="60" cy="54" rx="3" ry="21" fill="#2a2118" />
                    <path d="M60,34 C56,24 50,18 44,15" stroke="#2a2118" strokeWidth="1.5" fill="none" strokeLinecap="round" />
                    <path d="M60,34 C64,24 70,18 76,15" stroke="#2a2118" strokeWidth="1.5" fill="none" strokeLinecap="round" />
                  </svg>

                  <div className="reticle">
                    <span></span>
                    <span></span>
                    <span></span>
                    <span></span>
                  </div>
                  <div className="scanline"></div>
                </div>

                <div className="result">
                  <div className="rt">◈ Identified · 1.4s</div>
                  <div className="cn">Great Orange Tip</div>
                  <div className="sn">Hebomoia glaucippe</div>
                  <div className="meter">
                    <i></i>
                  </div>
                  <div className="rr">
                    <span>Confidence 94%</span>
                    <span>Certain</span>
                  </div>
                </div>

                <div className="chips">
                  <b>Save</b>
                  <b className="on">Log sighting</b>
                  <b>Guide</b>
                </div>

                <div className="tabbar">
                  <i></i>
                  <i></i>
                  <i className="act"></i>
                  <i></i>
                  <i></i>
                </div>
              </div>
            </div>
          </div>
        </div>
      </header>

      {/* ══════════ STAT BAND ══════════ */}
      <div className="band">
        <div className="band-in">
          <div>
            <div className="n">
              1,500<span>+</span>
            </div>
            <div className="l">Indian species</div>
          </div>
          <div>
            <div className="n">28</div>
            <div className="l">States mapped</div>
          </div>
          <div>
            <div className="n">
              &lt;60<span>s</span>
            </div>
            <div className="l">AI identification</div>
          </div>
          <div>
            <div className="n">
              100<span>%</span>
            </div>
            <div className="l">Works offline</div>
          </div>
        </div>
      </div>

      {/* ══════════ FEATURES ══════════ */}
      <section id="features">
        <div className="wrap">
          <div className="plate-head">
            <span className="no">Plate I</span>
            <div className="ttl">
              <h2>
                What&apos;s inside
                <br />
                the app
              </h2>
            </div>
            <span className="meta">Five capabilities · plus</span>
          </div>

          <div className="specimens">
            {/* 01 */}
            <article className="spec wide" style={{ "--accent": "#4A90E2" } as React.CSSProperties} onPointerMove={handlePointerMove}>
              <div className="spec-no">№ 01 — Identification</div>
              <div className="spec-ico">
                <svg
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  strokeWidth="1.6"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                >
                  <path d="M3 8V5a2 2 0 0 1 2-2h3M16 3h3a2 2 0 0 1 2 2v3M21 16v3a2 2 0 0 1-2 2h-3M8 21H5a2 2 0 0 1-2-2v-3" />
                  <circle cx="12" cy="12" r="3.4" />
                </svg>
              </div>
              <h3>Point, shoot, know</h3>
              <p>
                Gemini Vision reads the photo through a lepidopterist&apos;s prompt and returns ranked matches resolved against the species catalogue — not a guess, a shortlist with a confidence score you can argue with.
              </p>
              <ul className="facts">
                <li>Up to 5 photos</li>
                <li>Confidence-scored</li>
                <li>60s timeout</li>
                <li>Ranked matches</li>
              </ul>
            </article>

            {/* 02 */}
            <article className="spec wide" style={{ "--accent": "#E8B84B" } as React.CSSProperties} onPointerMove={handlePointerMove}>
              <div className="spec-no">№ 02 — Field guide</div>
              <div className="spec-ico">
                <svg
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  strokeWidth="1.6"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                >
                  <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20" />
                  <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z" />
                  <path d="M10 7h6M10 11h4" />
                </svg>
              </div>
              <h3>A guide that fits in a pocket</h3>
              <p>
                Every species carries family and genus, habitat notes, wingspan range, the months it flies, its IUCN status and reference plates for egg, caterpillar, pupa, male and female.
              </p>
              <ul className="facts">
                <li>Taxonomy</li>
                <li>Seasonality</li>
                <li>Life stages</li>
                <li>Colour search</li>
              </ul>
            </article>

            {/* 03 */}
            <article className="spec" style={{ "--accent": "#2D9E82" } as React.CSSProperties} onPointerMove={handlePointerMove}>
              <div className="spec-no">№ 03 — Logging</div>
              <div className="spec-ico">
                <svg
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  strokeWidth="1.6"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                >
                  <path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0z" />
                  <circle cx="12" cy="10" r="2.6" />
                </svg>
              </div>
              <h3>A sighting in under a minute</h3>
              <p>Camera or gallery, GPS stamped automatically, place name resolved, notes if you want them. Choose public or private per sighting.</p>
              <ul className="facts">
                <li>Auto GPS</li>
                <li>Privacy control</li>
              </ul>
            </article>

            {/* 04 */}
            <article className="spec" style={{ "--accent": "#FF8A3D" } as React.CSSProperties} onPointerMove={handlePointerMove}>
              <div className="spec-no">№ 04 — Offline</div>
              <div className="spec-ico">
                <svg
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  strokeWidth="1.6"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                >
                  <path d="M18 10h-1.3A7 7 0 1 0 5 16" />
                  <path d="M12 12v9M8.5 17.5 12 21l3.5-3.5" />
                </svg>
              </div>
              <h3>The forest has no signal</h3>
              <p>Sightings queue on-device and upload themselves when the bars come back — five automatic retries, photos and all. The guide stays cached for reading.</p>
              <ul className="facts">
                <li>Local database</li>
                <li>Auto-sync</li>
              </ul>
            </article>

            {/* 05 */}
            <article className="spec" style={{ "--accent": "#9B59B6" } as React.CSSProperties} onPointerMove={handlePointerMove}>
              <div className="spec-no">№ 05 — Maps</div>
              <div className="spec-ico">
                <svg
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  strokeWidth="1.6"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                >
                  <path d="m9 4-6 2.5v14L9 18l6 2.5 6-2.5V4l-6 2.5z" />
                  <path d="M9 4v14M15 6.5v14" />
                </svg>
              </div>
              <h3>See what flies near you</h3>
              <p>Density maps by state and district, plus everything recorded within 50 km of where you&apos;re standing — including the hotspot belts of the Western Ghats, the Northeast and the Himalaya.</p>
              <ul className="facts">
                <li>Heatmaps</li>
                <li>50 km radius</li>
              </ul>
            </article>
          </div>

          {/* Also inside */}
          <div className="minor">
            <div>
              <h4>Community feed</h4>
              <p>Follow what other naturalists are finding today, with likes, comments and public explorer profiles.</p>
            </div>
            <div>
              <h4>Notifications, your rules</h4>
              <p>Per-category switches — identification finished, sighting verified, something rare spotted nearby.</p>
            </div>
            <div>
              <h4>Light &amp; dark</h4>
              <p>A dark theme built for dawn walks and a light one for glare, with haptics and large-text support.</p>
            </div>
            <div>
              <h4>Your archive</h4>
              <p>Every sighting you&apos;ve made, searchable, with saved species and a lifetime tally of states explored.</p>
            </div>
          </div>
        </div>
      </section>

      {/* ══════════ HOW IT WORKS ══════════ */}
      <section id="how" className="flight">
        <svg className="path-svg" viewBox="0 0 1300 520" preserveAspectRatio="none" aria-hidden="true">
          <path d="M 40,300 C 260,120 460,470 700,250 C 900,70 1080,400 1260,190" />
        </svg>
        <FlightPathButterfly />

        <div className="wrap">
          <div className="plate-head">
            <span className="no">Plate II</span>
            <div className="ttl">
              <h2>
                From a glimpse
                <br />
                to a data point
              </h2>
            </div>
            <span className="meta">Four movements</span>
          </div>

          <div className="steps">
            <div className="step">
              <div className="num">01</div>
              <div className="t">In the field</div>
              <h3>Catch it on camera</h3>
              <p>Up to five frames — upperside, underside, whatever it gives you before it moves on.</p>
            </div>
            <div className="step">
              <div className="num">02</div>
              <div className="t">Seconds later</div>
              <h3>The AI reads the wings</h3>
              <p>Photos go to the vision model, which returns ranked candidates matched to catalogued species.</p>
            </div>
            <div className="step">
              <div className="num">03</div>
              <div className="t">Same day</div>
              <h3>You confirm and log</h3>
              <p>Accept a match or pick your own from the guide, then file the sighting with its coordinates.</p>
            </div>
            <div className="step">
              <div className="num">04</div>
              <div className="t">Afterwards</div>
              <h3>An expert verifies it</h3>
              <p>Moderators and verified researchers review the record before it joins the public map.</p>
            </div>
          </div>
        </div>
      </section>

      {/* ══════════ AI / CONFIDENCE ══════════ */}
      <section id="ai" className="ai">
        <div className="wrap">
          <div className="plate-head">
            <span className="no">Plate III</span>
            <div className="ttl">
              <h2>
                An AI that admits
                <br />
                when it isn&apos;t sure
              </h2>
            </div>
            <span className="meta">Interactive</span>
          </div>

          <div className="ai-grid">
            <div>
              <p className="lede">
                Most identification apps hand you a name and let you assume it&apos;s right. Pathanga hands you a number. Every match arrives with a confidence score, sorted into four honest bands — and anything under 30% is never shown at all.
              </p>
              <p style={{ marginTop: "1.4rem", color: "var(--muted)", fontSize: ".93rem", maxWidth: "52ch" }}>
                Drag the marker to see how the app grades its own answer. The thresholds below are the real ones the app ships with.
              </p>
            </div>

            <div className="gauge">
              <div className="gauge-top">
                <div className="gauge-val" style={{ color: activeBand.colour }}>
                  {confidence}
                  <span style={{ fontSize: ".4em" }}>%</span>
                </div>
                <div className="gauge-band" style={{ color: activeBand.colour }}>
                  {activeBand.name}
                  <small style={{ color: "var(--muted)", letterSpacing: ".14em", marginTop: ".35rem", fontSize: ".58rem", display: "block" }}>
                    {activeBand.advice}
                  </small>
                </div>
              </div>

              <div className="track">
                <span
                  style={{
                    display: "block",
                    height: "100%",
                    borderRadius: "100px",
                    background: "linear-gradient(90deg, rgba(244,238,227,.28), rgba(244,238,227,.5))",
                    mixBlendMode: "overlay",
                    transition: "width .18s linear",
                    width: `${confidence}%`,
                  }}
                />
              </div>
              <input
                className="slider"
                type="range"
                min="0"
                max="100"
                value={confidence}
                onChange={(e) => setConfidence(Number(e.target.value))}
                aria-label="AI confidence level"
              />
              <div className="ticks">
                <span>0</span>
                <span>50 · possible</span>
                <span>70 · likely</span>
                <span>90 · certain</span>
              </div>

              <p className="gauge-note">{activeBand.note}</p>
            </div>
          </div>
        </div>
      </section>

      {/* ══════════ EXPLORER / GAMIFICATION ══════════ */}
      <section id="explorer">
        <div className="wrap">
          <div className="plate-head">
            <span className="no">Plate IV</span>
            <div className="ttl">
              <h2>
                Fieldwork, kept
                <br />
                like a scorecard
              </h2>
            </div>
            <span className="meta">Explorer profile</span>
          </div>

          <div className="xp-grid">
            <div>
              <div className="streak">
                <div className="big">
                  <svg className="flame" viewBox="0 0 24 30" aria-hidden="true">
                    <path d="M12 0C12 6 5 8 5 16a7 7 0 0 0 14 0c0-4-2-6-4-9 0 3-1.5 4-3 4 1-4-1-8-0-11z" fill="#FF8A3D" />
                    <path d="M12 11c0 3-3 4-3 7a3 3 0 0 0 6 0c0-2-2-3-3-7z" fill="#E8B84B" />
                  </svg>
                  14 <small>day streak</small>
                </div>
                <p style={{ color: "var(--paper-dim)", fontSize: ".9rem", marginTop: ".9rem" }}>
                  Log one sighting a day to keep it alive. Miss the deadline by a few hours and a six-hour grace period covers you — because sometimes the light goes before the butterfly does.
                </p>
              </div>

              <div className="badges">
                <span className="badge-chip" style={{ "--tone": "#78909C" } as React.CSSProperties}>
                  <i className="pip"></i>Common
                </span>
                <span className="badge-chip" style={{ "--tone": "#43A047" } as React.CSSProperties}>
                  <i className="pip"></i>Uncommon
                </span>
                <span className="badge-chip" style={{ "--tone": "#1E88E5" } as React.CSSProperties}>
                  <i className="pip"></i>Rare
                </span>
                <span className="badge-chip" style={{ "--tone": "#8E24AA" } as React.CSSProperties}>
                  <i className="pip"></i>Very rare
                </span>
                <span className="badge-chip" style={{ "--tone": "#E53935" } as React.CSSProperties}>
                  <i className="pip"></i>Endangered
                </span>
              </div>
              <p className="tag" style={{ marginTop: "1rem" }}>
                Rarity tiers · earned per species, not per photo
              </p>
            </div>

            <div className="ledger">
              <div className="row">
                <span className="what">
                  Log a sighting<span className="why">Any species, anywhere</span>
                </span>
                <span className="xp">+10 XP</span>
              </div>
              <div className="row">
                <span className="what">
                  Confirm an identification<span className="why">You closed the loop</span>
                </span>
                <span className="xp">+25 XP</span>
              </div>
              <div className="row">
                <span className="what">
                  Record a rare species<span className="why">Rare tier and above</span>
                </span>
                <span className="xp">+50 XP</span>
              </div>
              <div className="row">
                <span className="what">
                  First in your district<span className="why">Nobody had logged it here</span>
                </span>
                <span className="xp">+100 XP</span>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* ══════════ SCIENCE ══════════ */}
      <section id="science" style={{ background: "linear-gradient(180deg,var(--ink),var(--ink-2))", borderTop: "1px solid var(--line-soft)" }}>
        <div className="wrap">
          <div className="plate-head">
            <span className="no">Plate V</span>
            <div className="ttl">
              <h2>
                Your weekend walk,
                <br />
                somebody&apos;s dataset
              </h2>
            </div>
            <span className="meta">Verification</span>
          </div>

          <p className="lede">
            Butterflies are the fastest indicator we have of a habitat turning. They respond to a changed monsoon, a cleared hedgerow or a warmer winter within a season. What they lack is observers — and that is the part a phone can fix.
          </p>

          <div className="pipeline">
            <div>
              <div className="st">Stage one</div>
              <h4>Submitted</h4>
              <p>Your sighting lands with photographs, coordinates, a timestamp and the AI&apos;s suggestion attached.</p>
            </div>
            <div>
              <div className="st">Stage two</div>
              <h4>Reviewed</h4>
              <p>A moderator or a verified researcher confirms the species, corrects it, or asks for a better frame.</p>
            </div>
            <div>
              <div className="st">Stage three</div>
              <h4>Published</h4>
              <p>Verified records join the public distribution maps and the state-level counts that researchers draw on.</p>
            </div>
          </div>
        </div>
      </section>

      {/* ══════════ SHOWCASE ══════════ */}
      <section id="showcase" className="showcase">
        <div className="wrap">
          <div className="plate-head">
            <span className="no">Plate VI</span>
            <div className="ttl">
              <h2>The app in action</h2>
            </div>
            <span className="meta">Eight specimen views</span>
          </div>

          <div className="showcase-container">
            <button className="showcase-nav prev" aria-label="Previous screen" onClick={() => handleScrollShowcase(-1)}>
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <polyline points="15 18 9 12 15 6"></polyline>
              </svg>
            </button>

            <div className="showcase-track" id="showcaseTrack" ref={showcaseTrackRef}>
              <div className="showcase-item">
                <div className="showcase-card">
                  <span className="showcase-no">№ 01</span>
                  <div className="showcase-img-wrap">
                    <img src="images/Artboard 1.jpg" alt="Pathanga App Screenshot 1" loading="lazy" />
                  </div>
                  <span className="showcase-cap">Splash Screen</span>
                </div>
              </div>
              <div className="showcase-item">
                <div className="showcase-card">
                  <span className="showcase-no">№ 02</span>
                  <div className="showcase-img-wrap">
                    <img src="images/Artboard 2.jpg" alt="Pathanga App Screenshot 2" loading="lazy" />
                  </div>
                  <span className="showcase-cap">AI Scanner</span>
                </div>
              </div>
              <div className="showcase-item">
                <div className="showcase-card">
                  <span className="showcase-no">№ 03</span>
                  <div className="showcase-img-wrap">
                    <img src="images/Artboard 3.jpg" alt="Pathanga App Screenshot 3" loading="lazy" />
                  </div>
                  <span className="showcase-cap">Observations Log</span>
                </div>
              </div>
              <div className="showcase-item">
                <div className="showcase-card">
                  <span className="showcase-no">№ 04</span>
                  <div className="showcase-img-wrap">
                    <img src="images/Artboard 4.jpg" alt="Pathanga App Screenshot 4" loading="lazy" />
                  </div>
                  <span className="showcase-cap">Detail View</span>
                </div>
              </div>
              <div className="showcase-item">
                <div className="showcase-card">
                  <span className="showcase-no">№ 05</span>
                  <div className="showcase-img-wrap">
                    <img src="images/Artboard 5.jpg" alt="Pathanga App Screenshot 5" loading="lazy" />
                  </div>
                  <span className="showcase-cap">Community Feed</span>
                </div>
              </div>
              <div className="showcase-item">
                <div className="showcase-card">
                  <span className="showcase-no">№ 06</span>
                  <div className="showcase-img-wrap">
                    <img src="images/Artboard 6.jpg" alt="Pathanga App Screenshot 6" loading="lazy" />
                  </div>
                  <span className="showcase-cap">Naturalist Profile</span>
                </div>
              </div>
              <div className="showcase-item">
                <div className="showcase-card">
                  <span className="showcase-no">№ 07</span>
                  <div className="showcase-img-wrap">
                    <img src="images/Artboard 7.jpg" alt="Pathanga App Screenshot 7" loading="lazy" />
                  </div>
                  <span className="showcase-cap">Rarity Badges</span>
                </div>
              </div>
              <div className="showcase-item">
                <div className="showcase-card">
                  <span className="showcase-no">№ 08</span>
                  <div className="showcase-img-wrap">
                    <img src="images/Artboard 8.jpg" alt="Pathanga App Screenshot 8" loading="lazy" />
                  </div>
                  <span className="showcase-cap">Species Guide</span>
                </div>
              </div>
            </div>

            <button className="showcase-nav next" aria-label="Next screen" onClick={() => handleScrollShowcase(1)}>
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <polyline points="9 18 15 12 9 6"></polyline>
              </svg>
            </button>
          </div>
        </div>
      </section>

      {/* ══════════ DOWNLOAD ══════════ */}
      <section id="get" className="download">
        <ButterflyFlyers host="download" />
        <div className="wrap dl-inner">
          <span className="tag">Free · No advertising · No paywall</span>
          <h2 style={{ margin: "1.2rem 0 1.3rem" }}>
            Start your
            <br />
            field notebook
          </h2>
          <p className="lede" style={{ marginInline: "auto" }}>
            Install Pathanga, walk outside, and photograph the first butterfly you see. That single record is more than most habitats in India have from this year.
          </p>

          <div className="stores">
            <a className="store" href="https://play.google.com/store/apps/details?id=com.thardeye.butterfly_india">
              <svg viewBox="0 0 512 512" aria-hidden="true">
                <path fill="#2D9E82" d="M47 24c-6 6-9 15-9 27v410c0 12 3 21 9 27l2 2 229-229v-11L49 22z" />
                <path fill="#E8B84B" d="M354 343l-77-77v-11l77-77 2 1 91 52c26 15 26 39 0 54l-91 52z" />
                <path fill="#FF8A3D" d="M356 344l-79-79L47 495c9 9 23 10 39 1l270-152" />
                <path fill="#4A90E2" d="M356 168L86 16C70 7 56 8 47 17l230 230z" />
              </svg>
              <span className="txt">
                <small>Get it on</small>
                <strong>Google Play</strong>
              </span>
            </a>
            <span className="store soon">
              <svg viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
                <path d="M17.05 12.54c-.03-2.9 2.37-4.3 2.48-4.36-1.35-1.98-3.46-2.25-4.21-2.28-1.79-.18-3.5 1.05-4.41 1.05-.91 0-2.31-1.03-3.8-1-1.96.03-3.76 1.14-4.77 2.89-2.03 3.53-.52 8.75 1.46 11.61.97 1.4 2.12 2.97 3.63 2.91 1.46-.06 2.01-.94 3.77-.94s2.26.94 3.8.91c1.57-.03 2.56-1.42 3.52-2.83 1.11-1.62 1.57-3.19 1.59-3.27-.03-.02-3.05-1.17-3.08-4.65zM14.2 4.08c.8-.98 1.35-2.33 1.2-3.68-1.16.05-2.57.77-3.4 1.74-.74.86-1.39 2.24-1.22 3.56 1.3.1 2.62-.66 3.42-1.62z" />
              </svg>
              <span className="txt">
                <small>Coming to</small>
                <strong>
                  App Store <b className="badge">Soon</b>
                </strong>
              </span>
            </span>
          </div>

          
        </div>
      </section>

      {/* ══════════ FOOTER ══════════ */}
      <footer>
        <div className="wrap">
          <div className="foot-grid">
            <div>
              <a className="brand" href="#top" style={{ marginBottom: "1rem" }}>
                <img className="mark" src="images/pathanga_logo.png" alt="Pathanga Logo" />
                <span className="wordmark">
                  Pathanga<small>Butterfly India</small>
                </span>
              </a>
              <p style={{ color: "var(--muted)", fontSize: ".86rem", maxWidth: "34ch" }}>
                A citizen-science record of India&apos;s butterflies, built one sighting at a time.
              </p>
            </div>
            <div>
              <h5>The app</h5>
              <ul>
                <li>
                  <a href="#features">Features</a>
                </li>
                <li>
                  <a href="#how">How it works</a>
                </li>
                <li>
                  <a href="#ai">Identification</a>
                </li>
                <li>
                  <a href="#explorer">Explorer profile</a>
                </li>
                <li>
                  <a href="#showcase">App Gallery</a>
                </li>
              </ul>
            </div>
            <div>
              <h5>Legal</h5>
              <ul>
                <li>
                  <a href="https://butterflyindia.app/privacy">Privacy policy</a>
                </li>
                <li>
                  <a href="https://butterflyindia.app/terms">Terms of use</a>
                </li>
                <li>
                  <a href="mailto:support@butterflyindia.app">support@butterflyindia.app</a>
                </li>
              </ul>
            </div>
          </div>
          <div className="foot-bottom">
            <span>© {currentYear} Pathanga · Butterfly India</span>
            <span>Made for the field</span>
          </div>
        </div>
      </footer>
    </>
  );
}
