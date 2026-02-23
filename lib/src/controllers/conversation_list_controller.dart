import 'package:flutter/foundation.dart';
import '../models/conversation.dart';
import '../models/message.dart';

/// Controls the conversation list state.
///
/// Manages the list of [Conversation] items, search filtering, and
/// conversation settings (pin, mute). Use [applySearch] to filter
/// and [addConversation]/[removeConversation] to modify the list.
class ConversationListController extends ChangeNotifier {
  /// Creates a controller with [initial] conversations and optional
  /// [searchFilter] for custom search logic.
  ConversationListController({
    required List<Conversation> initial,
    this.searchFilter,
  }) : _items = List.from(initial) {
    _filtered = List.from(_items);
  }

  final List<Conversation> _items;
  late List<Conversation> _filtered;
  String _query = '';
  final List<Conversation> Function(String query, List<Conversation> items)?
      searchFilter;

  /// The filtered list of conversations (after search).
  List<Conversation> get items => _filtered;

  /// The current search query.
  String get searchQuery => _query;

  /// Applies [query] to filter the conversation list.
  void applySearch(String query) {
    _query = query;
    if (query.isEmpty) {
      _filtered = List.from(_items);
    } else {
      _filtered = searchFilter != null
          ? searchFilter!(query, _items)
          : _items
              .where((c) => c.title.toLowerCase().contains(query.toLowerCase()))
              .toList();
    }
    notifyListeners();
  }

  /// Clears the search and shows all conversations.
  void clearSearch() => applySearch('');

  /// Adds [c] to the top of the list.
  void addConversation(Conversation c) {
    _items.insert(0, c);
    applySearch(_query);
  }

  /// Removes the conversation with the given [id].
  void removeConversation(String id) {
    _items.removeWhere((c) => c.id == id);
    applySearch(_query);
  }

  /// Updates the conversation with [id] using [updater].
  void updateConversation(
      String id, Conversation Function(Conversation) updater) {
    final idx = _items.indexWhere((c) => c.id == id);
    if (idx >= 0) {
      _items[idx] = updater(_items[idx]);
      applySearch(_query);
    }
  }

  /// Sets pin state for the conversation with [id].
  void setPin(String id, bool pinned) {
    updateConversation(
        id, (c) => c.copyWith(settings: c.settings.copyWith(isPinned: pinned)));
  }

  /// Sets mute state for the conversation with [id].
  void setMute(String id, bool muted) {
    updateConversation(
        id, (c) => c.copyWith(settings: c.settings.copyWith(isMuted: muted)));
  }

  /// Updates the last message for the conversation with [id].
  void updateLastMessage(String id, ChatMessage? msg) {
    updateConversation(id, (c) => c.copyWith(lastMessage: msg));
  }

  /// Sets typing indicator for the conversation with [id].
  void setTyping(String id, bool typing) {
    updateConversation(id, (c) => c.copyWith(isTyping: typing));
  }

  /// Sets unread count for the conversation with [id].
  void setUnread(String id, int count) {
    updateConversation(id, (c) => c.copyWith(unreadCount: count));
  }
}
