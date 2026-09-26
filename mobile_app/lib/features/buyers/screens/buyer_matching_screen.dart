// lib/features/buyers/screens/buyer_matching_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shilpsetu_ai/models/buyer_model.dart';
import 'package:shilpsetu_ai/core/theme/app_theme.dart';
import 'package:shilpsetu_ai/core/providers/buyer_request_provider.dart';

class BuyerMatchingScreen extends StatelessWidget {
  const BuyerMatchingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final buyers = BuyerModel.demoBuyers;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('AI Buyer Matches',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.lavenderLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.lavender,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.handshake_rounded, color: AppColors.secondary, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '4 verified B2B buyers seeking your craft',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Based on your craft category, materials, and regional buyer procurement trends',
                        style: TextStyle(
                            color: AppColors.secondaryDark, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...buyers.map((buyer) => _BuyerMatchCard(buyer: buyer)),
        ],
      ),
    );
  }
}

class _BuyerMatchCard extends StatelessWidget {
  final BuyerModel buyer;
  const _BuyerMatchCard({required this.buyer});

  Color _matchColor(int score) {
    if (score >= 80) return Colors.green.shade700;
    if (score >= 60) return Colors.orange.shade800;
    return Colors.blue.shade700;
  }

  @override
  Widget build(BuildContext context) {
    final color = _matchColor(buyer.matchScore);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: color.withValues(alpha: 0.12),
                child: Text(
                  buyer.name[0],
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      buyer.organization,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      '${buyer.businessCategory} • ${buyer.location}',
                      style: TextStyle(
                          color: AppColors.textLight, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${buyer.matchScore}% Match',
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb_outline,
                    size: 18, color: Colors.amber),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    buyer.matchReason,
                    style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _sendCatalogToBuyer(context, buyer),
                  icon: const Icon(Icons.send, size: 18),
                  label: const Text('Send Catalog'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 44),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _contactBuyerDirectly(context, buyer),
                  icon: const Icon(Icons.call_outlined, size: 18),
                  label: const Text('Contact'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 44),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _sendCatalogToBuyer(BuildContext context, BuyerModel buyer) {
    final provider = context.read<BuyerRequestProvider>();
    final newInquiry = BuyerRequestModel(
      id: 'req_${DateTime.now().millisecondsSinceEpoch}',
      buyerName: buyer.name,
      buyerOrg: buyer.organization,
      buyerLocation: buyer.location,
      productId: 'prod_auto_catalog',
      productTitle: 'Artisan Digital Catalog (${buyer.requiredCategories.join(", ")})',
      productPrice: 'Bulk Quote',
      quantity: 20,
      expectedDelivery: '30 Days',
      message: 'Catalog sent to ${buyer.organization}. Procurement team is reviewing your product listings.',
      status: 'pending',
      createdAt: DateTime.now(),
    );

    provider.submitRequest(newInquiry);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Catalog Sent! 🎉'),
        content: Text(
            'Your digital craft catalog has been delivered to ${buyer.organization} (${buyer.location}). An inquiry ticket has been logged in your Buyer Requests.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Done')),
        ],
      ),
    );
  }

  void _contactBuyerDirectly(BuildContext context, BuyerModel buyer) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('📞 Connecting to ${buyer.organization} procurement team...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
