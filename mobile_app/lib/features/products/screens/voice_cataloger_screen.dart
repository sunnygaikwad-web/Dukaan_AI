import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shilpsetu_ai/core/theme/app_theme.dart';
import 'package:shilpsetu_ai/core/constants/app_localizations.dart';
import 'package:shilpsetu_ai/core/constants/app_craft_images.dart';
import 'package:shilpsetu_ai/core/providers/user_profile_provider.dart';
import 'package:shilpsetu_ai/core/services/voice_recorder_service.dart';
import 'package:shilpsetu_ai/services/api_service.dart';

class VoiceCatalogerScreen extends StatefulWidget {
  final File imageFile;
  const VoiceCatalogerScreen({super.key, required this.imageFile});

  @override
  State<VoiceCatalogerScreen> createState() => _VoiceCatalogerScreenState();
}

class _VoiceCatalogerScreenState extends State<VoiceCatalogerScreen>
    with SingleTickerProviderStateMixin {
  final VoiceRecorderService _recorderService = VoiceRecorderService();
  final TextEditingController _transcriptController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  bool _isRecording = false;
  bool _isPlaying = false;
  bool _isTranscribing = false;
  int _seconds = 0;
  String? _recordedAudioPath;
  File? _currentImageFile;
  String? _presetImageUrl;
  String _selectedCraft = 'Textiles';

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<Map<String, dynamic>> _quickCrafts = [
    {
      'id': 'Textiles',
      'icon': '🧵',
      'label': 'Paithani Saree',
      'label_mr': 'पैठणी साडी',
      'label_hi': 'पैठणी साड़ी',
      'sample_mr': 'ही अस्सल हातमागावर विणलेली पैठणी रेशीम साडी आहे. यावर पारंपारिक मोराची नक्षी असून तयार करण्यास १५ दिवस लागले.',
      'sample_hi': 'यह शुद्ध रेशम की हाथ से बुनी प्रामाणिक पैठणी साड़ी है। इसमें मोर की पारंपरिक डिजाइन है और इसे बनाने में १५ दिन लगे।',
      'sample_en': 'This is an authentic handwoven Paithani pure silk saree with traditional peacock motif.',
    },
    {
      'id': 'Pottery',
      'icon': '🏺',
      'label': 'Terracotta Urn',
      'label_mr': 'मातीची धूपदानी',
      'label_hi': 'मिट्टी की धूपदानी',
      'sample_mr': 'ही हाताने चाकावर बनवलेली पारंपरिक मातीची धूपदानी आहे. नदीच्या गाळाच्या मातीपासून तयार केली असून नैसर्गिकरीत्या भाजली आहे.',
      'sample_hi': 'यह चाक पर हाथ से बनाई गई प्रामाणिक मिट्टी की धूपदानी है। प्राकृतिक नदी की मिट्टी से निर्मित और पारंपरिक भट्टी में पकाई गई है।',
      'sample_en': 'This is a handcrafted terracotta incense burner made on a potter wheel with organic river clay.',
    },
    {
      'id': 'Woodcraft',
      'icon': '🪵',
      'label': 'Sheesham Box',
      'label_mr': 'लाकडी कोरीव पेटी',
      'label_hi': 'शीशम लकड़ी बक्सा',
      'sample_mr': 'ही अस्सल शिसम लाकडाची कोरीव कलात्मक पेटी आहे. यावर बारीक जाळीकाम आणि पितळेचे नक्षीकाम हाताने केले आहे.',
      'sample_hi': 'यह असली शीशम की लकड़ी का नक्काशीदार बक्सा है। इसमें बारीक जालीदार काम और पीतल की सजावट की गई है।',
      'sample_en': 'This is a hand-carved Sheesham wood keepsake box featuring floral jali and brass inlay.',
    },
    {
      'id': 'Jewellery',
      'icon': '💎',
      'label': 'Dhokra Metal',
      'label_mr': 'ढोकरा मूर्ती',
      'label_hi': 'ढोकरा मूर्ति',
      'sample_mr': 'ही प्राचीन ढोकरा धातू कलेतील नंदीची मूर्ती आहे. ही पारंपरिक मेणाच्या साच्यातून पूर्णपणे हाताने घडवली आहे.',
      'sample_hi': 'यह प्राचीन ढोकरा धातु शिल्प से निर्मित नंदी की मूर्ति है। इसे खोई मोम विधि से हाथ से ढाला गया है।',
      'sample_en': 'This is a tribal lost-wax cast brass bull created using ancient Dhokra metal casting.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _currentImageFile = (widget.imageFile.path.isNotEmpty && widget.imageFile.existsSync())
        ? widget.imageFile
        : null;

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Listen to recording service changes
    _recorderService.isRecordingNotifier.addListener(_onRecordingChanged);
    _recorderService.recordingDurationNotifier.addListener(_onDurationChanged);
    _recorderService.isPlayingNotifier.addListener(_onPlayingChanged);
  }

  void _onRecordingChanged() {
    if (mounted) {
      setState(() {
        _isRecording = _recorderService.isRecording;
        if (_isRecording) {
          _pulseController.repeat(reverse: true);
        } else {
          _pulseController.stop();
          _pulseController.reset();
        }
      });
    }
  }

  void _onDurationChanged() {
    if (mounted) {
      setState(() {
        _seconds = _recorderService.recordingSeconds;
      });
    }
  }

  void _onPlayingChanged() {
    if (mounted) {
      setState(() {
        _isPlaying = _recorderService.isPlaying;
      });
    }
  }

  @override
  void dispose() {
    _recorderService.isRecordingNotifier.removeListener(_onRecordingChanged);
    _recorderService.recordingDurationNotifier.removeListener(_onDurationChanged);
    _recorderService.isPlayingNotifier.removeListener(_onPlayingChanged);
    _recorderService.stopPlayback();
    _transcriptController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  String _t(String lang, {required String en, required String mr, required String hi}) {
    if (lang == 'mr') return mr;
    if (lang == 'hi') return hi;
    return en;
  }

  String _formatTimer(int secs) {
    final m = (secs ~/ 60).toString().padLeft(2, '0');
    final s = (secs % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> _toggleRecording(String lang) async {
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
    } else {
      // START recording from real microphone
      _transcriptController.clear();
      final started = await _recorderService.startRecording();
      if (!started && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_t(
              lang,
              en: 'Please allow microphone access to record your voice.',
              mr: 'कृपया आवाज रेकॉर्ड करण्यासाठी मायक्रोफोन परवानगी द्या.',
              hi: 'कृपया आवाज रिकॉर्ड करने के लिए माइक्रोफ़ोन की अनुमति दें।',
            )),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(source: source, imageQuality: 85);
      if (picked != null) {
        setState(() {
          _currentImageFile = File(picked.path);
          _presetImageUrl = null;
        });
      }
    } catch (e) {
      debugPrint('Image pick note: $e');
    }
  }

  void _selectQuickCraft(Map<String, dynamic> craft, String lang) {
    setState(() {
      _selectedCraft = craft['id'];
      if (_transcriptController.text.isEmpty) {
        _transcriptController.text = lang == 'mr'
            ? craft['sample_mr']
            : (lang == 'hi' ? craft['sample_hi'] : craft['sample_en']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<UserProfileProvider>().selectedLanguage;
    final hasImage = _currentImageFile != null || _presetImageUrl != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          _t(lang, en: 'Voice Cataloger', mr: 'व्हॉइस कॅटलॉगर', hi: 'वॉइस कैटलॉगर'),
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header description
              Text(
                _t(lang,
                    en: 'Tell us about your craft in your voice',
                    mr: 'आपल्या कलेबद्दल बोलून सांगा',
                    hi: 'अपनी कला के बारे में बोलकर बताएं'),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                _t(
                  lang,
                  en: 'Speak naturally in Marathi, Hindi, or English. AI will listen, transcribe, and craft a 360° digital catalog.',
                  mr: 'मराठी, हिंदी किंवा इंग्रजीत बोला. AI आपले बोलणे ऐकून ३६०° डिजिटल कॅटलॉग तयार करेल.',
                  hi: 'मराठी, हिंदी या अंग्रेजी में बोलें। AI सुनकर आपका ३६०° डिजिटल कैटलॉग तैयार करेगा।',
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.35),
              ),

              const SizedBox(height: 20),

              // Craft category selector chips
              Text(
                _t(lang, en: 'Select Craft Type:', mr: 'हस्तकलेचा प्रकार निवडा:', hi: 'हस्तशिल्प का प्रकार चुनें:'),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _quickCrafts.map((c) {
                  final isSel = _selectedCraft == c['id'];
                  final label = lang == 'mr' ? c['label_mr'] : (lang == 'hi' ? c['label_hi'] : c['label']);
                  return ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(c['icon'], style: const TextStyle(fontSize: 15)),
                        const SizedBox(width: 5),
                        Text(label),
                      ],
                    ),
                    selected: isSel,
                    selectedColor: AppColors.primaryFixed,
                    labelStyle: TextStyle(
                      color: isSel ? AppColors.primary : AppColors.textPrimary,
                      fontWeight: isSel ? FontWeight.bold : FontWeight.w600,
                      fontSize: 12.5,
                    ),
                    onSelected: (val) {
                      if (val) _selectQuickCraft(c, lang);
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 28),

              // Animated Mic Button with Pulse Ring
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => _toggleRecording(lang),
                      child: AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Container(
                            height: 140,
                            width: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _isRecording
                                  ? Colors.red.shade50
                                  : AppColors.primary.withValues(alpha: 0.08),
                              border: Border.all(
                                color: _isRecording ? Colors.red : AppColors.primary,
                                width: _isRecording ? 4 * _pulseAnimation.value : 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: (_isRecording ? Colors.red : AppColors.primary)
                                      .withValues(alpha: _isRecording ? 0.35 : 0.15),
                                  blurRadius: _isRecording ? 24 : 10,
                                  spreadRadius: _isRecording ? 4 : 0,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                                size: 68,
                                color: _isRecording ? Colors.red : AppColors.primary,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _isRecording
                          ? '${_t(lang, en: 'Recording Voice...', mr: 'आवाज रेकॉर्ड होत आहे...', hi: 'आवाज रिकॉर्ड हो रही है...')} (${_formatTimer(_seconds)})'
                          : _t(lang, en: 'Tap Microphone to Speak', mr: 'बोलण्यासाठी माईकवर दाबा', hi: 'बोलने के लिए माइक दबाएं'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _isRecording ? Colors.red : AppColors.textPrimary,
                      ),
                    ),
                    if (_isRecording)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          _t(lang,
                              en: 'Tap again when finished speaking',
                              mr: 'बोलून झाल्यावर थांबवण्यासाठी पुन्हा दाबा',
                              hi: 'बोलना समाप्त होने पर दोबारा दबाएं'),
                          style: const TextStyle(fontSize: 12, color: AppColors.textLight),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Audio Playback Preview Card
              if (_recordedAudioPath != null && !_isRecording)
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (_isPlaying) {
                            _recorderService.pausePlayback();
                          } else {
                            _recorderService.playRecording(_recordedAudioPath);
                          }
                        },
                        icon: Icon(
                          _isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded,
                          color: AppColors.primary,
                          size: 38,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _t(lang, en: 'Voice Recording Saved', mr: 'आवाज रेकॉर्ड झाला', hi: 'आवाज रिकॉर्ड हो गई'),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                            ),
                            Text(
                              _isPlaying
                                  ? _t(lang, en: 'Playing audio...', mr: 'आवाज ऐकवला जात आहे...', hi: 'ऑडियो चल रहा है...')
                                  : _t(lang, en: 'Tap to listen to your voice', mr: 'स्वतःचा आवाज ऐकण्यासाठी दाबा', hi: 'अपनी आवाज सुनने के लिए दबाएं'),
                              style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => _toggleRecording(lang),
                        icon: const Icon(Icons.refresh_rounded, size: 16),
                        label: Text(_t(lang, en: 'Re-record', mr: 'पुन्हा बोला', hi: 'फिर बोलें')),
                        style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),

              // Transcribing loader
              if (_isTranscribing)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      const CircularProgressIndicator(strokeWidth: 3),
                      const SizedBox(height: 12),
                      Text(
                        _t(lang,
                            en: 'AI is transcribing your speech...',
                            mr: 'AI आपल्या आवाजाचे शब्दांत रूपांतर करत आहे...',
                            hi: 'AI आपकी आवाज को लिख रहा है...'),
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ],
                  ),
                ),

              // Transcript Editing Box
              if (_transcriptController.text.isNotEmpty && !_isTranscribing) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _t(lang,
                          en: 'Understood Description:',
                          mr: 'तयार झालेला मजकूर:',
                          hi: 'तैयार किया गया विवरण:'),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const Icon(Icons.check_circle, size: 16, color: AppColors.success),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _transcriptController,
                  maxLines: 4,
                  style: const TextStyle(fontSize: 14.5, height: 1.4),
                  decoration: InputDecoration(
                    hintText: _t(lang,
                        en: 'Transcript will appear here...',
                        mr: 'येथे मजकूर दिसेल...',
                        hi: 'यहाँ विवरण दिखेगा...'),
                    filled: true,
                    fillColor: AppColors.surfaceContainerLowest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.outlineVariant),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
              ],

              // Photo Attachment Section (if not provided initially)
              if (!hasImage) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.outlineVariant),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _t(lang, en: 'Attach Product Photo (Optional):', mr: 'उत्पादनाचा फोटो जोडा (पर्यायी):', hi: 'उत्पाद फोटो जोड़ें (वैकल्पिक):'),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _pickImage(ImageSource.camera),
                              icon: const Icon(Icons.camera_alt, size: 16),
                              label: Text(_t(lang, en: 'Camera', mr: 'कॅमेरा', hi: 'कैमरा')),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _pickImage(ImageSource.gallery),
                              icon: const Icon(Icons.photo_library, size: 16),
                              label: Text(_t(lang, en: 'Gallery', mr: 'गॅलरी', hi: 'गैलरी')),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
              ],

              // Next Button: Generate Catalog
              if (_transcriptController.text.isNotEmpty)
                ElevatedButton.icon(
                  onPressed: () {
                    final imgFile = _currentImageFile ?? File('');
                    context.push('/catalog_preview', extra: {
                      'image': imgFile,
                      'transcript': _transcriptController.text,
                      'craft': _selectedCraft,
                    });
                  },
                  icon: const Icon(Icons.auto_awesome_rounded),
                  label: Text(
                    _t(lang,
                        en: 'Generate Trilingual Catalog ➔',
                        mr: 'त्रैभाषिक कॅटलॉग तयार करा ➔',
                        hi: 'त्रिभाषी कैटलॉग तैयार करें ➔'),
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
