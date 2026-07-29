import re

with open(r"d:\thardeye_projects\Butterfly Identification system\backend\tests\test_phase3.py", "r") as f:
    content = f.read()

# Fix test_non_butterfly_returns_empty_matches
content = re.sub(
    r'mock_model = MagicMock\(\)\n\s+mock_model\.generate_content\.return_value = _gemini_response\(\n\s+\[\], is_butterfly=False, identified=False\n\s+\)\n\s+with self\._sys_modules_patch\(mock_model\), \\\n\s+patch\.dict\(app\.config, \{"GEMINI_API_KEY": "fake-key"\}\):',
    r'with patch("app.services.gemini_service.http.post") as mock_post, \\\n                 patch.dict(app.config, {"VERTEX_AI_API_KEY": "fake-key", "VERTEX_AI_PROJECT": "p", "VERTEX_AI_LOCATION": "l"}):\n                mock_post.return_value = _gemini_response([], is_butterfly=False, identified=False)',
    content
)

# Fix test_confidence_clamped_between_0_and_1
content = re.sub(
    r'mock_model = MagicMock\(\)\n\s+mock_model\.generate_content\.return_value = _gemini_response\(\[bad_match\]\)\n\s+with self\._sys_modules_patch\(mock_model\), \\\n\s+patch\.dict\(app\.config, \{"GEMINI_API_KEY": "fake-key"\}\):',
    r'with patch("app.services.gemini_service.http.post") as mock_post, \\\n                 patch.dict(app.config, {"VERTEX_AI_API_KEY": "fake-key", "VERTEX_AI_PROJECT": "p", "VERTEX_AI_LOCATION": "l"}):\n                mock_post.return_value = _gemini_response([bad_match])',
    content
)

with open(r"d:\thardeye_projects\Butterfly Identification system\backend\tests\test_phase3.py", "w") as f:
    f.write(content)
