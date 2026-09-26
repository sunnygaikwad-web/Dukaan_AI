import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AiStudioScreen extends StatefulWidget {
  final File imageFile;
  const AiStudioScreen({super.key, required this.imageFile});

  @override
  State<AiStudioScreen> createState() => _AiStudioScreenState();
}

class _AiStudioScreenState extends State<AiStudioScreen> {
  int _currentStep = 0;
  bool _isProcessing = true;

  final List<String> _stages = [
    'Analyzing product...',
    'Removing background...',
    'Improving lighting...',
    'Optimizing composition...',
    'Creating e-commerce image...'
  ];

  @override
  void initState() {
    super.initState();
    _startProcessing();
  }

  Future<void> _startProcessing() async {
    for (int i = 0; i < _stages.length; i++) {
      if (!_isProcessing) return;
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted && _isProcessing) {
        setState(() {
          _currentStep = i;
        });
      }
    }
    await Future.delayed(const Duration(milliseconds: 150));
    if (mounted) {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _skipToFinish() {
    setState(() {
      _currentStep = _stages.length - 1;
      _isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Craft Photo Studio'),
        actions: [
          if (_isProcessing)
            TextButton.icon(
              onPressed: _skipToFinish,
              icon: const Icon(Icons.bolt, color: Colors.amber, size: 18),
              label: const Text('Instant Finish', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Making your product ready for the market...',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              if (_isProcessing)
                Expanded(
                  child: ListView.builder(
                    itemCount: _stages.length,
                    itemBuilder: (context, index) {
                      bool isCompleted = index < _currentStep;
                      bool isCurrent = index == _currentStep;
                      return ListTile(
                        leading: isCompleted
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : (isCurrent
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2))
                                : const Icon(Icons.circle_outlined, color: Colors.grey)),
                        title: Text(
                          _stages[index],
                          style: TextStyle(
                            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                            color: isCompleted || isCurrent ? Colors.black : Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                )
              else
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  const Text('BEFORE', style: TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: (widget.imageFile.path.isNotEmpty && widget.imageFile.existsSync())
                                            ? DecorationImage(
                                                image: FileImage(widget.imageFile),
                                                fit: BoxFit.cover,
                                              )
                                            : null,
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: (widget.imageFile.path.isEmpty || !widget.imageFile.existsSync())
                                          ? const Center(
                                              child: Icon(Icons.image_outlined, size: 48, color: Colors.grey),
                                            )
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                children: [
                                  const Text('AFTER', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                                  const SizedBox(height: 8),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: (widget.imageFile.path.isNotEmpty && widget.imageFile.existsSync())
                                            ? DecorationImage(
                                                image: FileImage(widget.imageFile),
                                                fit: BoxFit.cover,
                                              )
                                            : null,
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.green.withValues(alpha: 0.3),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                          )
                                        ],
                                      ),
                                      child: (widget.imageFile.path.isEmpty || !widget.imageFile.existsSync())
                                          ? const Center(
                                              child: Icon(Icons.photo_library_rounded, size: 48, color: Colors.green),
                                            )
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),
              if (!_isProcessing) ...[
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to voice description with image
                    context.push('/voice_cataloger', extra: widget.imageFile);
                  },
                  icon: const Icon(Icons.mic_rounded),
                  label: const Text('Add Voice Description ➔'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop(widget.imageFile);
                    } else {
                      context.push('/add_product');
                    }
                  },
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Use in Add Product Wizard'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
