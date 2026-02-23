import 'package:flutter/material.dart';

import '../models/content_type.dart';
import '../models/delivery_state.dart';
import '../models/message.dart';
import '../models/reply_context.dart';
import '../theme/chat_theme.dart';

/// A single message bubble.
///
/// Displays text, image, or audio content with reply preview,
/// reactions, and delivery status.
class MessageBubble extends StatelessWidget {
  /// Creates a bubble for [message] with [theme].
  const MessageBubble({
    super.key,
    required this.message,
    required this.isOutgoing,
    required this.theme,
    this.onLongPress,
    this.onReplyTap,
    this.customBuilder,
  });

  /// The message to display.
  final ChatMessage message;

  /// Whether this is an outgoing (sent) message.
  final bool isOutgoing;

  /// Theme for colors.
  final ChatTheme theme;

  /// Called when the bubble is long-pressed (Reply, React menu).
  final void Function(ChatMessage)? onLongPress;

  /// Called when the reply preview is tapped.
  final void Function(ReplyContext)? onReplyTap;

  /// Custom builder for [ContentType.custom] messages.
  final Widget Function(ChatMessage)? customBuilder;

  @override
  Widget build(BuildContext context) {
    if (customBuilder != null) {
      final custom = customBuilder!(message);
      if (custom != const SizedBox.shrink()) return custom;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Align(
        alignment: isOutgoing ? Alignment.centerRight : Alignment.centerLeft,
        child: GestureDetector(
          onLongPress: () => onLongPress?.call(message),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isOutgoing
                  ? (theme.bubbleOutgoing ?? theme.primary)
                  : (theme.bubbleIncoming ?? Colors.grey.shade200),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: Radius.circular(isOutgoing ? 18 : 4),
                bottomRight: Radius.circular(isOutgoing ? 4 : 18),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (message.replyTo != null) _buildReply(context),
                _buildContent(context),
                if (message.reactions.isNotEmpty) _buildReactions(context),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isOutgoing) _buildStatusIcon(),
                    const SizedBox(width: 4),
                    Text(
                      _formatTime(message.timestamp),
                      style: TextStyle(
                        fontSize: 11,
                        color: (isOutgoing
                                ? theme.bubbleTextOutgoing
                                : theme.bubbleTextIncoming)
                            ?.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReply(BuildContext context) {
    final reply = message.replyTo!;
    return GestureDetector(
      onTap: () => onReplyTap?.call(reply),
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: (isOutgoing ? Colors.white : Colors.black)
              .withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border(
            left: BorderSide(
              color: theme.primary ?? Colors.blue,
              width: 3,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (reply.senderName != null)
              Text(
                reply.senderName!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: theme.primary,
                ),
              ),
            Text(
              reply.preview,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                color: (isOutgoing
                        ? theme.bubbleTextOutgoing
                        : theme.bubbleTextIncoming)
                    ?.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final textColor = isOutgoing
        ? (theme.bubbleTextOutgoing ?? Colors.white)
        : (theme.bubbleTextIncoming ?? Colors.black87);

    switch (message.contentType) {
      case ContentType.image:
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            message.body,
            width: 200,
            fit: BoxFit.cover,
            errorBuilder: (_, e, st) =>
                Icon(Icons.broken_image, color: textColor),
          ),
        );
      case ContentType.audio:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.mic, color: textColor, size: 20),
            const SizedBox(width: 8),
            Text('Voice message',
                style: TextStyle(color: textColor, fontSize: 14)),
          ],
        );
      case ContentType.text:
      case ContentType.custom:
        return Text(
          message.body,
          style: TextStyle(color: textColor, fontSize: 16),
        );
    }
  }

  Widget _buildReactions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Wrap(
        spacing: 4,
        runSpacing: 2,
        children: message.reactions
            .map((r) => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: (isOutgoing ? Colors.white : Colors.black)
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(r.emoji, style: const TextStyle(fontSize: 14)),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildStatusIcon() {
    final color =
        (theme.bubbleTextOutgoing ?? Colors.white).withValues(alpha: 0.9);
    IconData icon;
    switch (message.deliveryState) {
      case DeliveryState.pending:
        icon = Icons.schedule;
        break;
      case DeliveryState.sent:
        icon = Icons.check;
        break;
      case DeliveryState.delivered:
        icon = Icons.done_all;
        break;
      case DeliveryState.read:
        icon = Icons.done_all;
        break;
      case DeliveryState.failed:
        return Icon(Icons.error_outline, size: 14, color: theme.error);
    }
    return Icon(icon, size: 14, color: color);
  }

  String _formatTime(DateTime t) {
    final hour = t.hour > 12 ? t.hour - 12 : (t.hour == 0 ? 12 : t.hour);
    final ampm = t.hour >= 12 ? 'PM' : 'AM';
    return '$hour:${t.minute.toString().padLeft(2, '0')} $ampm';
  }
}
