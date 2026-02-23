import 'content_type.dart';
import 'delivery_state.dart';
import 'reaction.dart';
import 'reply_context.dart';

/// A chat message.
///
/// Displayed in [MessageThread] via [MessageBubble]. Supports text,
/// image, audio, and custom content types.
class ChatMessage {
  /// Creates a message with the given [id], [body], [senderId], [timestamp],
  /// and optional [contentType], [deliveryState], [replyTo], and [reactions].
  const ChatMessage({
    required this.id,
    required this.body,
    required this.senderId,
    required this.timestamp,
    this.contentType = ContentType.text,
    this.deliveryState = DeliveryState.sent,
    this.replyTo,
    this.reactions = const [],
  });

  /// Unique identifier for this message.
  final String id;

  /// Message content (text, image URL, or custom data).
  final String body;

  /// ID of the sender ([Participant.id]).
  final String senderId;

  /// When the message was sent.
  final DateTime timestamp;

  /// Type of content ([ContentType.text], [ContentType.image], etc.).
  final ContentType contentType;

  /// Delivery status (pending, sent, delivered, read, failed).
  final DeliveryState deliveryState;

  /// Optional reply context when replying to another message.
  final ReplyContext? replyTo;

  /// Emoji reactions on this message.
  final List<MessageReaction> reactions;

  /// Whether this message was sent by the current user (set by controller).
  bool get isFromCurrentUser => false;

  /// Creates a copy with the given fields replaced.
  ChatMessage copyWith({
    String? id,
    String? body,
    String? senderId,
    DateTime? timestamp,
    ContentType? contentType,
    DeliveryState? deliveryState,
    ReplyContext? replyTo,
    List<MessageReaction>? reactions,
  }) =>
      ChatMessage(
        id: id ?? this.id,
        body: body ?? this.body,
        senderId: senderId ?? this.senderId,
        timestamp: timestamp ?? this.timestamp,
        contentType: contentType ?? this.contentType,
        deliveryState: deliveryState ?? this.deliveryState,
        replyTo: replyTo ?? this.replyTo,
        reactions: reactions ?? this.reactions,
      );
}
