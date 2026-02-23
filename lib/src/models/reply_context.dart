/// Context for a replied message.
///
/// Shown as a preview when composing a reply in [MessageInput].
class ReplyContext {
  /// Creates reply context with [messageId], [preview], and optional
  /// [senderId] and [senderName].
  const ReplyContext({
    required this.messageId,
    required this.preview,
    this.senderId,
    this.senderName,
  });

  /// ID of the message being replied to.
  final String messageId;

  /// Preview text of the original message.
  final String preview;

  /// Optional sender ID.
  final String? senderId;

  /// Optional sender display name.
  final String? senderName;

  /// Creates a copy with the given fields replaced.
  ReplyContext copyWith({
    String? messageId,
    String? preview,
    String? senderId,
    String? senderName,
  }) =>
      ReplyContext(
        messageId: messageId ?? this.messageId,
        preview: preview ?? this.preview,
        senderId: senderId ?? this.senderId,
        senderName: senderName ?? this.senderName,
      );
}
