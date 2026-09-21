// lib/features/products/screens/smart_pricing_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_localizations.dart';
import '../../../core/providers/user_profile_provider.dart';
import '../../../core/providers/product_provider.dart';
import '../../../models/product_model.dart';

enum CurrencyType { inr, usd, eur }

class SmartPricingScreen extends StatefulWidget {
  final ProductModel? product;

  const SmartPricingScreen({super.key, this.product});

  @override
  State<SmartPricingScreen> createState() => _SmartPricingScreenState();
}

class _SmartPricingScreenState extends State<SmartPricingScreen> {
  CurrencyType _currency = CurrencyType.inr;
  double _profitMargin = 15.0; // Percentage (5% - 40%)

  // Base production breakdown
  double _baseMaterial = 1200;
  double _baseLabor = 1850;
  double _baseHeritage = 1800;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    if (p != null) {
      final total = p.pricing.recommended;
      _baseMaterial = (total * 0.28).roundToDouble();
      _baseLabor = (total * 0.38).roundToDouble();
      _baseHeritage = (total * 0.34).roundToDouble();
    }
  }

  double get _currentTotal {
    final multiplier = 1.0 + (_profitMargin / 100.0);
    return (_baseMaterial + _baseLabor + _baseHeritage) * multiplier;
  }

  String _formatMoney(double inrAmount) {
    switch (_currency) {
      case CurrencyType.usd:
        final usd = (inrAmount * 0.012).toStringAsFixed(2);
        return '\$$usd';
      case CurrencyType.eur:
        final eur = (inrAmount * 0.011).toStringAsFixed(2);
        return '€$eur';
      case CurrencyType.inr:
        return '₹${inrAmount.round()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLang = context.watch<UserProfileProvider>().selectedLanguage;
    final p = widget.product ?? ProductModel.demoProducts.first;

    final multiplier = 1.0 + (_profitMargin / 100.0);
    final materialVal = _baseMaterial * multiplier;
    final laborVal = _baseLabor * multiplier;
    final heritageVal = _baseHeritage * multiplier;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppLocalizations.tr('smart_pricing_title', appLang),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Recommended Price Header Card ───────────────────────
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.outline),
                  boxShadow: const [
                    BoxShadow(color: AppColors.cardShadow, blurRadius: 14, offset: Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryFixed,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.auto_awesome, size: 14, color: AppColors.primaryDark),
                              const SizedBox(width: 4),
                              Text(
                                AppLocalizations.tr('fair_pricing_engine_tag', appLang),
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.successContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '0% Commission',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.success,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    Text(
                      AppLocalizations.tr('recommended_price', appLang),
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textLight),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatMoney(_currentTotal),
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      AppLocalizations.tr('fair_pricing_subtitle', appLang),
                      style: const TextStyle(fontSize: 13.5, color: AppColors.textSecondary, height: 1.4),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ── Global Currency View Bar ───────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outline),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.currency_exchange_rounded, size: 18, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        AppLocalizations.tr('currency_view', appLang),
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                    ),
                    _buildCurrencyChip(CurrencyType.inr, 'INR (₹)'),
                    const SizedBox(width: 6),
                    _buildCurrencyChip(CurrencyType.usd, 'USD (\$)'),
                    const SizedBox(width: 6),
                    _buildCurrencyChip(CurrencyType.eur, 'EUR (€)'),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ── Fair Price Breakdown List ──────────────────────────
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.outline),
                  boxShadow: const [
                    BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 3)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.tr('price_breakdown', appLang),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        const Icon(Icons.analytics_outlined, color: AppColors.primary, size: 20),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Item 1: Material Cost
                    _buildBreakdownItem(
                      icon: Icons.inventory_2_outlined,
                      title: AppLocalizations.tr('material_cost', appLang),
                      subtitle: AppLocalizations.tr('material_desc', appLang),
                      amount: _formatMoney(materialVal),
                    ),
                    const SizedBox(height: 10),

                    // Item 2: Labor Cost
                    _buildBreakdownItem(
                      icon: Icons.schedule_rounded,
                      title: AppLocalizations.tr('labor_cost', appLang),
                      subtitle: AppLocalizations.tr('labor_desc', appLang),
                      amount: _formatMoney(laborVal),
                    ),
                    const SizedBox(height: 10),

                    // Item 3: Heritage & GI Value
                    _buildBreakdownItem(
                      icon: Icons.stars_rounded,
                      title: AppLocalizations.tr('heritage_gi_cost', appLang),
                      subtitle: AppLocalizations.tr('heritage_gi_desc', appLang),
                      amount: _formatMoney(heritageVal),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ── Fair Profit Margin Slider ──────────────────────────
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.outline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.tr('profit_margin_slider', appLang),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '+${_profitMargin.toStringAsFixed(0)}%',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppColors.secondary,
                        inactiveTrackColor: AppColors.surfaceContainer,
                        thumbColor: AppColors.secondary,
                        overlayColor: AppColors.secondary.withValues(alpha: 0.15),
                        trackHeight: 6,
                      ),
                      child: Slider(
                        value: _profitMargin,
                        min: 5.0,
                        max: 40.0,
                        divisions: 7,
                        onChanged: (val) {
                          setState(() {
                            _profitMargin = val;
                          });
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('5% (Wholesale)', style: TextStyle(fontSize: 11, color: AppColors.textLight)),
                        Text('20% (Recommended)', style: TextStyle(fontSize: 11, color: AppColors.textLight)),
                        Text('40% (Global Exhibition)', style: TextStyle(fontSize: 11, color: AppColors.textLight)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ── Zero Commission Callout ────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.successContainer,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline_rounded, color: AppColors.success, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        AppLocalizations.tr('zero_commission_banner', appLang),
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Publish to ShilpSetu Store Button ──────────────────
              ElevatedButton(
                onPressed: () async {
                  // Update product pricing and publish to provider
                  final updatedPricing = PricingInfo(
                    recommended: _currentTotal,
                    minimum: (_currentTotal * 0.88).roundToDouble(),
                    marketLow: (_currentTotal * 0.85).roundToDouble(),
                    marketHigh: (_currentTotal * 1.15).roundToDouble(),
                    confidenceScore: 0.94,
                    productionCost: materialVal + laborVal,
                    factors: ['Sustainable Raw Materials', 'Living Wage Standard', 'GI Heritage Premium'],
                  );

                  final updatedProduct = ProductModel(
                    id: p.id.isNotEmpty ? p.id : 'prod_${DateTime.now().millisecondsSinceEpoch}',
                    artisanId: p.artisanId.isNotEmpty ? p.artisanId : 'artisan_001',
                    status: 'published',
                    originalImageUrl: p.originalImageUrl,
                    enhancedImageUrl: p.enhancedImageUrl,
                    catalog: p.catalog,
                    pricing: updatedPricing,
                    metadata: p.metadata,
                    createdAt: DateTime.now(),
                  );

                  await context.read<ProductProvider>().addProduct(updatedProduct);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(AppLocalizations.tr('published_success', appLang)),
                          ],
                        ),
                        backgroundColor: AppColors.success,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    context.go('/publish_success');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 3,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.storefront_rounded, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.tr('publish_to_dukaan', appLang),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencyChip(CurrencyType type, String label) {
    final isSelected = _currency == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currency = type;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outline,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildBreakdownItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String amount,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryFixed,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: AppColors.textPrimary),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11.5, color: AppColors.textLight),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
