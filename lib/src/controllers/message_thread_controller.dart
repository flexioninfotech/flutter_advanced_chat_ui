import 'package:flutter/foundation.dart';

import '../models/delivery_state.dart';
import '../models/message.dart';
import '../models/participant.dart';
import '../models/reaction.dart';

/// Controls the message thread state.
///
/// Manages [ChatMessage] list, typing indicator, reply suggestions,
/// and reactions. Use [append] to add messages and [addReaction]
/// for emoji reactions.
class MessageThreadController extends ChangeNotifier {
  /// Creates a controller with [currentUser], [others], and optional
  /// [initial] messages.
  MessageThreadController({
    required this.currentUser,
    required List<Participant> others,
    List<ChatMessage> initial = const [],
  })  : _others = List.of(others),
        _messages = List.of(initial) {
    _messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  final Participant currentUser;
  final List<Participant> _others;
  final List<ChatMessage> _messages;

  /// The list of messages in the thread.
  List<ChatMessage> get messages => List.unmodifiable(_messages);

  /// Other participants in the thread.
  List<Participant> get otherParticipants => List.unmodifiable(_others);

  bool _isTyping = false;

  /// Whether the other user is typing.
  bool get isTyping => _isTyping;
  set isTyping(bool v) {
    if (_isTyping != v) {
      _isTyping = v;
      notifyListeners();
    }
  }

  List<String> _replySuggestions = [];

  /// Quick-reply suggestion chips.
  List<String> get replySuggestions => List.unmodifiable(_replySuggestions);

  /// Sets the reply suggestion chips.
  void setReplySuggestions(List<String> items) {
    _replySuggestions = List.of(items);
    notifyListeners();
  }

  /// Appends [msg] to the thread.
  void append(ChatMessage msg) {
    _messages.add(msg);
    _messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    notifyListeners();
  }

  /// Updates delivery status for the message with [id].
  void updateStatus(String id, DeliveryState status) {
    final idx = _messages.indexWhere((m) => m.id == id);
    if (idx >= 0) {
      _messages[idx] = _messages[idx].copyWith(deliveryState: status);
      notifyListeners();
    }
  }

  /// Toggles [emoji] reaction on the message with [messageId] by [userId].
  void addReaction(String messageId, String emoji, String userId) {
    final idx = _messages.indexWhere((m) => m.id == messageId);
    if (idx < 0) return;
    final msg = _messages[idx];
    final reactions = List<MessageReaction>.from(msg.reactions);
    var found = false;
    for (var i = 0; i < reactions.length; i++) {
      if (reactions[i].emoji == emoji) {
        final ids = List<String>.from(reactions[i].userIds);
        if (ids.contains(userId)) {
          ids.remove(userId);
          if (ids.isEmpty) {
            reactions.removeAt(i);
          } else {
            reactions[i] = reactions[i].copyWith(userIds: ids);
          }
        } else {
          ids.add(userId);
          reactions[i] = reactions[i].copyWith(userIds: ids);
        }
        found = true;
        break;
      }
    }
    if (!found) {
      reactions.add(MessageReaction(emoji: emoji, userIds: [userId]));
    }
    _messages[idx] = msg.copyWith(reactions: reactions);
    notifyListeners();
  }

  /// Whether [msg] was sent by [currentUser].
  bool isFromCurrentUser(ChatMessage msg) => msg.senderId == currentUser.id;
}
