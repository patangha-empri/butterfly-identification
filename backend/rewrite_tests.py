import re
import json

with open(r"d:\thardeye_projects\Butterfly Identification system\backend\tests\test_phase3.py", "r") as f:
    content = f.read()

new_gemini_resp = '''def _gemini_response(matches: list, is_butterfly=True, identified=True) -> MagicMock:
    """
    Build a mock requests.Response object.
    Used by TestGeminiService (unit tests) that exercise the real parsing code.
    """
    payload = {
        "is_butterfly": is_butterfly,
        "identified": identified,
        "image_quality": "good",
        "matches": matches,
        "notes": "Mock Gemini response for pytest.",
    }
    vertex_payload = {
        "candidates": [
            {
                "content": {
                    "parts": [
                        {"text": json.dumps(payload)}
                    ]
                }
            }
        ]
    }
    mock_resp = MagicMock()
    mock_resp.json.return_value = vertex_payload
    mock_resp.raise_for_status = MagicMock()
    return mock_resp'''

content = re.sub(r'def _gemini_response.*?return mock_resp', new_gemini_resp, content, flags=re.DOTALL)

# Remove _sys_modules_patch
content = re.sub(r'    @staticmethod\n    def _sys_modules_patch\(mock_model\) -> "contextmanager":.*?return patch\.dict\(sys\.modules, \{"google\.generativeai": mock_genai\}\)\n', '', content, flags=re.DOTALL)

# Replace mock_model with mock_post
content = re.sub(
    r'mock_model = MagicMock\(\)\n\s+mock_model\.generate_content\.return_value = (.*?)\n\n\s+with self\._sys_modules_patch\(mock_model\), \\\n\s+patch\.dict\(app\.config, \{"GEMINI_API_KEY": "fake-key"\}\):',
    r'with patch("app.services.gemini_service.http.post") as mock_post, \\\n                 patch.dict(app.config, {"VERTEX_AI_API_KEY": "fake-key", "VERTEX_AI_PROJECT": "p", "VERTEX_AI_LOCATION": "l"}):\n                mock_post.return_value = \1',
    content
)

# For test_malformed_json_raises_value_error
content = re.sub(
    r'mock_model = MagicMock\(\)\n\s+mock_model\.generate_content\.return_value = MagicMock\(\n\s+text="Sorry, I cannot identify that\."\n\s+\)\n\s+with self\._sys_modules_patch\(mock_model\), \\\n\s+patch\.dict\(app\.config, \{"GEMINI_API_KEY": "fake-key"\}\):',
    r'with patch("app.services.gemini_service.http.post") as mock_post, \\\n                 patch.dict(app.config, {"VERTEX_AI_API_KEY": "fake-key", "VERTEX_AI_PROJECT": "p", "VERTEX_AI_LOCATION": "l"}):\n                mock_post.return_value.json.return_value = {"candidates": [{"content": {"parts": [{"text": "Sorry, I cannot identify that."}]}}]}',
    content
)

content = content.replace('{"GEMINI_API_KEY": ""}', '{"VERTEX_AI_API_KEY": "", "VERTEX_AI_PROJECT": "p", "VERTEX_AI_LOCATION": "l"}')
content = content.replace('match="GEMINI_API_KEY"', 'match="VERTEX_AI_API_KEY"')
content = content.replace('"GEMINI_API_KEY" in (data.get("error_message")', '"VERTEX_AI_API_KEY" in (data.get("error_message")')

with open(r"d:\thardeye_projects\Butterfly Identification system\backend\tests\test_phase3.py", "w") as f:
    f.write(content)
