import 'message.dart';
import 'participant.dart';
import 'conversation_settings.dart';

/// A conversation in the list.
///
/// Displayed as a row in [ConversationList] with avatar, title,
/// last message preview, and optional unread badge.
class Conversation {
  /// Creates a conversation with the given [id], [title], [participants],
  /// and optional metadata.
  const Conversation({
    required this.id,
    required this.title,
    required this.participants,
    this.avatarUrl,
    this.lastMessage,
    this.unreadCount = 0,
    this.isTyping = false,
    this.settings = const ConversationSettings(),
  });

  /// Unique identifier for this conversation.
  final String id;

  /// Display title (e.g., contact name or group name).
  final String title;

  /// Participants in this conversation.
  final List<Participant> participants;

  /// Optional URL for the conversation avatar.
  final String? avatarUrl;

  /// The most recent message for preview display.
  final ChatMessage? lastMessage;

  /// Number of unread messages.
  final int unreadCount;

  /// Whether a participant is currently typing.
  final bool isTyping;

  /// Pin and mute settings.
  final ConversationSettings settings;

  /// Avatar URL from [avatarUrl] or first participant's [Participant.avatarUrl].
  String? get primaryAvatar =>
      avatarUrl ??
      (participants.isNotEmpty ? participants.first.avatarUrl : null);

  /// Creates a copy with the given fields replaced.
  Conversation copyWith({
    String? id,
    String? title,
    List<Participant>? participants,
    String? avatarUrl,
    ChatMessage? lastMessage,
    int? unreadCount,
    bool? isTyping,
    ConversationSettings? settings,
  }) =>
      Conversation(
        id: id ?? this.id,
        title: title ?? this.title,
        participants: participants ?? this.participants,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        lastMessage: lastMessage ?? this.lastMessage,
        unreadCount: unreadCount ?? this.unreadCount,
        isTyping: isTyping ?? this.isTyping,
        settings: settings ?? this.settings,
      );
}
