// lib/features/chat/screens/chat_conversation_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/chat_provider.dart';
import '../../../core/providers/user_profile_provider.dart';

class ChatConversationScreen extends StatefulWidget {
  final String threadId;

  const ChatConversationScreen({
    super.key,
    required this.threadId,
  });

  @override
  State<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _markRead();
      _scrollToBottom();
    });
  }

  void _markRead() {
    final role = context.read<UserProfileProvider>().currentRole;
    context.read<ChatProvider>().markThreadAsRead(widget.threadId, role);
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSend([String? presetText]) {
    final text = presetText ?? _textController.text.trim();
    if (text.isEmpty) return;

    final userProfile = context.read<UserProfileProvider>();
    final role = userProfile.currentRole;
    final name = userProfile.profile.name.isNotEmpty
        ? userProfile.profile.name
        : (role == 'buyer' ? 'Aarav Mehta' : 'Om Gaikwad');

    final chatProvider = context.read<ChatProvider>();
    final thread = chatProvider.getThreadById(widget.threadId);

    chatProvider.sendMessage(
      threadId: widget.threadId,
      senderRole: role,
      senderName: name,
      text: text,
      productTitle: thread?.activeProductTitle,
      productPrice: thread?.activeProductPrice,
    );

    if (presetText == null) {
      _textController.clear();
    }

    Future.delayed(const Duration(milliseconds: 150), _scrollToBottom);
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final userProfile = context.watch<UserProfileProvider>();
    final role = userProfile.currentRole;
    final thread = chatProvider.getThreadById(widget.threadId);

    if (thread == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chat')),
        body: const Center(child: Text('Conversation not found')),
      );
    }

    final isCounterpartArtisan = role == 'buyer';
    final counterpartName = isCounterpartArtisan ? thread.artisanName : thread.buyerName;
    final counterpartSubtitle = isCounterpartArtisan ? thread.artisanCraft : thread.buyerOrg;
    final counterpartInitials = counterpartName.isNotEmpty
        ? counterpartName.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase()
        : 'C';

    final quickChips = isCounterpartArtisan
        ? [
            '📦 Need 25 Units Quotation',
            '💰 Wholesale Price / Discount?',
            '🚚 Can you dispatch in 2 weeks?',
            '📄 Please share GST Bill',
            '🌿 Are 100% natural dyes used?',
          ]
        : [
            'होय, नक्कीच उपलब्ध आहे!',
            'आम्ही १५ दिवसांत माल तयार करू शकतो.',
            'अस्सल हातमागाची १००% हमी आहे.',
            'नमुना पीस उद्याच पाठवतो.',
          ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerLowest,
        elevation: 1,
        shadowColor: AppColors.cardShadow,
        titleSpacing: 0,
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: isCounterpartArtisan ? AppColors.primaryFixed : const Color(0xFFE0E7FF),
                  child: Text(
                    counterpartInitials,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isCounterpartArtisan ? AppColors.primary : const Color(0xFF4338CA),
                    ),
                  ),
                ),
                if (thread.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    counterpartName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    counterpartSubtitle,
                    style: const TextStyle(fontSize: 11, color: AppColors.textLight),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_outlined, color: AppColors.primary, size: 22),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Calling $counterpartName directly...')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
            onPressed: () {
              _showOptionsSheet(context, counterpartName);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ─── Pinned Active Product Reference (if any) ───
            if (thread.activeProductTitle != null && thread.activeProductTitle!.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  border: const Border(bottom: BorderSide(color: AppColors.outlineVariant)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.inventory_2_outlined, color: AppColors.primary, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'DIRECT SOURCING INQUIRY • थेट कारागीर संवाद',
                            style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                          Text(
                            '${thread.activeProductTitle} • ${thread.activeProductPrice ?? ""}',
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.textPrimary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        '0% Broker Fee',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                      ),
                    ),
                  ],
                ),
              ),

            // ─── Messages List ─────────────────────────────
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                itemCount: thread.messages.length,
                itemBuilder: (context, index) {
                  final message = thread.messages[index];
                  final isMe = message.senderRole == role;
                  return _buildMessageBubble(context, message, isMe);
                },
              ),
            ),

            // ─── Quick Suggestion Chips ────────────────────
            Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: quickChips.length,
                separatorBuilder: (_, i) => const SizedBox(width: 8),
                itemBuilder: (context, idx) {
                  final chipText = quickChips[idx];
                  return ActionChip(
                    label: Text(
                      chipText,
                      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    ),
                    backgroundColor: AppColors.surfaceContainerLowest,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: AppColors.outlineVariant),
                    ),
                    onPressed: () => _handleSend(chipText),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),

            // ─── Input Bar ─────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                border: const Border(top: BorderSide(color: AppColors.outlineVariant)),
                boxShadow: const [
                  BoxShadow(color: AppColors.cardShadow, blurRadius: 4, offset: Offset(0, -1)),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file_rounded, color: AppColors.textLight, size: 22),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Attach purchase order / spec sheet')),
                      );
                    },
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _textController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: role == 'buyer'
                              ? 'Message artisan (e.g. bulk price, sample)...'
                              : 'खरेदीदाराला संदेश लिहा (दर, डिलिव्हरी)...',
                          hintStyle: const TextStyle(fontSize: 13, color: AppColors.textLight),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 11),
                        ),
                        onSubmitted: (_) => _handleSend(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    icon: const Icon(Icons.mic_none_rounded, color: AppColors.textLight, size: 22),
                    onPressed: () {
                      _handleSend('🎙️ [Voice Inquiry]: Can you confirm bulk order timeline of 25 pieces?');
                    },
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white, size: 19),
                      onPressed: () => _handleSend(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, ChatMessage msg, bool isMe) {
    final timeStr = '${msg.timestamp.hour.toString().padLeft(2, '0')}:${msg.timestamp.minute.toString().padLeft(2, '0')}';

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isMe ? 18 : 3),
            bottomRight: Radius.circular(isMe ? 3 : 18),
          ),
          border: isMe ? null : Border.all(color: AppColors.outlineVariant),
          boxShadow: const [
            BoxShadow(color: AppColors.cardShadow, blurRadius: 4, offset: Offset(0, 1.5)),
          ],
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Sender name (small label on receiver side)
            if (!isMe)
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  msg.senderName,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: msg.senderRole == 'artisan' ? AppColors.primary : const Color(0xFF4338CA),
                  ),
                ),
              ),

            // Message Body Text
            Text(
              msg.text,
              style: TextStyle(
                color: isMe ? Colors.white : AppColors.textPrimary,
                fontSize: 14,
                height: 1.35,
              ),
            ),

            const SizedBox(height: 4),

            // Time & Read Status
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeStr,
                  style: TextStyle(
                    fontSize: 10,
                    color: isMe ? Colors.white70 : AppColors.textLight,
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.done_all, size: 14, color: Colors.white70),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showOptionsSheet(BuildContext context, String counterpart) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.receipt_long, color: AppColors.primary),
              title: const Text('Generate Formal Purchase Agreement'),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Formal ShilpSetu Direct Procurement Agreement drafted.')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.verified_user_outlined, color: Color(0xFF10B981)),
              title: const Text('View Quality Inspection Guarantee'),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('100% Escrow & Physical Sample Verification Active.')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Close'),
              onTap: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }
}
