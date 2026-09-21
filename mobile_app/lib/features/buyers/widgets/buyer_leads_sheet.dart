// lib/features/buyers/widgets/buyer_leads_sheet.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_localizations.dart';
import '../../../core/providers/user_profile_provider.dart';

class BuyerLeadItem {
  final String id;
  final String buyerName;
  final String location;
  final String requestedCraft;
  final String budget;
  final String urgency;
  final String avatarUrl;
  final String note;

  const BuyerLeadItem({
    required this.id,
    required this.buyerName,
    required this.location,
    required this.requestedCraft,
    required this.budget,
    required this.urgency,
    required this.avatarUrl,
    required this.note,
  });
}

class BuyerLeadsSheet extends StatelessWidget {
  const BuyerLeadsSheet({super.key});

  static const List<BuyerLeadItem> leads = [
    BuyerLeadItem(
      id: 'lead-1',
      buyerName: 'Maison Étoile Gallery',
      location: 'Paris, France',
      requestedCraft: 'Handwoven Paithani Silk Sarees & Dupattas',
      budget: '€4,200 (Bulk Order 10 pcs)',
      urgency: 'High',
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80',
      note: 'Curating authentic Indian festive textiles for an autumn Parisian exhibition.',
    ),
    BuyerLeadItem(
      id: 'lead-2',
      buyerName: 'Ananya Boutique',
      location: 'Mumbai, India',
      requestedCraft: 'Terracotta Hand-Painted Planters & Vessels',
      budget: '₹45,000 (Set of 18)',
      urgency: 'High',
      avatarUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=200&q=80',
      note: 'Looking for verified master craftswomen for exclusive Diwali festive release.',
    ),
    BuyerLeadItem(
      id: 'lead-3',
      buyerName: 'Aura Lifestyle Studio',
      location: 'London, UK',
      requestedCraft: 'Natural Clay Tableware & Urns',
      budget: '£1,850',
      urgency: 'Medium',
      avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=200&q=80',
      note: 'Eco-conscious design house seeking direct relationship with rural potters.',
    ),
  ];

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const BuyerLeadsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<UserProfileProvider>().selectedLanguage;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 44,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryFixed,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.storefront_rounded, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.tr('buyer_leads_title', lang),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary),
                    ),
                    Text(
                      AppLocalizations.tr('buyer_leads_sub', lang),
                      style: const TextStyle(fontSize: 12, color: AppColors.textLight),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 8),

          // Leads List
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: leads.length,
              separatorBuilder: (context, index) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final lead = leads[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.outline),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundImage: NetworkImage(lead.avatarUrl),
                            backgroundColor: AppColors.surfaceContainer,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lead.buyerName,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on_outlined, size: 12, color: AppColors.textLight),
                                    const SizedBox(width: 2),
                                    Text(
                                      lead.location,
                                      style: const TextStyle(fontSize: 12, color: AppColors.textLight),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: lead.urgency == 'High' ? AppColors.errorContainer : AppColors.primaryFixed,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${lead.urgency} Urgency',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: lead.urgency == 'High' ? AppColors.error : AppColors.primaryDark,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.outline.withValues(alpha: 0.5)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lead.requestedCraft,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: AppColors.primary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              lead.note,
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Budget / Order Size', style: TextStyle(fontSize: 11, color: AppColors.textLight)),
                              Text(
                                lead.budget,
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5, color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const Icon(Icons.send_rounded, color: Colors.white),
                                      const SizedBox(width: 8),
                                      Expanded(child: Text(AppLocalizations.tr('quote_sent', lang))),
                                    ],
                                  ),
                                  backgroundColor: AppColors.success,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            icon: const Icon(Icons.send_rounded, size: 16),
                            label: Text(
                              AppLocalizations.tr('contact_buyer', lang),
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
