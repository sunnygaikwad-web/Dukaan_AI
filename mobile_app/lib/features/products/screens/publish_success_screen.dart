import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class PublishSuccessScreen extends StatefulWidget {
  const PublishSuccessScreen({super.key});

  @override
  State<PublishSuccessScreen> createState() => _PublishSuccessScreenState();
}

class _PublishSuccessScreenState extends State<PublishSuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _scaleAnimation =
        CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut);
    _scaleController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: const Text(
                  '🎉',
                  style: TextStyle(fontSize: 80),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Your craft is now\ndigitally visible!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Your product has been published to the Dukaan marketplace and is now visible to buyers across India.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 15, height: 1.5),
              ),
              const SizedBox(height: 40),
              // Product details card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06), blurRadius: 12)
                  ],
                ),
                child: Column(
                  children: [
                    _DetailRow(
                        label: 'Product ID', value: '#CRAFT_${DateTime.now().millisecondsSinceEpoch % 10000}'),
                    const Divider(height: 20),
                    _DetailRow(label: 'Status', value: '✅ Published'),
                    const Divider(height: 20),
                    _DetailRow(
                        label: 'Published On',
                        value: DateTime.now()
                            .toLocal()
                            .toString()
                            .split(' ')[0]),
                    const Divider(height: 20),
                    _DetailRow(label: 'AI Buyer Matches', value: '4 Ready'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => context.go('/my_products'),
                icon: const Icon(Icons.inventory_2_rounded),
                label: const Text('View in My Products'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  Clipboard.setData(const ClipboardData(text: 'https://dukaan.app/catalog/live'));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('🔗 Digital Catalog link copied! Ready to share with B2B buyers.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                icon: const Icon(Icons.share),
                label: const Text('Share My Catalog'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => context.push('/buyer_matching'),
                      icon: const Icon(Icons.handshake_outlined),
                      label: const Text('Matching Buyers', style: TextStyle(fontSize: 15)),
                    ),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => context.go('/home'),
                      icon: const Icon(Icons.home_outlined),
                      label: const Text('Back to Home', style: TextStyle(fontSize: 15)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }
}
