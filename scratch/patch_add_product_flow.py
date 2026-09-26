import os

target_file = r'c:\Users\Sunny\AndroidStudioProjects\ShilpSetu_AI\mobile_app\lib\features\products\screens\add_product_screen.dart'

with open(target_file, 'r', encoding='utf-8') as f:
    code = f.read()

# 1. Add state variables
old_state = '''  // Step 1: Photo & Presets
  File? _pickedImage;
  String? _presetImageUrl;
  final ImagePicker _picker = ImagePicker();

  // Step 2: Craft & Real Voice Recording
  String _selectedCraft = 'Textiles';
  final TextEditingController _transcriptController = TextEditingController();
  final VoiceRecorderService _voiceRecorder = VoiceRecorderService();
  bool _isListening = false;
  bool _isPlayingAudio = false;
  int _recordingDuration = 0;
  String? _recordedAudioPath;

  // Step 3: AI Catalog & Pricing State
  bool _isAiGenerating = false;'''

new_state = '''  // Step 1: Photo & Presets
  File? _pickedImage;
  String? _presetImageUrl;
  final ImagePicker _picker = ImagePicker();
  bool _isAnalyzingImage = false;

  // Step 2: Craft & Real Voice Recording
  String _selectedCraft = 'Textiles';
  final TextEditingController _transcriptController = TextEditingController();
  final VoiceRecorderService _voiceRecorder = VoiceRecorderService();
  bool _isListening = false;
  bool _isTranscribingVoice = false;
  bool _isPlayingAudio = false;
  int _recordingDuration = 0;
  String? _recordedAudioPath;
  String? _voiceOriginalTranscript;

  // Step 3: AI Catalog & Pricing State
  bool _isAiGenerating = false;'''

code = code.replace(old_state, new_state)

# 2. Update _pickImage to automatically trigger AI image analysis
old_pick_image = '''  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(source: source, imageQuality: 85);
      if (picked != null) {
        setState(() {
          _pickedImage = File(picked.path);
          _presetImageUrl = null;
        });
      }
    } catch (e) {
      debugPrint('Image pick note: $e');
    }
  }'''

new_pick_image = '''  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(source: source, imageQuality: 85);
      if (picked != null) {
        setState(() {
          _pickedImage = File(picked.path);
          _presetImageUrl = null;
        });
        // Automatically analyze the uploaded craft photo immediately!
        await _autoAnalyzePickedImage();
      }
    } catch (e) {
      debugPrint('Image pick note: $e');
    }
  }

  Future<void> _autoAnalyzePickedImage() async {
    if (_pickedImage == null) return;
    setState(() => _isAnalyzingImage = true);

    try {
      final aiService = AiService();
      final profile = context.read<UserProfileProvider>().profile;
      final location = profile.state.isNotEmpty ? \'${profile.location}, ${profile.state}, India\' : \'Maharashtra, India\';

      if (aiService.isLiveAiAvailable) {
        final result = await aiService.analyzeImageAndGenerateCatalog(
          imageFile: _pickedImage!,
          artisanLocation: location,
        );
        if (mounted) {
          setState(() {
            if (result['category'] != null) {
              final cat = result['category'].toString();
              final matched = _craftCategories.firstWhere(
                (c) => c['id'].toString().toLowerCase() == cat.toLowerCase() ||
                       cat.toLowerCase().contains(c['id'].toString().toLowerCase()) ||
                       c['id'].toString().toLowerCase().contains(cat.toLowerCase()),
                orElse: () => <String, dynamic>{},
              );
              if (matched.isNotEmpty) {
                _selectedCraft = matched['id'];
              }
            }
            if (result['price_inr'] != null) {
              final raw = result['price_inr'];
              _recommendedPrice = (raw is int) ? raw.toDouble() : double.tryParse(raw.toString().replaceAll(RegExp(r\'[^0-9.]\'), \'\')) ?? _recommendedPrice;
            } else if (result['recommended_price'] is String) {
              final parsed = double.tryParse((result['recommended_price'] as String).replaceAll(RegExp(r\'[^0-9.]\'), \'\'));
              if (parsed != null && parsed > 0) _recommendedPrice = parsed;
            }
            if (result['title_en'] is String) _titleEn = result['title_en'];
            if (result['title_mr'] is String) _titleMr = result['title_mr'];
            if (result['title_hi'] is String) _titleHi = result['title_hi'];
            if (result['heritage_story'] is String) _heritageStory = result['heritage_story'];
            _aiDetectedCraft = result['detected_craft'] as String? ?? result['craft_type'] as String?;
          });
        }
      } else {
        // Fast smart classification based on file path/name
        final fileName = _pickedImage!.path.split(Platform.pathSeparator).last.toLowerCase();
        String detected = _selectedCraft;
        if (fileName.contains('potter') || fileName.contains('clay') || fileName.contains('dhoop') || fileName.contains('diya')) {
          detected = 'Pottery';
        } else if (fileName.contains('leather') || fileName.contains('chappal') || fileName.contains('shoe') || fileName.contains('sandal')) {
          detected = 'Leather';
        } else if (fileName.contains('wood') || fileName.contains('box') || fileName.contains('carv')) {
          detected = 'Woodcraft';
        } else if (fileName.contains('paint') || fileName.contains('warli') || fileName.contains('art')) {
          detected = 'Paintings';
        } else if (fileName.contains('dhokra') || fileName.contains('metal') || fileName.contains('brass') || fileName.contains('bull')) {
          detected = 'Jewellery';
        } else if (fileName.contains('saree') || fileName.contains('silk') || fileName.contains('cloth') || fileName.contains('textil')) {
          detected = 'Textiles';
        }

        final match = _craftCategories.firstWhere(
          (c) => c['id'] == detected,
          orElse: () => _craftCategories.first,
        );

        if (mounted) {
          setState(() {
            _selectedCraft = match['id'];
            _recommendedPrice = match['defaultPrice'];
            _titleEn = match['defaultEn'];
            _titleMr = match['defaultMr'];
            _titleHi = match['defaultHi'];
            _heritageStory = match['story'];
            _aiDetectedCraft = match['title'];
          });
        }
      }
    } catch (e) {
      debugPrint('Auto analyze error: $e');
    } finally {
      if (mounted) setState(() => _isAnalyzingImage = false);
    }
  }'''

code = code.replace(old_pick_image, new_pick_image)

# 3. Update _selectPresetImage to also set _aiDetectedCraft
old_preset = '''      _titleEn = preset['title'] ?? match['defaultEn'];
      _titleMr = preset['title_mr'] ?? match['defaultMr'];
      _titleHi = preset['title_hi'] ?? match['defaultHi'];
      _heritageStory = match['story'];
    });'''

new_preset = '''      _titleEn = preset['title'] ?? match['defaultEn'];
      _titleMr = preset['title_mr'] ?? match['defaultMr'];
      _titleHi = preset['title_hi'] ?? match['defaultHi'];
      _heritageStory = match['story'];
      _aiDetectedCraft = preset['title'] ?? match['title'];
    });'''

code = code.replace(old_preset, new_preset)

# 4. Update _toggleListening to automatically translate voice to English and display in description box
old_toggle_listening = '''  Future<void> _toggleListening(String lang) async {
    if (_isListening) {
      // STOP recording
      final path = await _voiceRecorder.stopRecording();
      _recordedAudioPath = path;

      // Call audio transcription API or craft fallback
      String transcribed = '';
      if (path != null && path.isNotEmpty) {
        try {
          final res = await ApiService().transcribeAudio(
            audioFile: File(path),
            language: lang,
            craftType: _selectedCraft,
          );
          if (res != null && res['success'] == true && res['data']?['transcript'] != null) {
            transcribed = res['data']['transcript'];
          }
        } catch (e) {
          debugPrint('Transcription API note: $e');
        }
      }

      if (transcribed.isEmpty) {
        final match = _craftCategories.firstWhere(
          (c) => c['id'] == _selectedCraft,
          orElse: () => _craftCategories.first,
        );
        if (lang == 'mr') {
          transcribed = _selectedCraft == 'Textiles'
              ? 'ही अस्सल हातमागावर विणलेली पैठणी रेशीम साडी आहे. यावर पारंपारिक मोराची नक्षी असून तयार करण्यास १५ दिवस लागले.'
              : 'ही पारंपरिक हाताने बनवलेली उत्कृष्ट ${match['marathi']} कलाकृती असून अस्सल नैसर्गिक साहित्यापासून तयार केली आहे.';
        } else if (lang == 'hi') {
          transcribed = _selectedCraft == 'Textiles'
              ? 'यह शुद्ध रेशम की हाथ से बुनी पैठणी साड़ी है। इसमें मोर की पारंपरिक डिजाइन है और इसे बनाने में १५ दिन लगे।'
              : 'यह हमारे पारंपरिक कारीगरों द्वारा हाथ से बनाया गया प्रामाणिक ${match['hindi']} उत्पाद है।';
        } else {
          transcribed = 'This is an authentic handcrafted $_selectedCraft product made with pure natural materials and traditional artisan techniques.';
        }
      }

      if (mounted) {
        setState(() {
          _transcriptController.text = transcribed;
        });
      }
    } else {
      // START real recording
      _transcriptController.clear();
      final started = await _voiceRecorder.startRecording();
      if (!started && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_t(
              lang,
              en: 'Please grant microphone permission to record voice.',
              mr: 'कृपया आवाज रेकॉर्ड करण्यासाठी मायक्रोफोन परवानगी द्या.',
              hi: 'कृपया आवाज रिकॉर्ड करने के लिए माइक्रोफ़ोन की अनुमति दें।',
            )),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }'''

new_toggle_listening = '''  Future<void> _toggleListening(String lang) async {
    if (_isListening) {
      // STOP recording
      setState(() => _isTranscribingVoice = true);
      final path = await _voiceRecorder.stopRecording();
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
            // AUTOMATICALLY TRANSLATE TO ENGLISH AND DISPLAY IN DESCRIPTION BOX!
            _transcriptController.text = res['english_description'] ?? '';
            _voiceOriginalTranscript = res['transcript_original'];
            if (res['detected_craft'] != null && (res['detected_craft'] as String).isNotEmpty) {
              _aiDetectedCraft = res['detected_craft'];
            }
          });
        }
      } catch (e) {
        debugPrint('Voice translate error: $e');
      } finally {
        if (mounted) setState(() => _isTranscribingVoice = false);
      }
    } else {
      // START real recording
      _transcriptController.clear();
      _voiceOriginalTranscript = null;
      final started = await _voiceRecorder.startRecording();
      if (!started && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_t(
              lang,
              en: 'Please grant microphone permission to record voice.',
              mr: 'कृपया आवाज रेकॉर्ड करण्यासाठी मायक्रोफोन परवानगी द्या.',
              hi: 'कृपया आवाज रिकॉर्ड करने के लिए माइक्रोफ़ोन की अनुमति दें।',
            )),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _translateCurrentTextToEnglish() async {
    final text = _transcriptController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isTranscribingVoice = true);
    try {
      final translated = await AiService().translateTextToEnglish(text, craftType: _selectedCraft);
      if (mounted && translated.isNotEmpty) {
        setState(() {
          _voiceOriginalTranscript = text;
          _transcriptController.text = translated;
        });
      }
    } finally {
      if (mounted) setState(() => _isTranscribingVoice = false);
    }
  }'''

code = code.replace(old_toggle_listening, new_toggle_listening)

with open(target_file, 'w', encoding='utf-8') as f:
    f.write(code)

print("Finished phase 1 patch of add_product_screen.dart")
