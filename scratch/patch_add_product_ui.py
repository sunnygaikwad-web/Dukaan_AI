import os

target_file = r'c:\Users\Sunny\AndroidStudioProjects\ShilpSetu_AI\mobile_app\lib\features\products\screens\add_product_screen.dart'

with open(target_file, 'r', encoding='utf-8') as f:
    code = f.read()

# 1. Update _generateAiCatalog to be ultra-fast and never hang on 30s timeout
old_gen_catalog = '''  Future<void> _generateAiCatalog(String lang) async {
    setState(() {
      _isAiGenerating = true;
    });

    try {
      final profile = context.read<UserProfileProvider>().profile;
      final transcript = _transcriptController.text.trim();
      final location = profile.state.isNotEmpty ? \'${profile.location}, ${profile.state}, India\' : \'Maharashtra, India\';
      final aiService = AiService();

      Map<String, dynamic>? aiResult;

      // ── Priority 1: Gemini Vision from real camera/gallery image ──────────
      if (_pickedImage != null && aiService.isLiveAiAvailable) {
        aiResult = await aiService.analyzeImageAndGenerateCatalog(
          imageFile: _pickedImage!,
          voiceTranscript: transcript.isNotEmpty ? transcript : null,
          artisanLocation: location,
        );
      }
      // ── Priority 2: Text-based Gemini (voice transcript available) ────────
      else if (aiService.isLiveAiAvailable) {
        final fallbackTranscript = transcript.isNotEmpty
            ? transcript
            : \'Handmade traditional $_selectedCraft product from $location\';
        aiResult = await aiService.generateCatalog(
          voiceTranscript: fallbackTranscript,
          craftType: _selectedCraft,
          location: location,
        );
      }
      // ── Priority 3: Try ShilpSetu backend ─────────────────────────────────
      else {
        final fallbackTranscript = transcript.isNotEmpty
            ? transcript
            : \'Handmade traditional $_selectedCraft created by artisan in ${profile.state}\';
        final response = await ApiService().generateCatalog(
          transcript: fallbackTranscript,
          artisanLocation: profile.state.isNotEmpty ? profile.state : \'Maharashtra\',
          language: lang,
        );
        if (response != null && response[\'success\'] == true && response[\'data\'] != null) {
          final data = response[\'data\'] as Map<String, dynamic>;
          setState(() {
            if (data[\'en\']?[\'title\'] != null) _titleEn = data[\'en\'][\'title\'];
            if (data[\'mr\']?[\'title\'] != null) _titleMr = data[\'mr\'][\'title\'];
            if (data[\'hi\']?[\'title\'] != null) _titleHi = data[\'hi\'][\'title\'];
            if (data[\'heritage_story\'] != null) _heritageStory = data[\'heritage_story\'];
          });
        } else {
          // ── Priority 4: Demo engine fallback ────────────────────────────────
          aiResult = await aiService.generateCatalog(
            voiceTranscript: transcript.isNotEmpty
                ? transcript
                : \'Handmade traditional $_selectedCraft product\',
            craftType: _selectedCraft,
            location: location,
          );
        }
      }'''

new_gen_catalog = '''  Future<void> _generateAiCatalog(String lang) async {
    setState(() {
      _isAiGenerating = true;
    });

    try {
      final profile = context.read<UserProfileProvider>().profile;
      final transcript = _transcriptController.text.trim();
      final location = profile.state.isNotEmpty ? \'${profile.location}, ${profile.state}, India\' : \'Maharashtra, India\';
      final aiService = AiService();

      Map<String, dynamic>? aiResult;

      // ── Priority 1: Gemini Live AI (if key provided) ──────────
      if (aiService.isLiveAiAvailable) {
        if (_pickedImage != null) {
          aiResult = await aiService.analyzeImageAndGenerateCatalog(
            imageFile: _pickedImage!,
            voiceTranscript: transcript.isNotEmpty ? transcript : null,
            artisanLocation: location,
          );
        } else {
          aiResult = await aiService.generateCatalog(
            voiceTranscript: transcript.isNotEmpty
                ? transcript
                : \'Handmade traditional $_selectedCraft product\',
            craftType: _selectedCraft,
            location: location,
          );
        }
      } else {
        // ── Priority 2: Instant On-Device Demo Engine (No slow network delays!) ──
        aiResult = await aiService.generateCatalog(
          voiceTranscript: transcript.isNotEmpty
              ? transcript
              : \'Handmade traditional $_selectedCraft product\',
          craftType: _selectedCraft,
          location: location,
        );
      }'''

code = code.replace(old_gen_catalog, new_gen_catalog)

# 2. Add AI Analysis card & craft confirmation in _buildStep1Photo
step1_anchor = '''        // Photo Preview or Capture Area'''
step1_replacement = '''        // Gemini AI Key Banner right on Step 1
        _buildGeminiKeyBanner(lang),
        const SizedBox(height: 14),

        // Photo Preview or Capture Area'''

code = code.replace(step1_anchor, step1_replacement)

step1_end_anchor = '''        const SizedBox(height: 20),

        // Authentic Craft Presets Selector'''

step1_end_replacement = '''        // ── AI Vision Identification Status Card ─────────────────────────────
        if (_isAnalyzingImage) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primaryFixed,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _t(
                      lang,
                      en: '🤖 AI is analyzing photo: Identifying craft, material & market price...',
                      mr: '🤖 AI फोटो तपासत आहे: हस्तकला, साहित्य व बाजार किंमत ओळखत आहे...',
                      hi: '🤖 AI फोटो का विश्लेषण कर रहा है: शिल्प, सामग्री व मूल्य पहचान रहा है...',
                    ),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
        ] else if (hasImage) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green.shade400),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: Colors.green, size: 22),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'AI Identified: ${_aiDetectedCraft ?? _selectedCraft}',
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5, color: Colors.green.shade900),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '₹${_recommendedPrice.toInt()}',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13.5, color: Colors.green.shade900),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '🏷️ Category: $_selectedCraft • ${_heritageStory.substring(0, _heritageStory.length > 75 ? 75 : _heritageStory.length)}...',
                  style: TextStyle(fontSize: 11.5, color: Colors.green.shade800),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _t(lang, en: 'Confirm or Change Craft Category:', mr: 'हस्तकलेचा प्रकार तपासा किंवा बदला:', hi: 'हस्तशिल्प श्रेणी की पुष्टि करें या बदलें:'),
            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: _craftCategories.map((c) {
              final isSel = _selectedCraft == c['id'];
              return ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(c['icon'], style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 4),
                    Text(_t(lang, en: c['title'], mr: c['marathi'], hi: c['hindi'])),
                  ],
                ),
                selected: isSel,
                selectedColor: AppColors.primaryFixed,
                labelStyle: TextStyle(
                  color: isSel ? AppColors.primary : AppColors.textPrimary,
                  fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
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
                      _aiDetectedCraft = c['title'];
                    });
                  }
                },
              );
            }).toList(),
          ),
        ],

        const SizedBox(height: 20),

        // Authentic Craft Presets Selector'''

code = code.replace(step1_end_anchor, step1_end_replacement)

# 3. Update Step 2 Voice & Description area
step2_voice_anchor = '''              // Audio Playback Preview
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
              ),'''

step2_voice_replacement = '''              // Audio Playback Preview
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

              // Voice Translating Status Indicator
              if (_isTranscribingVoice) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryFixed,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)),
                      const SizedBox(width: 10),
                      Text(
                        _t(lang,
                          en: '🤖 AI translating voice to English description...',
                          mr: '🤖 AI आवाजाचे इंग्रजीत भाषांतर करत आहे...',
                          hi: '🤖 AI आवाज का अंग्रेजी में अनुवाद कर रहा है...'),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // Description Box Header with English Translation indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _t(lang,
                      en: 'Product Description (English):',
                      mr: 'उत्पादन वर्णन (इंग्रजी भाषांतर):',
                      hi: 'उत्पाद विवरण (अंग्रेजी अनुवाद):'),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                  ),
                  TextButton.icon(
                    onPressed: _isTranscribingVoice ? null : _translateCurrentTextToEnglish,
                    icon: const Icon(Icons.translate_rounded, size: 14, color: AppColors.primary),
                    label: Text(
                      _t(lang, en: 'Translate to English', mr: 'इंग्रजीत भाषांतर करा', hi: 'अंग्रेजी में अनुवाद करें'),
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                    style: TextButton.styleFrom(padding: EdgeInsets.zero, visualDensity: VisualDensity.compact),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // Transcript Field (English description)
              TextField(
                controller: _transcriptController,
                maxLines: 4,
                style: const TextStyle(fontSize: 14, height: 1.4),
                decoration: InputDecoration(
                  hintText: _t(
                    lang,
                    en: 'Speak in Marathi/Hindi, AI will automatically translate to English here...',
                    mr: 'आपल्या भाषेत बोला, AI आपोआप इंग्रजीत भाषांतर करून येथे लिहील...',
                    hi: 'अपनी भाषा में बोलें, AI स्वतः अंग्रेजी में अनुवाद करके यहाँ लिखेगा...',
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.outlineVariant)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
                  contentPadding: const EdgeInsets.all(14),
                ),
              ),
              const SizedBox(height: 6),

              // Translation confirmation chip
              Row(
                children: [
                  const Icon(Icons.verified_rounded, size: 14, color: AppColors.success),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      _t(
                        lang,
                        en: 'Auto-translated to English so buyers across India & abroad can discover your craft.',
                        mr: 'ग्राहकांसाठी आपोआप इंग्रजीत अनुवादित केले जेणेकरून उत्पादन सहज विकले जाईल.',
                        hi: 'खरीदारों के लिए स्वतः अंग्रेजी में अनुवादित ताकि उत्पाद आसानी से बिक सके।',
                      ),
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),

              // Display original voice speech if recorded
              if (_voiceOriginalTranscript != null && _voiceOriginalTranscript!.isNotEmpty) ...[
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.outlineVariant),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.record_voice_over_rounded, size: 14, color: AppColors.textLight),
                          const SizedBox(width: 6),
                          Text(
                            _t(lang, en: 'Original Voice Spoken:', mr: 'मूळ बोललेला आवाज:', hi: 'मूल बोली गई आवाज:'),
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textLight),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _voiceOriginalTranscript!,
                        style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ],'''

code = code.replace(step2_voice_anchor, step2_voice_replacement)

# 4. Update Step 3 Product Summary Card to show both translated voice description and authentic story
step3_card_anchor = '''              Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17.5, color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              Text(_heritageStory, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4)),
              const Divider(height: 24),'''

step3_card_replacement = '''              Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17.5, color: AppColors.textPrimary)),
              const SizedBox(height: 10),

              // Artisan Voice Description (English)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryFixed.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.description_rounded, size: 14, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text(
                          _t(lang, en: 'Product Description (Artisan Voice)', mr: 'उत्पादन वर्णन (कारागिराचा आवाज)', hi: 'उत्पाद विवरण (कारीगर की आवाज)'),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5, color: AppColors.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _transcriptController.text.isNotEmpty
                          ? _transcriptController.text
                          : \'Authentic handcrafted $_selectedCraft created with traditional artisan techniques.\',
                      style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.35),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Cultural Heritage Narrative
              Row(
                children: [
                  const Icon(Icons.history_edu_rounded, size: 14, color: AppColors.textLight),
                  const SizedBox(width: 6),
                  Text(
                    _t(lang, en: 'Cultural Heritage Story:', mr: 'सांस्कृतिक वारसा कथा:', hi: 'सांस्कृतिक विरासत कथा:'),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5, color: AppColors.textLight),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(_heritageStory, style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.4)),
              const Divider(height: 24),'''

code = code.replace(step3_card_anchor, step3_card_replacement)

with open(target_file, 'w', encoding='utf-8') as f:
    f.write(code)

print("Finished phase 2 patch of add_product_screen.dart")
