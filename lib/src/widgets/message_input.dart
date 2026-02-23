import 'package:flutter/material.dart';

/// Preview of a message being replied to.
///
/// Shown in [MessageInput] when the user is composing a reply.
class ReplyPreview {
  /// Creates a reply preview with [preview] text and optional [senderName].
  const ReplyPreview({
    required this.preview,
    this.senderName,
  });

  /// Preview text of the message being replied to.
  final String preview;

  /// Display name of the original sender.
  final String? senderName;
}

/// Input bar for composing and sending messages.
///
/// Shows text field, send button, optional reply preview, and action slots.
class MessageInput extends StatefulWidget {
  /// Creates an input bar with [onSend] and optional [replyTo] preview.
  const MessageInput({
    super.key,
    required this.onSend,
    this.hintText = 'Type a message...',
    this.replyTo,
    this.onCancelReply,
    this.leadingActions,
    this.trailingActions,
  });

  /// Called when the user sends a message with the given text.
  final void Function(String text) onSend;

  /// Hint text for the text field.
  final String hintText;

  /// Optional reply preview when replying to a message.
  final ReplyPreview? replyTo;

  /// Called when the user cancels the reply.
  final VoidCallback? onCancelReply;

  /// Optional leading action widgets (e.g., attach button).
  final List<Widget> Function(BuildContext)? leadingActions;

  /// Optional trailing action widgets.
  final List<Widget> Function(BuildContext)? trailingActions;

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    widget.onSend(text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.replyTo != null) _buildReplyBar(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (widget.leadingActions != null)
                  ...widget.leadingActions!(context),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    maxLines: 4,
                    minLines: 1,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade800
                          : Colors.grey.shade200,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: (_) => _submit(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _submit,
                  icon: const Icon(Icons.send_rounded),
                ),
                if (widget.trailingActions != null)
                  ...widget.trailingActions!(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReplyBar() {
    final reply = widget.replyTo!;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (reply.senderName != null)
                  Text(
                    reply.senderName!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                Text(
                  reply.preview,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: widget.onCancelReply,
            iconSize: 20,
          ),
        ],
      ),
    );
  }
}
