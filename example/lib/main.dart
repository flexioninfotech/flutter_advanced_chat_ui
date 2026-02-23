import 'package:flutter/material.dart';
import 'package:flutter_advanced_chat_ui/flutter_advanced_chat_ui.dart';

void main() => runApp(const DemoApp());

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Advanced Chat UI Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF)),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C74FF),
          brightness: Brightness.dark,
        ),
      ),
      home: const ConversationListScreen(),
    );
  }
}

class ConversationListScreen extends StatefulWidget {
  const ConversationListScreen({super.key});

  @override
  State<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> {
  late final ConversationListController _controller;
  bool _isDark = false;

  @override
  void initState() {
    super.initState();
    _controller = ConversationListController(initial: _demoConversations());
  }

  List<Conversation> _demoConversations() {
    final now = DateTime.now();
    return [
      Conversation(
        id: '1',
        title: 'Alice Johnson',
        participants: [
          const Participant(
            id: 'alice',
            displayName: 'Alice',
            avatarUrl: 'https://i.pravatar.cc/150?img=1',
            isOnline: true,
          ),
        ],
        avatarUrl: 'https://i.pravatar.cc/150?img=1',
        lastMessage: ChatMessage(
          id: 'm1',
          body: 'Hey! Are we still on for tomorrow?',
          senderId: 'alice',
          timestamp: now.subtract(const Duration(minutes: 5)),
          deliveryState: DeliveryState.read,
        ),
        unreadCount: 2,
        isTyping: false,
        settings: const ConversationSettings(isPinned: true),
      ),
      Conversation(
        id: '2',
        title: 'Bob Smith',
        participants: [
          const Participant(
            id: 'bob',
            displayName: 'Bob',
            avatarUrl: 'https://i.pravatar.cc/150?img=2',
          ),
        ],
        avatarUrl: 'https://i.pravatar.cc/150?img=2',
        lastMessage: ChatMessage(
          id: 'm2',
          body: 'Thanks for the update!',
          senderId: 'me',
          timestamp: now.subtract(const Duration(hours: 2)),
          deliveryState: DeliveryState.delivered,
        ),
        settings: const ConversationSettings(isMuted: true),
      ),
      Conversation(
        id: '3',
        title: 'Carol Williams',
        participants: [
          const Participant(
            id: 'carol',
            displayName: 'Carol',
            avatarUrl: 'https://i.pravatar.cc/150?img=3',
            isOnline: true,
          ),
        ],
        avatarUrl: 'https://i.pravatar.cc/150?img=3',
        lastMessage: ChatMessage(
          id: 'm3',
          body: 'See you at the meeting',
          senderId: 'carol',
          timestamp: now.subtract(const Duration(days: 1)),
          deliveryState: DeliveryState.read,
        ),
        isTyping: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDark ? ThemeData.dark() : ThemeData.light(),
      child: ConversationList(
        controller: _controller,
        appBarTitle: 'Messages',
        searchHint: 'Search conversations',
        header: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => setState(() => _isDark = !_isDark),
                child: Text(_isDark ? 'Light' : 'Dark'),
              ),
            ],
          ),
        ),
        onConversationTap: (c) => _openThread(c),
        trailingBuilder: (conv) {
          if (conv.unreadCount > 0) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${conv.unreadCount}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _openThread(Conversation conv) {
    final me = const Participant(
      id: 'me',
      displayName: 'Me',
      avatarUrl: 'https://i.pravatar.cc/150?img=0',
    );
    final others = conv.participants;
    final controller = MessageThreadController(
      currentUser: me,
      others: others,
      initial: [
        ChatMessage(
          id: '1',
          body: 'Hello! How are you?',
          senderId: others.first.id,
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        ChatMessage(
          id: '2',
          body: "I'm doing great, thanks!",
          senderId: 'me',
          timestamp: DateTime.now().subtract(const Duration(minutes: 55)),
        ),
        ChatMessage(
          id: '3',
          body: 'Want to grab coffee sometime?',
          senderId: others.first.id,
          timestamp: DateTime.now().subtract(const Duration(minutes: 50)),
        ),
      ],
    );

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (ctx) => MessageThread(
          controller: controller,
          title: conv.title,
          subtitle: '@${conv.title.toLowerCase().replaceAll(' ', '_')}',
          avatarUrl: conv.avatarUrl,
          appBarActions: [
            IconButton(icon: const Icon(Icons.videocam), onPressed: () {}),
            IconButton(icon: const Icon(Icons.call), onPressed: () {}),
          ],
          replySuggestionsBuilder: (suggestions) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Theme.of(ctx).cardColor,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: suggestions
                    .map(
                      (s) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ActionChip(
                          label: Text(s),
                          onPressed: () {
                            controller.append(
                              ChatMessage(
                                id: DateTime.now().toString(),
                                body: s,
                                senderId: 'me',
                                timestamp: DateTime.now(),
                              ),
                            );
                            controller.setReplySuggestions([]);
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
