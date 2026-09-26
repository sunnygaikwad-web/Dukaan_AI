import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/buyer_request_provider.dart';
import '../../../core/providers/chat_provider.dart';

class BuyerRequestsScreen extends StatefulWidget {
  const BuyerRequestsScreen({super.key});

  @override
  State<BuyerRequestsScreen> createState() => _BuyerRequestsScreenState();
}

class _BuyerRequestsScreenState extends State<BuyerRequestsScreen> {
  String _selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final requestProvider = context.watch<BuyerRequestProvider>();
    final allRequests = requestProvider.requests;

    final filteredRequests = _selectedFilter == 'all'
        ? allRequests
        : allRequests.where((r) => r.status == _selectedFilter).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Buyer Requests',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'Bulk orders & trade inquiries',
              style: TextStyle(color: AppColors.textLight, fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Buyer Chats',
            icon: const Icon(Icons.forum_outlined, color: AppColors.primary),
            onPressed: () => context.push('/chat_list'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // ─── Filter Tabs ─────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('all', 'All (${allRequests.length})'),
                  _buildFilterChip('pending', 'Pending (${requestProvider.pendingCount})'),
                  _buildFilterChip('accepted', 'Accepted (${allRequests.where((r) => r.status == 'accepted').length})'),
                ],
              ),
            ),
          ),

          // ─── Requests List ───────────────────────────
          Expanded(
            child: filteredRequests.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filteredRequests.length,
                    itemBuilder: (context, index) {
                      final item = filteredRequests[index];
                      return _BuyerRequestCard(
                        request: item,
                        onAccept: () => _handleAccept(context, requestProvider, item),
                        onReject: () => _handleReject(context, requestProvider, item),
                        onContact: () => _handleContact(context, item),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _selectedFilter == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = value),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outlineVariant,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No requests in this tab',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'When verified B2B buyers place bulk orders for your handicrafts, they will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textLight, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  void _handleAccept(BuildContext context, BuyerRequestProvider provider, BuyerRequestModel item) {
    provider.updateStatus(item.id, 'accepted');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Accepted bulk inquiry from ${item.buyerOrg}!'),
        backgroundColor: Colors.green.shade700,
      ),
    );
  }

  void _handleReject(BuildContext context, BuyerRequestProvider provider, BuyerRequestModel item) {
    provider.updateStatus(item.id, 'rejected');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Inquiry from ${item.buyerOrg} declined.'),
      ),
    );
  }

  void _handleContact(BuildContext context, BuyerRequestModel item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Contact ${item.buyerName}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 4),
            Text('${item.buyerOrg} • ${item.buyerLocation}', style: TextStyle(color: AppColors.textLight)),
            const SizedBox(height: 20),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primaryFixed,
                child: const Icon(Icons.forum_rounded, color: AppColors.primary),
              ),
              title: const Text('In-App Direct Chat', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Message ${item.buyerOrg} directly in ShilpSetu'),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
              onTap: () {
                Navigator.pop(ctx);
                final chatProvider = context.read<ChatProvider>();
                final thread = chatProvider.getOrCreateThread(
                  artisanName: 'Om Gaikwad',
                  artisanCraft: item.productTitle,
                  buyerName: item.buyerName,
                  buyerOrg: item.buyerOrg,
                  productTitle: item.productTitle,
                  productPrice: '₹${item.productPrice} x ${item.quantity}',
                );
                context.push('/chat_conversation', extra: thread.id);
              },
            ),
            ListTile(
              leading: const CircleAvatar(backgroundColor: AppColors.successContainer, child: Icon(Icons.chat, color: AppColors.success)),
              title: const Text('WhatsApp Chat'),
              subtitle: const Text('Connect directly to discuss order terms'),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening WhatsApp chat with buyer...')),
                );
              },
            ),
            ListTile(
              leading: CircleAvatar(backgroundColor: AppColors.primaryFixed, child: Icon(Icons.call, color: AppColors.primary)),
              title: const Text('Voice Call'),
              subtitle: const Text('Call buyer procurement desk'),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Initiating direct call to buyer...')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _BuyerRequestCard extends StatelessWidget {
  final BuyerRequestModel request;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onContact;

  const _BuyerRequestCard({
    required this.request,
    required this.onAccept,
    required this.onReject,
    required this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    final isPending = request.status == 'pending';
    final isAccepted = request.status == 'accepted';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPending ? AppColors.primary.withValues(alpha: 0.3) : AppColors.outlineVariant,
          width: isPending ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primaryFixed,
                child: Text(
                  request.buyerOrg.isNotEmpty ? request.buyerOrg[0] : 'B',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.buyerOrg,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Text(
                      '${request.buyerName} • ${request.buyerLocation}',
                      style: TextStyle(color: AppColors.textLight, fontSize: 12),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(),
            ],
          ),
          const SizedBox(height: 14),

          // Target Product Info Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.inventory_2_outlined, size: 20, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.productTitle,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Target Unit Price: ${request.productPrice}',
                        style: TextStyle(color: AppColors.textLight, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryFixed,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${request.quantity} units',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Message
          Text(
            '"${request.message}"',
            style: TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.schedule, size: 14, color: AppColors.textLight),
              const SizedBox(width: 4),
              Text(
                'Required by: ${request.expectedDelivery}',
                style: TextStyle(color: AppColors.textLight, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Action Buttons
          if (isPending)
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ElevatedButton.icon(
                    onPressed: onAccept,
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Accept'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: OutlinedButton(
                    onPressed: onReject,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red.shade700,
                    ),
                    child: const Text('Decline'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: onContact,
                  icon: const Icon(Icons.chat_outlined),
                  color: AppColors.primary,
                  tooltip: 'Contact Buyer',
                ),
              ],
            )
          else if (isAccepted)
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: const Center(
                      child: Text(
                        '✓ Order Accepted • Ready for Dispatch',
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: onContact,
                  icon: const Icon(Icons.chat_outlined),
                  color: AppColors.primary,
                  tooltip: 'Message Buyer',
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color bg;
    Color text;
    String label;

    switch (request.status) {
      case 'accepted':
        bg = Colors.green.shade50;
        text = Colors.green.shade800;
        label = 'ACCEPTED';
        break;
      case 'rejected':
        bg = Colors.red.shade50;
        text = Colors.red.shade800;
        label = 'DECLINED';
        break;
      default:
        bg = Colors.amber.shade50;
        text = Colors.amber.shade900;
        label = 'PENDING';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(color: text, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 0.5),
      ),
    );
  }
}
