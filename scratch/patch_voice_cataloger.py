import os

target_file = r'c:\Users\Sunny\AndroidStudioProjects\ShilpSetu_AI\mobile_app\lib\features\products\screens\voice_cataloger_screen.dart'

with open(target_file, 'r', encoding='utf-8') as f:
    code = f.read()

# Add import for AiService
if "import 'package:shilpsetu_ai/core/services/ai_service.dart';" not in code:
    code = code.replace(
        "import 'package:shilpsetu_ai/services/api_service.dart';",
        "import 'package:shilpsetu_ai/services/api_service.dart';\nimport 'package:shilpsetu_ai/core/services/ai_service.dart';"
    )

old_toggle = '''  Future<void> _toggleRecording(String lang) async {
    if (_isRecording) {
      // STOP recording
      setState(() => _isTranscribing = true);
      final path = await _recorderService.stopRecording();
      _recordedAudioPath = path;

      // Attempt AI audio transcription
      String transcribedText = '';
      if (path != null && path.isNotEmpty) {
        try {
          final res = await ApiService().transcribeAudio(
            audioFile: File(path),
            language: lang,
            craftType: _selectedCraft,
          );
          if (res != null && res['success'] == true && res['data']?['transcript'] != null) {
            transcribedText = res['data']['transcript'];
          }
        } catch (e) {
          debugPrint('Backend transcription note: $e');
        }
      }

      // If backend transcription not active, fallback to selected craft speech
      if (transcribedText.isEmpty) {
        final craft = _quickCrafts.firstWhere(
          (c) => c['id'] == _selectedCraft,
          orElse: () => _quickCrafts.first,
        );
        transcribedText = lang == 'mr'
            ? craft['sample_mr']
            : (lang == 'hi' ? craft['sample_hi'] : craft['sample_en']);
      }

      if (mounted) {
        setState(() {
          _isTranscribing = false;
          _transcriptController.text = transcribedText;
        });
      }
    } else {'''

new_toggle = '''  Future<void> _toggleRecording(String lang) async {
    if (_isRecording) {
      // STOP recording
      setState(() => _isTranscribing = true);
      final path = await _recorderService.stopRecording();
      _recordedAudioPath = path;

      try {
        final aiService = AiService();
        final res = await aiService.transcribeAndTranslateAudio(
          audioFile: File(path ?? ''),
          craftType: _selectedCraft,
          language: lang,
        );

        if (mounted) {
          setState(() {
            _isTranscribing = false;
            // AUTOMATICALLY TRANSLATE TO ENGLISH DESCRIPTION!
            _transcriptController.text = res['english_description'] ?? '';
            if (res['detected_craft'] != null && (res['detected_craft'] as String).isNotEmpty) {
              final detected = (res['detected_craft'] as String).toLowerCase();
              final matched = _quickCrafts.firstWhere(
                (c) => c['id'].toString().toLowerCase() == detected ||
                       c['id'].toString().toLowerCase().contains(detected) ||
                       detected.contains(c['id'].toString().toLowerCase()),
                orElse: () => <String, dynamic>{},
              );
              if (matched.isNotEmpty) {
                _selectedCraft = matched['id'];
              }
            }
          });
        }
      } catch (e) {
        debugPrint('Voice cataloger transcription note: $e');
        if (mounted) setState(() => _isTranscribing = false);
      }
    } else {'''

code = code.replace(old_toggle, new_toggle)

with open(target_file, 'w', encoding='utf-8') as f:
    f.write(code)

print("Finished patching voice_cataloger_screen.dart")
