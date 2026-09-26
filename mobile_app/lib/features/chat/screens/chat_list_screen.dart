// lib/features/chat/screens/chat_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/chat_provider.dart';
import '../../../core/providers/user_profile_provider.dart';

class ChatListScreen extends StatefulWidget {
  final bool isEmbeddedInTab;

  const ChatListScreen({
    super.key,
    this.isEmbeddedInTab = false,
  });

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final userProfile = context.watch<UserProfileProvider>();
    final role = userProfile.currentRole;
    final isBuyer = role == 'buyer';

    final threads = chatProvider.threads.where((t) {
      final q = _searchController.text.trim().toLowerCase();
      if (q.isEmpty) return true;
      final target = isBuyer
          ? '${t.artisanName} ${t.artisanCraft} ${t.activeProductTitle ?? ""}'.toLowerCase()
          : '${t.buyerName} ${t.buyerOrg} ${t.activeProductTitle ?? ""}'.toLowerCase();
      return target.contains(q);
    }).toList();

    final body = Column(
      children: [
        // ─── Header Info Card ──────────────────────────
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isBuyer
                  ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
                  : [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: (isBuyer ? const Color(0xFF0F172A) : AppColors.primary).withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.forum_rounded, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isBuyer
                          ? 'Direct Artisan Communication'
                          : 'थेट खरेदीदार संवाद (Buyer Chats)',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isBuyer
                          ? 'Zero Middlemen • Wholesale Quotes • Authentic Craft Direct'
                          : 'घाऊक मागण्या, दर चर्चा व थेट ऑर्डर पुष्टीकरण',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ─── Search Bar ────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: SizedBox(
            height: 42,
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                hintText: isBuyer
                    ? 'Search artisan, craft or product...'
                    : 'खरेदीदार किंवा उत्पादन शोधा...',
                hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 12.5),
                prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.textLight),
                prefixIconConstraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                filled: true,
                fillColor: AppColors.surfaceContainerLowest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.outlineVariant),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
        ),

        const SizedBox(height: 4),

        // ─── Threads List ──────────────────────────────
        Expanded(
          child: threads.isEmpty
              ? _buildEmptyState(isBuyer)
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 20),
                  itemCount: threads.length,
                  separatorBuilder: (_, i) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final thread = threads[index];
                    return _buildThreadTile(context, thread, role);
                  },
                ),
        ),
      ],
    );

    if (widget.isEmbeddedInTab) {
      return body;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          isBuyer ? 'Artisan Messages' : 'Buyer Inquiries',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: body,
    );
  }

  Widget _buildThreadTile(BuildContext context, ChatThread thread, String role) {
    final isBuyer = role == 'buyer';
    final name = isBuyer ? thread.artisanName : thread.buyerName;
    final subtitle = isBuyer ? thread.artisanCraft : thread.buyerOrg;
    final unread = thread.unreadCountForRole(role);
    final lastMsg = thread.lastMessage;
    final timeStr = lastMsg != null
        ? '${lastMsg.timestamp.hour.toString().padLeft(2, '0')}:${lastMsg.timestamp.minute.toString().padLeft(2, '0')}'
        : '';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: unread > 0 ? AppColors.primary.withValues(alpha: 0.4) : AppColors.outlineVariant,
          width: unread > 0 ? 1.5 : 1,
        ),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        onTap: () {
          context.push('/chat_conversation', extra: {'threadId': thread.id});
        },
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: isBuyer ? AppColors.primaryFixed : const Color(0xFFE0E7FF),
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : 'A',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isBuyer ? AppColors.primary : const Color(0xFF4338CA),
                ),
              ),
            ),
            if (thread.isOnline)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              timeStr,
              style: TextStyle(
                fontSize: 11,
                fontWeight: unread > 0 ? FontWeight.bold : FontWeight.normal,
                color: unread > 0 ? AppColors.primary : AppColors.textLight,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11.5, color: AppColors.textLight),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    lastMsg?.text ?? 'No messages yet',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: unread > 0 ? FontWeight.w700 : FontWeight.normal,
                      color: unread > 0 ? AppColors.textPrimary : AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (unread > 0)
                  Container(
                    margin: const EdgeInsets.only(left: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$unread',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isBuyer) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.chat_bubble_outline_rounded, size: 48, color: AppColors.textLight.withValues(alpha: 0.5)),
          const SizedBox(height: 12),
          Text(
            isBuyer ? 'No artisan chats found' : 'No buyer inquiries yet',
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            isBuyer
                ? 'Tap "Chat with Artisan" on any product to initiate a wholesale inquiry.'
                : 'When buyers request bulk quotes, you will be able to message them here.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: AppColors.textLight),
          ),
        ],
      ),
    );
  }
}
