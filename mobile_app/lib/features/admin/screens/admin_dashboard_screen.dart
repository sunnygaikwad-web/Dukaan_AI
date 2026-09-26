// lib/features/admin/screens/admin_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/product_provider.dart';
import '../../../core/providers/buyer_request_provider.dart';
import '../../../core/providers/user_profile_provider.dart';
import '../../../core/services/ai_service.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final _aiService = AiService();
  final _apiKeyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _apiKeyController.text = _aiService.geminiApiKey;
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final requestProvider = context.watch<BuyerRequestProvider>();
    final userProvider = context.watch<UserProfileProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.admin_panel_settings, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dukaan Command Center', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('Platform Administration & Operations', style: TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Log Out of Admin',
            icon: const Icon(Icons.logout, color: AppColors.textPrimary, size: 20),
            onPressed: () async {
              await userProvider.clearProfile();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Platform Metrics Grid ────────────────────
            const Text('National Platform Analytics', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildMetricCard('Total Artisans', '1,420', '+18% this month', Icons.people, AppColors.primary)),
                const SizedBox(width: 12),
                Expanded(child: _buildMetricCard('B2B Buyers', '384', 'Verified Exporters', Icons.business, AppColors.secondary)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildMetricCard('Catalog Items', '${productProvider.totalProductsCount}', 'Active listings', Icons.inventory, AppColors.tertiary)),
                const SizedBox(width: 12),
                Expanded(child: _buildMetricCard('Trade Inquiries', '${requestProvider.requests.length}', '${requestProvider.pendingCount} pending', Icons.handshake, Colors.green.shade700)),
              ],
            ),

            const SizedBox(height: 24),

            // ─── AI Engine Diagnostics ────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.tune_rounded, color: AppColors.primary, size: 20),
                          SizedBox(width: 8),
                          Text('Marketplace Services Configuration', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _aiService.isLiveAiAvailable ? Colors.green.shade50 : Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _aiService.isLiveAiAvailable ? 'LIVE GEMINI' : 'DEMO ENGINE ACTIVE',
                          style: TextStyle(
                            color: _aiService.isLiveAiAvailable ? Colors.green.shade800 : Colors.blue.shade800,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ShilpSetu uses Google Gemini 1.5 Flash for multimodal craft cataloging, trilingual translation (Marathi, Hindi, English), and smart pricing analysis with zero-failure deterministic fallback.',
                    style: TextStyle(color: AppColors.textLight, fontSize: 12, height: 1.4),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _apiKeyController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Google Gemini API Key',
                      hintText: 'Paste Gemini API key here',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.save, color: AppColors.primary),
                        onPressed: () async {
                          final scaffoldMessenger = ScaffoldMessenger.of(context);
                          await _aiService.setGeminiApiKey(_apiKeyController.text);
                          setState(() {});
                          scaffoldMessenger.showSnackBar(
                            SnackBar(
                              content: Text(_aiService.isLiveAiAvailable
                                  ? '✅ Live Gemini API Key Configured!'
                                  : 'Demo Mode Activated (No API key)'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ─── Recent Artisans & Buyers ─────────────────
            const Text('Registered Artisans & Collectives', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildUserTile('Om Gaikwad', 'Master Artisan • Kolhapur, MH', 'Traditional Crafts', true),
            _buildUserTile('Savita Patil', 'Master Artisan • Yeola, MH', 'Paithani Handloom', true),
            _buildUserTile('Ramesh Kumar', 'Potter • Jaipur, RJ', 'Blue Pottery', true),
            _buildUserTile('Asha Devi', 'Folk Artist • Madhubani, BR', 'Madhubani Painting', true),

            const SizedBox(height: 20),

            const Text('Registered B2B Procurement Partners', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildUserTile('Premium Handloom Boutique', 'B2B Retailer • Mumbai', 'Verified Buyer', true, isBuyer: true),
            _buildUserTile('Urban Handicrafts Export', 'International Exporter • Delhi', 'Verified Buyer', true, isBuyer: true),
            _buildUserTile('Hotel Heritage Group', 'Hospitality Decor • Pune', 'Corporate Buyer', true, isBuyer: true),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(color: AppColors.textLight, fontSize: 12)),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: AppColors.textSecondary, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildUserTile(String name, String sub, String badge, bool isActive, {bool isBuyer = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: isBuyer ? AppColors.secondary.withValues(alpha: 0.15) : AppColors.primaryFixed,
            child: Text(
              name.isNotEmpty ? name[0] : 'U',
              style: TextStyle(
                color: isBuyer ? AppColors.secondary : AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text(sub, style: TextStyle(color: AppColors.textLight, fontSize: 11)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              badge,
              style: TextStyle(color: Colors.green.shade800, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
