import 'package:flutter/material.dart';

import '../models/content_type.dart';
import '../models/conversation.dart';
import '../theme/chat_theme.dart';

/// A single conversation row in the list.
///
/// Shows avatar, title, last message preview, and optional pin/mute icons.
class ConversationTile extends StatelessWidget {
  /// Creates a tile for [conversation] with [theme] and optional callbacks.
  const ConversationTile({
    super.key,
    required this.conversation,
    required this.theme,
    this.onTap,
    this.onLongPress,
    this.leading,
    this.trailing,
    this.subtitle,
  });

  /// The conversation to display.
  final Conversation conversation;

  /// Theme for colors.
  final ChatTheme theme;

  /// Called when the tile is tapped.
  final VoidCallback? onTap;

  /// Called when the tile is long-pressed.
  final VoidCallback? onLongPress;

  /// Custom leading widget (e.g., avatar); defaults to avatar from conversation.
  final Widget? leading;

  /// Trailing widget (e.g., unread badge).
  final Widget? trailing;

  /// Custom subtitle; defaults to last message preview or "Typing...".
  final Widget? subtitle;

  @override
  Widget build(BuildContext context) {
    final hasUnread = conversation.unreadCount > 0;
    final textColor = hasUnread
        ? (theme.onBackground ?? Colors.black87)
        : (theme.onSurface?.withValues(alpha: 0.7) ?? Colors.grey);

    return Material(
      color: theme.background ?? Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAvatar(),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            conversation.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  hasUnread ? FontWeight.w600 : FontWeight.w500,
                              color: theme.onBackground ?? Colors.black87,
                            ),
                          ),
                        ),
                        if (conversation.settings.isPinned)
                          Icon(
                            Icons.push_pin,
                            size: 14,
                            color: theme.onSurface?.withValues(alpha: 0.6),
                          ),
                        if (conversation.settings.isMuted)
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Icon(
                              Icons.notifications_off_outlined,
                              size: 14,
                              color: theme.onSurface?.withValues(alpha: 0.6),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    subtitle ?? _buildDefaultSubtitle(textColor),
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return leading ??
        CircleAvatar(
          radius: 28,
          backgroundColor: theme.surface ?? Colors.grey.shade300,
          backgroundImage: conversation.primaryAvatar != null
              ? NetworkImage(conversation.primaryAvatar!)
              : null,
          child: conversation.primaryAvatar == null
              ? Text(
                  conversation.title.isNotEmpty
                      ? conversation.title[0].toUpperCase()
                      : '?',
                  style: TextStyle(
                    color: theme.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : null,
        );
  }

  Widget _buildDefaultSubtitle(Color textColor) {
    if (conversation.isTyping) {
      return Text(
        'Typing...',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 14,
          fontStyle: FontStyle.italic,
          color: textColor,
        ),
      );
    }

    final msg = conversation.lastMessage;
    if (msg == null) return const SizedBox.shrink();

    String preview;
    switch (msg.contentType) {
      case ContentType.image:
        preview = 'Photo';
        break;
      case ContentType.audio:
        preview = 'Audio';
        break;
      case ContentType.text:
      case ContentType.custom:
        preview = msg.body;
    }

    return Row(
      children: [
        Expanded(
          child: Text(
            preview,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14, color: textColor),
          ),
        ),
        Text(
          _formatTime(msg.timestamp),
          style: TextStyle(fontSize: 12, color: textColor),
        ),
      ],
    );
  }

  String _formatTime(DateTime t) {
    final now = DateTime.now();
    final diff = now.difference(t);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${t.month}/${t.day}';
  }
}
