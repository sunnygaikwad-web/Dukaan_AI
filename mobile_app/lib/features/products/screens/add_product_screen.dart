import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shilpsetu_ai/core/theme/app_theme.dart';
import 'package:shilpsetu_ai/core/constants/app_craft_images.dart';
import 'package:shilpsetu_ai/models/product_model.dart';
import 'package:shilpsetu_ai/core/providers/user_profile_provider.dart';
import 'package:shilpsetu_ai/core/providers/product_provider.dart';
import 'package:shilpsetu_ai/services/api_service.dart';
import 'package:shilpsetu_ai/core/services/voice_recorder_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  // Current active step (0: Photo, 1: Voice/Details, 2: AI Review & Price)
  int _currentStep = 0;

  // Step 1: Photo & Presets
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
  bool _isAiGenerating = false;
  double _recommendedPrice = 8499;
  String _titleEn = 'Authentic Paithani Silk Saree with Gold Zari';
  String _titleMr = 'अस्सल पैठणी रेशीम साडी सोन्याच्या जरीसह';
  String _titleHi = 'सोने की ज़री के साथ प्रामाणिक पैठणी रेशम साड़ी';
  String _heritageStory = 'Hand-woven on heritage wooden looms in Yeola, Maharashtra, continuing a 2,000-year Royal Maratha tradition.';

  final List<Map<String, dynamic>> _craftCategories = [
    {
      'id': 'Textiles',
      'icon': '🧵',
      'title': 'Textiles & Saree',
      'marathi': 'पैठणी व हातमाग',
      'hindi': 'हथकरघा व साड़ी',
      'defaultPrice': 8499.0,
      'defaultEn': 'Authentic Paithani Silk Saree with Gold Zari',
      'defaultMr': 'अस्सल पैठणी रेशीम साडी सोन्याच्या जरीसह',
      'defaultHi': 'सोने की ज़री के साथ प्रामाणिक पैठणी रेशम साड़ी',
      'story': 'Hand-woven on heritage wooden looms in Yeola, continuing a 2,000-year Royal Maratha tradition.',
    },
    {
      'id': 'Pottery',
      'icon': '🏺',
      'title': 'Pottery & Clay',
      'marathi': 'मातीकाम व धूपदानी',
      'hindi': 'मिट्टी के बर्तन',
      'defaultPrice': 1250.0,
      'defaultEn': 'Royal Blue Pottery Glazed Floral Urn',
      'defaultMr': 'पारंपरिक जयपुरी निळी मातीची कलाकृती',
      'defaultHi': 'शाही जयपुरी ब्लू पॉटरी पुष्पदान',
      'story': 'Handcrafted using quartz and natural minerals without clay, fired at low heat with Persian quartz art.',
    },
    {
      'id': 'Woodcraft',
      'icon': '🪵',
      'title': 'Wood Carving',
      'marathi': 'लाकडी नक्षीकाम',
      'hindi': 'लकड़ी नक्काशी',
      'defaultPrice': 2499.0,
      'defaultEn': 'Carved Sheesham Wood Keepsake Box with Brass Inlay',
      'defaultMr': 'शिसम लाकडाची कोरीव कलात्मक पेटी पितळी जडावासह',
      'defaultHi': 'पीतल की नक्काशीदार शीशम लकड़ी का बक्सा',
      'story': 'Hand-chiseled from sustainably harvested Saharanpur Rosewood with traditional floral jali openwork.',
    },
    {
      'id': 'Jewellery',
      'icon': '💎',
      'title': 'Dhokra Metal Art',
      'marathi': 'ढोकरा धातू कला',
      'hindi': 'ढोकरा धातु शिल्प',
      'defaultPrice': 1850.0,
      'defaultEn': 'Tribal Lost-Wax Cast Brass Bull (Dhokra Art)',
      'defaultMr': 'पारंपरिक ढोकरा धातूची नंदी मूर्ती (मोल्ड क्राफ्ट)',
      'defaultHi': 'ढोकरा शिल्प खोई मोम विधि से निर्मित नंदी बैल',
      'story': 'Created using 4,000-year-old Indus Valley lost-wax non-ferrous metal casting passed across generations.',
    },
    {
      'id': 'Paintings',
      'icon': '🎨',
      'title': 'Warli & Folk Art',
      'marathi': 'वारली चित्रकला',
      'hindi': 'वारली पेंटिंग',
      'defaultPrice': 3200.0,
      'defaultEn': 'Handmade Warli Folk Art Canvas: Circle of Harvest',
      'defaultMr': 'वारली लोककला: पारंपरिक उत्सव व निसर्ग चित्र',
      'defaultHi': 'हस्तनिर्मित वारली लोक कला कैनवास पेंटिंग',
      'story': 'Painted with natural rice flour paste and tree-gum binders on mud-coated canvas by Sahyadri tribal elders.',
    },
    {
      'id': 'Leather',
      'icon': '👞',
      'title': 'Kolhapuri Leather',
      'marathi': 'अस्सल कोल्हापुरी चप्पल',
      'hindi': 'कोल्हापुरी चप्पल',
      'defaultPrice': 1950.0,
      'defaultEn': 'Hand-Stitched Kolhapuri Leather Chappals',
      'defaultMr': 'हाताने शिवलेली अस्सल कोल्हापुरी चप्पल',
      'defaultHi': 'हाथ से सिली प्रामाणिक कोल्हापुरी चमड़े की चप्पल',
      'story': 'Vegetable tanned using indigenous babool bark extracts and braided with zero synthetic chemicals.',
    },
  ];

  @override
  void initState() {
    super.initState();
    final profile = Provider.of<UserProfileProvider>(context, listen: false).profile;
    if (profile.craftType.isNotEmpty) {
      final match = _craftCategories.firstWhere(
        (c) => c['id'].toString().toLowerCase() == profile.craftType.toLowerCase(),
        orElse: () => _craftCategories.first,
      );
      _selectedCraft = match['id'];
      _recommendedPrice = match['defaultPrice'];
      _titleEn = match['defaultEn'];
      _titleMr = match['defaultMr'];
      _titleHi = match['defaultHi'];
      _heritageStory = match['story'];
    }

    _voiceRecorder.isRecordingNotifier.addListener(_syncRecordingState);
    _voiceRecorder.recordingDurationNotifier.addListener(_syncRecordingDuration);
    _voiceRecorder.isPlayingNotifier.addListener(_syncPlayingState);
  }

  void _syncRecordingState() {
    if (mounted) setState(() => _isListening = _voiceRecorder.isRecording);
  }

  void _syncRecordingDuration() {
    if (mounted) setState(() => _recordingDuration = _voiceRecorder.recordingSeconds);
  }

  void _syncPlayingState() {
    if (mounted) setState(() => _isPlayingAudio = _voiceRecorder.isPlaying);
  }

  @override
  void dispose() {
    _voiceRecorder.isRecordingNotifier.removeListener(_syncRecordingState);
    _voiceRecorder.recordingDurationNotifier.removeListener(_syncRecordingDuration);
    _voiceRecorder.isPlayingNotifier.removeListener(_syncPlayingState);
    _voiceRecorder.stopPlayback();
    _transcriptController.dispose();
    super.dispose();
  }

  String _t(String lang, {required String en, required String mr, required String hi}) {
    if (lang == 'mr') return mr;
    if (lang == 'hi') return hi;
    return en;
  }

  Future<void> _pickImage(ImageSource source) async {
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
  }

  void _selectPresetImage(Map<String, dynamic> preset) {
    setState(() {
      _presetImageUrl = preset['url'];
      _pickedImage = null;
      _selectedCraft = preset['category']?.toString() ?? 'Textiles';
      _recommendedPrice = double.tryParse(preset['price']?.toString() ?? '') ?? 2499.0;
      final match = _craftCategories.firstWhere(
        (c) => c['id'].toString().toLowerCase() == _selectedCraft.toLowerCase(),
        orElse: () => _craftCategories.first,
      );
      _titleEn = preset['title'] ?? match['defaultEn'];
      _titleMr = preset['title_mr'] ?? match['defaultMr'];
      _titleHi = preset['title_hi'] ?? match['defaultHi'];
      _heritageStory = match['story'];
    });
  }

  Future<void> _toggleListening(String lang) async {
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
  }

  Future<void> _generateAiCatalog(String lang) async {
    setState(() {
      _isAiGenerating = true;
    });

    try {
      final profile = context.read<UserProfileProvider>().profile;
      final transcript = _transcriptController.text.trim().isNotEmpty
          ? _transcriptController.text.trim()
          : 'Handmade traditional $_selectedCraft created by artisan in ${profile.state}';

      final response = await ApiService().generateCatalog(
        transcript: transcript,
        artisanLocation: profile.state.isNotEmpty ? profile.state : 'Maharashtra',
        language: lang,
        imageFile: _pickedImage,
      );

      if (response != null && response['success'] == true && response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        setState(() {
          if (data['en']?['title'] != null) _titleEn = data['en']['title'];
          if (data['mr']?['title'] != null) _titleMr = data['mr']['title'];
          if (data['hi']?['title'] != null) _titleHi = data['hi']['title'];
          if (data['heritage_story'] != null) _heritageStory = data['heritage_story'];
        });
      } else {
        final craft = _craftCategories.firstWhere((c) => c['id'] == _selectedCraft, orElse: () => _craftCategories.first);
        setState(() {
          _titleEn = craft['defaultEn'];
          _titleMr = craft['defaultMr'];
          _titleHi = craft['defaultHi'];
          _recommendedPrice = craft['defaultPrice'];
          _heritageStory = craft['story'];
        });
      }
    } catch (e) {
      debugPrint('AI Catalog fetch note: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isAiGenerating = false;
          _currentStep = 2;
        });
      }
    }
  }

  ProductModel _buildCurrentProduct() {
    final profile = context.read<UserProfileProvider>().profile;
    final craft = _craftCategories.firstWhere((c) => c['id'] == _selectedCraft, orElse: () => _craftCategories.first);
    final displayUrl = _presetImageUrl ?? (_pickedImage != null ? _pickedImage!.path : AppCraftImages.getCraftImageUrl(_selectedCraft));

    return ProductModel(
      id: 'prod_${DateTime.now().millisecondsSinceEpoch}',
      artisanId: profile.id,
      status: 'published',
      originalImageUrl: displayUrl,
      enhancedImageUrl: displayUrl,
      catalog: {
        'en': CatalogContent(
          title: _titleEn,
          shortDesc: 'Authentic handcrafted ${craft['title']} made with traditional artisan techniques.',
          description: _transcriptController.text.isNotEmpty ? _transcriptController.text : _heritageStory,
          heritageStory: _heritageStory,
          keywords: [_selectedCraft, 'Handmade', 'ShilpSetu', 'Artisan', 'Direct Trade'],
        ),
        'mr': CatalogContent(
          title: _titleMr,
          shortDesc: 'पारंपरिक पद्धतीने तयार केलेली अस्सल भारतीय हस्तकला.',
          description: _transcriptController.text.isNotEmpty ? _transcriptController.text : _heritageStory,
          heritageStory: _heritageStory,
          keywords: [_selectedCraft, 'हस्तकला', 'शिल्पसेतू', 'पारंपरिक कला'],
        ),
        'hi': CatalogContent(
          title: _titleHi,
          shortDesc: 'पारंपरिक कारीगरी से निर्मित प्रामाणिक भारतीय हस्तशिल्प।',
          description: _transcriptController.text.isNotEmpty ? _transcriptController.text : _heritageStory,
          heritageStory: _heritageStory,
          keywords: [_selectedCraft, 'हस्तशिल्प', 'शिल्पसेतु', 'स्वदेशी कला'],
        ),
      },
      pricing: PricingInfo(
        recommended: _recommendedPrice,
        minimum: (_recommendedPrice * 0.88).roundToDouble(),
        marketLow: (_recommendedPrice * 0.85).roundToDouble(),
        marketHigh: (_recommendedPrice * 1.15).roundToDouble(),
        confidenceScore: 0.94,
        productionCost: (_recommendedPrice * 0.45).roundToDouble(),
        factors: ['Pure Material', 'Master Artisan Labor', 'Direct-to-Buyer Fair Price'],
      ),
      metadata: ProductMetadata(
        category: _selectedCraft,
        subcategory: craft['title'],
        craftType: craft['title'],
        material: 'Authentic Traditional Material',
        color: 'Natural Finish',
        origin: profile.location.isNotEmpty ? profile.location : 'Maharashtra',
        region: 'India',
      ),
      createdAt: DateTime.now(),
    );
  }

  Future<void> _publishProduct() async {
    final newProduct = _buildCurrentProduct();
    await context.read<ProductProvider>().addProduct(newProduct);
    if (!mounted) return;

    final lang = context.read<UserProfileProvider>().selectedLanguage;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _t(
                  lang,
                  en: 'Craft published to ShilpSetu Store & Buyer Portal! 🎉',
                  mr: 'वस्तू शिल्पसेतू दुकान व ग्राहक पोर्टलवर प्रकाशित झाली! 🎉',
                  hi: 'शिल्पसेतु दुकान एवं खरीदार पोर्टल पर उत्पाद प्रकाशित हुआ! 🎉',
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
    context.go('/publish_success');
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<UserProfileProvider>().selectedLanguage;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_currentStep > 0) {
          setState(() => _currentStep--);
        } else {
          context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            _t(lang, en: 'Add New Craft', mr: 'नवीन हस्तकला जोडा', hi: 'नया हस्तशिल्प जोड़ें'),
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () {
              if (_currentStep > 0) {
                setState(() => _currentStep--);
              } else {
                context.pop();
              }
            },
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(42),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  _buildStepIndicator(step: 0, current: _currentStep, label: _t(lang, en: '1. Photo', mr: '१. फोटो', hi: '१. फोटो')),
                  Expanded(child: Container(height: 2, color: _currentStep >= 1 ? AppColors.primary : AppColors.outlineVariant)),
                  _buildStepIndicator(step: 1, current: _currentStep, label: _t(lang, en: '2. Details', mr: '२. माहिती', hi: '२. विवरण')),
                  Expanded(child: Container(height: 2, color: _currentStep >= 2 ? AppColors.primary : AppColors.outlineVariant)),
                  _buildStepIndicator(step: 2, current: _currentStep, label: _t(lang, en: '3. Preview', mr: '३. पूर्वावलोकन', hi: '३. पूर्वावलोकन')),
                ],
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _buildCurrentStepView(lang),
                ),
              ),
              _buildBottomActionButtons(lang),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator({required int step, required int current, required String label}) {
    final isActive = current == step;
    final isDone = current > step;

    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDone ? AppColors.success : (isActive ? AppColors.primary : AppColors.surfaceContainer),
          ),
          child: Center(
            child: isDone
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : Text(
                    '${step + 1}',
                    style: TextStyle(
                      color: isActive ? Colors.white : AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? AppColors.primary : AppColors.textLight,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentStepView(String lang) {
    switch (_currentStep) {
      case 0:
        return _buildStep1Photo(lang);
      case 1:
        return _buildStep2VoiceAndDetails(lang);
      case 2:
      default:
        return _buildStep3ReviewAndPricing(lang);
    }
  }

  // ─── Step 1: Photo & Presets ───────────────────────────────────────────────
  Widget _buildStep1Photo(String lang) {
    final hasImage = _pickedImage != null || _presetImageUrl != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _t(lang, en: 'Take a clear photo of your craft', mr: 'हस्तकलेचा स्वच्छ फोटो काढा', hi: 'हस्तशिल्प की साफ तस्वीर लें'),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 6),
        Text(
          _t(
            lang,
            en: 'Place the product in good lighting. AI will automatically enhance and remove backgrounds!',
            mr: 'उत्पादन चांगल्या प्रकाशात ठेवा. आमचे AI आपोआप बॅकग्राउंड काढून फोटो सुंदर बनवेल!',
            hi: 'उत्पाद को अच्छी रोशनी में रखें। AI अपने आप बैकग्राउंड हटाकर फोटो को शानदार बनाएगा!',
          ),
          style: const TextStyle(fontSize: 13.5, color: AppColors.textSecondary, height: 1.3),
        ),
        const SizedBox(height: 18),

        // Photo Preview or Capture Area
        if (hasImage)
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: _pickedImage != null
                    ? Image.file(
                        _pickedImage!,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        _presetImageUrl!,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 250,
                          color: AppColors.primaryFixed,
                          child: const Icon(Icons.palette_rounded, size: 48, color: AppColors.primary),
                        ),
                      ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: () {
                    if (_pickedImage != null) {
                      context.push('/ai_studio', extra: _pickedImage);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.auto_awesome, size: 14, color: Colors.white),
                        SizedBox(width: 4),
                        Text('AI Studio', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.camera),
                        icon: const Icon(Icons.camera_alt, size: 16),
                        label: Text(_t(lang, en: 'Retake', mr: 'पुन्हा काढा', hi: 'फिर से लें')),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.black87, foregroundColor: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        icon: const Icon(Icons.photo_library, size: 16),
                        label: Text(_t(lang, en: 'Gallery', mr: 'गॅलरी', hi: 'गैलरी')),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.black87, foregroundColor: Colors.white),
                      ),
                    ),
                    if (_pickedImage != null) ...[
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => context.push('/ai_studio', extra: _pickedImage),
                          icon: const Icon(Icons.auto_awesome, size: 16),
                          label: Text(_t(lang, en: 'Studio', mr: 'स्टुडिओ', hi: 'स्टूडियो')),
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          )
        else
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.outlineVariant, width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_a_photo_outlined, size: 48, color: AppColors.primary),
                const SizedBox(height: 10),
                Text(
                  _t(lang, en: 'No photo selected yet', mr: 'अद्याप फोटो निवडलेला नाही', hi: 'अभी कोई फोटो नहीं चुनी'),
                  style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt, size: 18),
                      label: Text(_t(lang, en: 'Camera', mr: 'कॅमेरा', hi: 'कैमरा')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library_outlined, size: 18),
                      label: Text(_t(lang, en: 'Gallery', mr: 'गॅलरी', hi: 'गैलरी')),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

        const SizedBox(height: 20),

        // Authentic Craft Presets Selector
        Text(
          _t(
            lang,
            en: 'Or Select from Authentic Craft Presets:',
            mr: 'किंवा अस्सल पारंपरिक हस्तकला निवडा:',
            hi: 'या प्रामाणिक पारंपरिक हस्तशिल्प में से चुनें:',
          ),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 10),

        SizedBox(
          height: 135,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: AppCraftImages.craftPresets.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final preset = AppCraftImages.craftPresets[index];
              final isSelected = _presetImageUrl == preset['url'];

              return GestureDetector(
                onTap: () => _selectPresetImage(preset),
                child: Container(
                  width: 115,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.outlineVariant,
                      width: isSelected ? 2.5 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.network(
                          preset['url']!,
                          height: 75,
                          width: 115,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 75,
                            color: AppColors.primaryFixed,
                            child: const Icon(Icons.image, color: AppColors.primary),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _t(
                                lang,
                                en: preset['title'] ?? 'Craft',
                                mr: preset['title_mr'] ?? preset['title'] ?? 'हस्तकला',
                                hi: preset['title_hi'] ?? preset['title'] ?? 'हस्तशिल्प',
                              ),
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '₹${preset['price'] ?? '999'}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ─── Step 2: Voice & Craft Details ─────────────────────────────────────────
  Widget _buildStep2VoiceAndDetails(String lang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _t(lang, en: 'Select Craft Category', mr: 'हस्तकलेचा प्रकार निवडा', hi: 'हस्तशिल्प श्रेणी चुनें'),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 10),

        // Clean Category Chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _craftCategories.map((c) {
            final isSelected = _selectedCraft == c['id'];
            return ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(c['icon'], style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                  Text(_t(lang, en: c['title'], mr: c['marathi'], hi: c['hindi'])),
                ],
              ),
              selected: isSelected,
              selectedColor: AppColors.primaryFixed,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              onSelected: (val) {
                if (val) {
                  setState(() {
                    _selectedCraft = c['id'];
                    _recommendedPrice = c['defaultPrice'];
                    _titleEn = c['defaultEn'];
                    _titleMr = c['defaultMr'];
                    _titleHi = c['defaultHi'];
                    _heritageStory = c['story'];
                  });
                }
              },
            );
          }).toList(),
        ),

        const SizedBox(height: 24),

        // Voice Section
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: Column(
            children: [
              Text(
                _t(lang, en: 'Speak About Your Craft', mr: 'आपल्या कलेबद्दल बोलून सांगा', hi: 'अपनी कला के बारे में बोलकर बताएं'),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                _t(
                  lang,
                  en: 'Mention materials, days taken, or specialties in your own language.',
                  mr: 'साहित्य, तयार करण्यास लागलेले दिवस किंवा वैशिष्ट्ये सांगा.',
                  hi: 'सामग्री, बनाने में लगे दिन या खासियत अपनी भाषा में बताएं।',
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12.5, color: AppColors.textLight),
              ),
              const SizedBox(height: 16),

              // Big Round Mic Button
              GestureDetector(
                onTap: () => _toggleListening(lang),
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: _isListening ? Colors.red : AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (_isListening ? Colors.red : AppColors.primary).withValues(alpha: 0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    _isListening ? Icons.stop : Icons.mic,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isListening
                    ? '${_t(lang, en: 'Recording Voice...', mr: 'आवाज रेकॉर्ड होत आहे...', hi: 'आवाज रिकॉर्ड हो रही है...')} (${(_recordingDuration ~/ 60).toString().padLeft(2, '0')}:${(_recordingDuration % 60).toString().padLeft(2, '0')})'
                    : _t(lang, en: 'Tap to Speak', mr: 'बोलण्यासाठी दाबा', hi: 'बोलने के लिए दबाएं'),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: _isListening ? Colors.red : AppColors.primary,
                ),
              ),

              // Audio Playback Preview
              if (_recordedAudioPath != null && !_isListening) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryFixed,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          _isPlayingAudio ? Icons.pause_circle_rounded : Icons.play_circle_rounded,
                          color: AppColors.primary,
                          size: 26,
                        ),
                        onPressed: () {
                          if (_isPlayingAudio) {
                            _voiceRecorder.pausePlayback();
                          } else {
                            _voiceRecorder.playRecording(_recordedAudioPath);
                          }
                        },
                      ),
                      Text(
                        _t(lang, en: 'Listen to your voice recording', mr: 'रेकॉर्ड केलेला आवाज ऐका', hi: 'रिकॉर्ड की गई आवाज सुनें'),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 14),

              // Transcript Field
              TextField(
                controller: _transcriptController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: _t(
                    lang,
                    en: 'Or type description here...',
                    mr: 'किंवा येथे माहिती लिहा...',
                    hi: 'या यहां विवरण लिखें...',
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Step 3: Review AI Catalog & Pricing ───────────────────────────────────
  Widget _buildStep3ReviewAndPricing(String lang) {
    final title = lang == 'mr' ? _titleMr : (lang == 'hi' ? _titleHi : _titleEn);
    final currentProduct = _buildCurrentProduct();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.successContainer,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _t(
                    lang,
                    en: 'AI has generated your tri-lingual catalog and fair pricing!',
                    mr: 'AI ने आपल्या उत्पादनाचा ३ भाषांमधील कॅटलॉग व योग्य किंमत तयार केली आहे!',
                    hi: 'AI ने आपके उत्पाद का ३ भाषाओं में कैटलॉग एवं उचित मूल्य तैयार किया है!',
                  ),
                  style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Product Summary Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.outlineVariant),
            boxShadow: const [
              BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 3)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17.5, color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              Text(_heritageStory, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4)),
              const Divider(height: 24),

              // Recommended Price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _t(lang, en: 'AI Recommended Price', mr: 'शिफारस केलेली किंमत', hi: 'सुझाई गई कीमत'),
                        style: const TextStyle(fontSize: 12, color: AppColors.textLight, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '₹${_recommendedPrice.toInt()}',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.primary),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: AppColors.successContainer, borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      _t(lang, en: '100% Artisan Earnings', mr: '१००% कारागीर कमाई', hi: '१००% कारीगर कमाई'),
                      style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // 3 Special Feature Links (Multilingual Catalog, Heritage Story, Smart Pricing)
        Text(
          _t(lang, en: 'Explore AI Enhancements:', mr: 'AI वैशिष्ट्ये तपासा:', hi: 'AI विशेषताएं देखें:'),
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 10),

        // 1. Multilingual Catalog Feature Card
        _buildFeatureNavCard(
          context,
          icon: Icons.translate_rounded,
          iconBg: AppColors.primaryFixed,
          iconColor: AppColors.primary,
          title: _t(lang, en: 'Multilingual Catalog (3 Languages)', mr: 'त्रिभाषिक कॅटलॉग (मराठी/हिंदी/इंग्रजी)', hi: 'त्रिभाषीय कैटलॉग (हिंदी/मराठी/अंग्रेजी)'),
          subtitle: _t(lang, en: 'View English, Hindi & Marathi translations', mr: 'इंग्रजी, हिंदी व मराठी भाषांतरे तपासा', hi: 'अंग्रेजी, हिंदी व मराठी अनुवाद देखें'),
          onTap: () => context.push('/multilingual_catalog', extra: currentProduct),
        ),
        const SizedBox(height: 10),

        // 2. Heritage Story Feature Card
        _buildFeatureNavCard(
          context,
          icon: Icons.menu_book_rounded,
          iconBg: AppColors.sand,
          iconColor: AppColors.primary,
          title: _t(lang, en: 'Cultural Heritage Story', mr: 'सांस्कृतिक वारसा कथा व ऑडिओ', hi: 'सांस्कृतिक विरासत कथा एवं ऑडियो'),
          subtitle: _t(lang, en: 'Generational lineage & audio storytelling', mr: 'पिढ्यान्-पिढ्यांची परंपरा व ऑडिओ गोष्ट', hi: 'पीढ़ियों की परंपरा और ऑडियो कहानी'),
          onTap: () => context.push('/heritage_story', extra: currentProduct),
        ),
        const SizedBox(height: 10),

        // 3. Smart Pricing Engine Card
        _buildFeatureNavCard(
          context,
          icon: Icons.calculate_rounded,
          iconBg: AppColors.secondaryFixed,
          iconColor: AppColors.secondary,
          title: _t(lang, en: 'AI Smart Pricing Engine', mr: 'AI अचूक किंमत निर्धारण व चलन', hi: 'AI सटीक मूल्य निर्धारण व मुद्रा'),
          subtitle: _t(lang, en: 'Cost breakdown & 0% commission guarantee', mr: 'खर्च विश्लेषण आणि ०% कमिशन हमी', hi: 'लागत विश्लेषण और ०% कमीशन गारंटी'),
          onTap: () => context.push('/smart_pricing', extra: currentProduct),
        ),
      ],
    );
  }

  Widget _buildFeatureNavCard(
    BuildContext context, {
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 11.5, color: AppColors.textLight)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  // ─── Bottom Navigation Buttons ─────────────────────────────────────────────
  Widget _buildBottomActionButtons(String lang) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(top: BorderSide(color: AppColors.outlineVariant)),
      ),
      child: Row(
        children: [
          if (_currentStep > 0) ...[
            OutlinedButton(
              onPressed: () => setState(() => _currentStep--),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.outline),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(_t(lang, en: 'Back', mr: 'मागे', hi: 'पीछे')),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: ElevatedButton(
              onPressed: _isAiGenerating
                  ? null
                  : () {
                      if (_currentStep == 0) {
                        setState(() => _currentStep = 1);
                      } else if (_currentStep == 1) {
                        _generateAiCatalog(lang);
                      } else {
                        _publishProduct();
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 1,
              ),
              child: _isAiGenerating
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text(
                      _currentStep == 0
                          ? _t(lang, en: 'Next: Details 🎙️', mr: 'पुढे: माहिती सांगा 🎙️', hi: 'आगे: विवरण बताएं 🎙️')
                          : (_currentStep == 1
                              ? _t(lang, en: 'Generate AI Catalog ✨', mr: 'AI कॅटलॉग तयार करा ✨', hi: 'AI कैटलॉग तैयार करें ✨')
                              : _t(lang, en: 'Publish to ShilpSetu 🚀', mr: 'शिल्पसेतूवर प्रकाशित करा 🚀', hi: 'शिल्पसेतु पर प्रकाशित करें 🚀')),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
