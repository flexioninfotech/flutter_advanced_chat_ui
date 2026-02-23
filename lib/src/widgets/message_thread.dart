import 'package:flutter/material.dart';

import '../controllers/message_thread_controller.dart';
import '../models/message.dart';
import '../models/reply_context.dart';
import '../theme/chat_theme.dart';
import 'message_bubble.dart';
import 'message_input.dart';

/// Full message thread UI with list and input.
///
/// Use with [MessageThreadController]. Displays messages, typing
/// indicator, reply suggestions, and [MessageInput] for composing.
class MessageThread extends StatefulWidget {
  /// Creates a message thread with [controller] and [title].
  const MessageThread({
    super.key,
    required this.controller,
    required this.title,
    this.subtitle,
    this.avatarUrl,
    this.theme,
    this.appBarActions,
    this.onBack,
    this.customMessageBuilder,
    this.replySuggestionsBuilder,
  });

  /// The state controller for the thread.
  final MessageThreadController controller;

  /// Chat title (e.g., contact name).
  final String title;

  /// Optional subtitle (e.g., @username).
  final String? subtitle;

  /// Optional avatar image URL.
  final String? avatarUrl;

  /// Optional theme; defaults to [ChatTheme.fromContext].
  final ChatTheme? theme;

  /// Optional app bar actions (e.g., call, video).
  final List<Widget>? appBarActions;

  /// Back button callback; defaults to [Navigator.pop].
  final VoidCallback? onBack;

  /// Custom builder for [ContentType.custom] messages.
  final Widget Function(ChatMessage)? customMessageBuilder;

  /// Builder for reply suggestion chips.
  final Widget Function(List<String> suggestions)? replySuggestionsBuilder;

  @override
  State<MessageThread> createState() => _MessageThreadState();
}

class _MessageThreadState extends State<MessageThread> {
  final _scrollController = ScrollController();
  ReplyContext? _replyingTo;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _scrollController.dispose();
    super.dispose();
  }

  void _onControllerChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ?? ChatTheme.fromContext(context);

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: widget.onBack ?? () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: theme.surface,
              backgroundImage: widget.avatarUrl != null
                  ? NetworkImage(widget.avatarUrl!)
                  : null,
              child: widget.avatarUrl == null
                  ? Text(
                      widget.title.isNotEmpty
                          ? widget.title[0].toUpperCase()
                          : '?',
                      style: TextStyle(color: theme.onSurface),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: theme.onBackground,
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                  ),
                  if (widget.subtitle != null)
                    Text(
                      widget.subtitle!,
                      style: TextStyle(
                        color: theme.onSurface?.withValues(alpha: 0.7),
                        fontSize: 13,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: theme.background,
        elevation: 0,
        actions: widget.appBarActions ?? [],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true,
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: widget.controller.messages.length +
                  (widget.controller.isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (widget.controller.isTyping && index == 0) {
                  return _buildTypingIndicator(theme);
                }
                final msgIndex = widget.controller.isTyping ? index - 1 : index;
                final msg = widget.controller
                    .messages[widget.controller.messages.length - 1 - msgIndex];

                return MessageBubble(
                  message: msg,
                  isOutgoing: widget.controller.isFromCurrentUser(msg),
                  theme: theme,
                  onLongPress: _showMessageMenu,
                  customBuilder: widget.customMessageBuilder,
                );
              },
            ),
          ),
          if (widget.controller.replySuggestions.isNotEmpty &&
              widget.replySuggestionsBuilder != null)
            widget.replySuggestionsBuilder!(widget.controller.replySuggestions),
          MessageInput(
            onSend: _onSend,
            replyTo: _replyingTo != null
                ? ReplyPreview(
                    preview: _replyingTo!.preview,
                    senderName: _replyingTo!.senderName,
                  )
                : null,
            onCancelReply: () => setState(() => _replyingTo = null),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(ChatTheme theme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: theme.bubbleIncoming ?? Colors.grey.shade200,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _dot(),
              const SizedBox(width: 4),
              _dot(),
              const SizedBox(width: 4),
              _dot(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dot() => Container(
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
          color: Colors.grey,
          shape: BoxShape.circle,
        ),
      );

  void _onSend(String text) {
    final reply = _replyingTo;
    setState(() => _replyingTo = null);

    widget.controller.append(
      ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        body: text,
        senderId: widget.controller.currentUser.id,
        timestamp: DateTime.now(),
        replyTo: reply,
      ),
    );
  }

  void _showMessageMenu(ChatMessage msg) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.reply),
              title: const Text('Reply'),
              onTap: () {
                Navigator.pop(ctx);
                String? senderName;
                for (final p in widget.controller.otherParticipants) {
                  if (p.id == msg.senderId) {
                    senderName = p.displayName;
                    break;
                  }
                }
                setState(() {
                  _replyingTo = ReplyContext(
                    messageId: msg.id,
                    preview: msg.body,
                    senderId: msg.senderId,
                    senderName: senderName,
                  );
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.thumb_up_alt_outlined),
              title: const Text('React with 👍'),
              onTap: () {
                Navigator.pop(ctx);
                widget.controller.addReaction(
                  msg.id,
                  '👍',
                  widget.controller.currentUser.id,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.thumb_up_alt_outlined),
              title: const Text('React with ❤️'),
              onTap: () {
                Navigator.pop(ctx);
                widget.controller.addReaction(
                  msg.id,
                  '❤️',
                  widget.controller.currentUser.id,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
