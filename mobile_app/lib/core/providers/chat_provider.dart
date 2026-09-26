// lib/core/providers/chat_provider.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatMessage {
  final String id;
  final String senderRole; // 'buyer' or 'artisan'
  final String senderName;
  final String text;
  final DateTime timestamp;
  final String? productTitle;
  final String? productPrice;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.senderRole,
    required this.senderName,
    required this.text,
    required this.timestamp,
    this.productTitle,
    this.productPrice,
    this.isRead = true,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'senderRole': senderRole,
        'senderName': senderName,
        'text': text,
        'timestamp': timestamp.toIso8601String(),
        'productTitle': productTitle,
        'productPrice': productPrice,
        'isRead': isRead,
      };

  factory ChatMessage.fromMap(Map<String, dynamic> map) => ChatMessage(
        id: map['id'] ?? '',
        senderRole: map['senderRole'] ?? 'buyer',
        senderName: map['senderName'] ?? '',
        text: map['text'] ?? '',
        timestamp: map['timestamp'] != null
            ? DateTime.tryParse(map['timestamp']) ?? DateTime.now()
            : DateTime.now(),
        productTitle: map['productTitle'],
        productPrice: map['productPrice'],
        isRead: map['isRead'] ?? true,
      );
}

class ChatThread {
  final String id;
  final String artisanId;
  final String artisanName;
  final String artisanCraft;
  final String artisanAvatar;
  final String buyerId;
  final String buyerName;
  final String buyerOrg;
  final String? activeProductTitle;
  final String? activeProductPrice;
  final List<ChatMessage> messages;
  final DateTime lastUpdated;
  final bool isOnline;

  ChatThread({
    required this.id,
    required this.artisanId,
    required this.artisanName,
    required this.artisanCraft,
    this.artisanAvatar = '',
    required this.buyerId,
    required this.buyerName,
    required this.buyerOrg,
    this.activeProductTitle,
    this.activeProductPrice,
    required this.messages,
    required this.lastUpdated,
    this.isOnline = true,
  });

  int unreadCountForRole(String role) {
    return messages
        .where((m) => m.senderRole != role && !m.isRead)
        .length;
  }

  ChatMessage? get lastMessage =>
      messages.isNotEmpty ? messages.last : null;

  ChatThread copyWith({
    List<ChatMessage>? messages,
    DateTime? lastUpdated,
    String? activeProductTitle,
    String? activeProductPrice,
  }) {
    return ChatThread(
      id: id,
      artisanId: artisanId,
      artisanName: artisanName,
      artisanCraft: artisanCraft,
      artisanAvatar: artisanAvatar,
      buyerId: buyerId,
      buyerName: buyerName,
      buyerOrg: buyerOrg,
      activeProductTitle: activeProductTitle ?? this.activeProductTitle,
      activeProductPrice: activeProductPrice ?? this.activeProductPrice,
      messages: messages ?? this.messages,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isOnline: isOnline,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'artisanId': artisanId,
        'artisanName': artisanName,
        'artisanCraft': artisanCraft,
        'artisanAvatar': artisanAvatar,
        'buyerId': buyerId,
        'buyerName': buyerName,
        'buyerOrg': buyerOrg,
        'activeProductTitle': activeProductTitle,
        'activeProductPrice': activeProductPrice,
        'messages': messages.map((m) => m.toMap()).toList(),
        'lastUpdated': lastUpdated.toIso8601String(),
        'isOnline': isOnline,
      };

  factory ChatThread.fromMap(Map<String, dynamic> map) => ChatThread(
        id: map['id'] ?? '',
        artisanId: map['artisanId'] ?? '',
        artisanName: map['artisanName'] ?? '',
        artisanCraft: map['artisanCraft'] ?? '',
        artisanAvatar: map['artisanAvatar'] ?? '',
        buyerId: map['buyerId'] ?? '',
        buyerName: map['buyerName'] ?? '',
        buyerOrg: map['buyerOrg'] ?? '',
        activeProductTitle: map['activeProductTitle'],
        activeProductPrice: map['activeProductPrice'],
        messages: (map['messages'] as List? ?? [])
            .map((m) => ChatMessage.fromMap(m as Map<String, dynamic>))
            .toList(),
        lastUpdated: map['lastUpdated'] != null
            ? DateTime.tryParse(map['lastUpdated']) ?? DateTime.now()
            : DateTime.now(),
        isOnline: map['isOnline'] ?? true,
      );
}

class ChatProvider extends ChangeNotifier {
  static const String _prefKey = 'shilpsetu_chat_threads_v1';
  List<ChatThread> _threads = [];
  bool _isLoading = false;

  List<ChatThread> get threads => _threads;
  bool get isLoading => _isLoading;

  int totalUnreadForRole(String role) {
    return _threads.fold(0, (sum, t) => sum + t.unreadCountForRole(role));
  }

  int get totalUnreadCount => totalUnreadForRole('artisan');

  ChatProvider() {
    loadThreads();
  }

  Future<void> loadThreads() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedData = prefs.getStringList(_prefKey);

      if (savedData != null && savedData.isNotEmpty) {
        _threads = savedData
            .map((str) => ChatThread.fromMap(json.decode(str)))
            .toList();
      } else {
        _threads = _createInitialDemoThreads();
        await _persistThreads();
      }
    } catch (e) {
      debugPrint('Error loading chat threads: $e');
      _threads = _createInitialDemoThreads();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  ChatThread? getThreadById(String id) {
    try {
      return _threads.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  ChatThread getOrCreateThread({
    required String artisanName,
    required String artisanCraft,
    required String buyerName,
    required String buyerOrg,
    String? productTitle,
    String? productPrice,
  }) {
    final sanitizedArtisan = artisanName.replaceAll(RegExp(r'\s+'), '_').toLowerCase();
    final threadId = 'thread_$sanitizedArtisan';

    final existingIndex = _threads.indexWhere((t) => t.id == threadId);
    if (existingIndex != -1) {
      if (productTitle != null && productTitle.isNotEmpty) {
        _threads[existingIndex] = _threads[existingIndex].copyWith(
          activeProductTitle: productTitle,
          activeProductPrice: productPrice,
        );
        _persistThreads();
        notifyListeners();
      }
      return _threads[existingIndex];
    }

    final newThread = ChatThread(
      id: threadId,
      artisanId: 'artisan_$sanitizedArtisan',
      artisanName: artisanName,
      artisanCraft: artisanCraft,
      artisanAvatar: artisanName.isNotEmpty ? artisanName[0].toUpperCase() : 'A',
      buyerId: 'buyer_aarav_mehta',
      buyerName: buyerName,
      buyerOrg: buyerOrg,
      activeProductTitle: productTitle,
      activeProductPrice: productPrice,
      messages: [
        ChatMessage(
          id: 'msg_welcome_${DateTime.now().millisecondsSinceEpoch}',
          senderRole: 'artisan',
          senderName: artisanName,
          text: 'नमस्कार! मी $artisanName. मी तुम्हाला आमच्या हस्तकलेबद्दल कशी मदत करू शकतो?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          productTitle: productTitle,
          productPrice: productPrice,
        ),
      ],
      lastUpdated: DateTime.now(),
      isOnline: true,
    );

    _threads.insert(0, newThread);
    _persistThreads();
    notifyListeners();
    return newThread;
  }

  Future<void> sendMessage({
    required String threadId,
    required String senderRole,
    required String senderName,
    required String text,
    String? productTitle,
    String? productPrice,
  }) async {
    final index = _threads.indexWhere((t) => t.id == threadId);
    if (index == -1) return;

    final newMessage = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderRole: senderRole,
      senderName: senderName,
      text: text,
      timestamp: DateTime.now(),
      productTitle: productTitle,
      productPrice: productPrice,
      isRead: false,
    );

    final updatedMessages = List<ChatMessage>.from(_threads[index].messages)..add(newMessage);
    _threads[index] = _threads[index].copyWith(
      messages: updatedMessages,
      lastUpdated: DateTime.now(),
    );

    await _persistThreads();
    notifyListeners();

    // If sent by Buyer, trigger realistic automated reply from artisan after 1.5s
    if (senderRole == 'buyer') {
      _triggerSimulatedArtisanReply(threadId, _threads[index].artisanName, text);
    }
  }

  void _triggerSimulatedArtisanReply(String threadId, String artisanName, String incomingText) {
    Future.delayed(const Duration(milliseconds: 1400), () async {
      final index = _threads.indexWhere((t) => t.id == threadId);
      if (index == -1) return;

      String replyText = 'धन्यवाद आरव जी! तुमची मागणी आम्ही तपासत आहोत. आमची टीम लवकरच कच्चा माल आणि विणकामाचे शेड्युल तयार करेल.';
      final lower = incomingText.toLowerCase();
      if (lower.contains('price') || lower.contains('दर') || lower.contains('quote') || lower.contains('discount')) {
        replyText = 'थेट घाऊक खरेदीसाठी आम्ही सर्वोत्तम दर देऊ. जीएसटी बिलासह थेट कारागीर सवलत उपलब्ध आहे.';
      } else if (lower.contains('delivery') || lower.contains('timeline') || lower.contains('कधी') || lower.contains('dispatch')) {
        replyText = 'आम्ही १५ ते २० दिवसांत संपूर्ण कन्साइनमेंट सुरक्षित पॅकिंगसह डिस्पॅच करू शकतो.';
      } else if (lower.contains('sample') || lower.contains('गुणवत्ता') || lower.contains('quality')) {
        replyText = 'होय, आम्ही १ नमुना पीस थेट कुरिअरने तुमच्या मुंबई गोदामात पाठवू शकतो.';
      }

      final artisanReply = ChatMessage(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        senderRole: 'artisan',
        senderName: artisanName,
        text: replyText,
        timestamp: DateTime.now(),
        isRead: false,
      );

      final updatedMessages = List<ChatMessage>.from(_threads[index].messages)..add(artisanReply);
      _threads[index] = _threads[index].copyWith(
        messages: updatedMessages,
        lastUpdated: DateTime.now(),
      );

      await _persistThreads();
      notifyListeners();
    });
  }

  Future<void> markThreadAsRead(String threadId, String readerRole) async {
    final index = _threads.indexWhere((t) => t.id == threadId);
    if (index == -1) return;

    final updatedMessages = _threads[index].messages.map((m) {
      if (m.senderRole != readerRole && !m.isRead) {
        return ChatMessage(
          id: m.id,
          senderRole: m.senderRole,
          senderName: m.senderName,
          text: m.text,
          timestamp: m.timestamp,
          productTitle: m.productTitle,
          productPrice: m.productPrice,
          isRead: true,
        );
      }
      return m;
    }).toList();

    _threads[index] = _threads[index].copyWith(messages: updatedMessages);
    await _persistThreads();
    notifyListeners();
  }

  Future<void> _persistThreads() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = _threads.map((t) => json.encode(t.toMap())).toList();
      await prefs.setStringList(_prefKey, list);
    } catch (e) {
      debugPrint('Error persisting chat threads: $e');
    }
  }

  List<ChatThread> _createInitialDemoThreads() {
    final now = DateTime.now();

    return [
      ChatThread(
        id: 'thread_om_gaikwad',
        artisanId: 'artisan_om_gaikwad',
        artisanName: 'Om Gaikwad',
        artisanCraft: 'Yeola Paithani Silk Weaving',
        artisanAvatar: 'OG',
        buyerId: 'buyer_aarav_mehta',
        buyerName: 'Aarav Mehta',
        buyerOrg: 'FabIndia Retail & Sourcing Mumbai',
        activeProductTitle: 'Authentic Yeola Paithani Pure Silk Saree',
        activeProductPrice: '₹6,500/piece',
        isOnline: true,
        lastUpdated: now.subtract(const Duration(minutes: 8)),
        messages: [
          ChatMessage(
            id: 'm1',
            senderRole: 'buyer',
            senderName: 'Aarav Mehta',
            text: 'Namaste Om ji! We inspected the peacock zari border swatch. The silk weaving density and pure zari shine are exceptional.',
            timestamp: now.subtract(const Duration(hours: 3)),
            productTitle: 'Authentic Yeola Paithani Pure Silk Saree',
            productPrice: '₹6,500/piece',
          ),
          ChatMessage(
            id: 'm2',
            senderRole: 'artisan',
            senderName: 'Om Gaikwad',
            text: 'नमस्कार आरव जी! खूप खूप धन्यवाद. ही अस्सल हातमागावर विणलेली पैठणी आहे. आम्ही १००% नैसर्गिक मलबेरी रेशीम आणि अस्सल जरी वापरतो.',
            timestamp: now.subtract(const Duration(hours: 2, minutes: 40)),
          ),
          ChatMessage(
            id: 'm3',
            senderRole: 'buyer',
            senderName: 'Aarav Mehta',
            text: 'Can your weaving cluster deliver 25 units for our Mumbai festive showcase within 3 weeks?',
            timestamp: now.subtract(const Duration(hours: 1)),
          ),
          ChatMessage(
            id: 'm4',
            senderRole: 'artisan',
            senderName: 'Om Gaikwad',
            text: 'होय, नक्कीच! आमच्याकडे ६ हातमाग सुरू आहेत. २५ साड्या ३ आठवड्यांत पूर्ण तयार मिळतील. थेट घाऊक दर ₹६,५०० राहील.',
            timestamp: now.subtract(const Duration(minutes: 8)),
          ),
        ],
      ),
      ChatThread(
        id: 'thread_ramesh_baghel',
        artisanId: 'artisan_ramesh_baghel',
        artisanName: 'Ramesh Baghel',
        artisanCraft: 'Bastar Lost-Wax Bell Metal Art',
        artisanAvatar: 'RB',
        buyerId: 'buyer_aarav_mehta',
        buyerName: 'Aarav Mehta',
        buyerOrg: 'FabIndia Retail & Sourcing Mumbai',
        activeProductTitle: 'Bastar Dhokra Bell Metal Tribal Statues',
        activeProductPrice: '₹1,500/piece',
        isOnline: true,
        lastUpdated: now.subtract(const Duration(hours: 4)),
        messages: [
          ChatMessage(
            id: 'mb1',
            senderRole: 'buyer',
            senderName: 'Aarav Mehta',
            text: 'Hello Ramesh ji, regarding the bulk inquiry of 120 bell metal statues, what packaging is used for fragile cargo?',
            timestamp: now.subtract(const Duration(days: 1)),
            productTitle: 'Bastar Dhokra Bell Metal Tribal Statues',
            productPrice: '₹1,500/piece',
          ),
          ChatMessage(
            id: 'mb2',
            senderRole: 'artisan',
            senderName: 'Ramesh Baghel',
            text: 'प्रणाम आरव जी! सभी मूर्तियां 5-लेयर कोरोगेटेड बॉक्स और फोम पैकिंग में जाती हैं। जीरो डैमेज गारंटी के साथ डिस्पैच करेंगे।',
            timestamp: now.subtract(const Duration(hours: 4)),
          ),
        ],
      ),
      ChatThread(
        id: 'thread_govindbhai_prajapati',
        artisanId: 'artisan_govindbhai_prajapati',
        artisanName: 'Govindbhai Prajapati',
        artisanCraft: 'Kutch Terracotta Clay Pottery',
        artisanAvatar: 'GP',
        buyerId: 'buyer_aarav_mehta',
        buyerName: 'Aarav Mehta',
        buyerOrg: 'FabIndia Retail & Sourcing Mumbai',
        activeProductTitle: 'Kutch Hand-Turned Terracotta Glazed Water Jugs',
        activeProductPrice: '₹420/piece',
        isOnline: false,
        lastUpdated: now.subtract(const Duration(days: 1)),
        messages: [
          ChatMessage(
            id: 'mg1',
            senderRole: 'buyer',
            senderName: 'Aarav Mehta',
            text: 'Govindbhai, the previous batch of 200 water jugs sold out completely. We are ready to place a repeat order of 300 pieces.',
            timestamp: now.subtract(const Duration(days: 1, hours: 2)),
            productTitle: 'Kutch Hand-Turned Terracotta Glazed Water Jugs',
            productPrice: '₹420/piece',
          ),
          ChatMessage(
            id: 'mg2',
            senderRole: 'artisan',
            senderName: 'Govindbhai Prajapati',
            text: 'जय श्रीकृष्ण आरव भाई! बहुत आनंद हुआ। अगली भट्टी में 300 नए जग तैयार कर रहे हैं। मंगलवार को डिस्पैच हो जाएंगे।',
            timestamp: now.subtract(const Duration(days: 1)),
          ),
        ],
      ),
    ];
  }
}
