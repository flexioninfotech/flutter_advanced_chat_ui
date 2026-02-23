import 'package:flutter/material.dart';

import '../controllers/conversation_list_controller.dart';
import '../models/conversation.dart';
import '../theme/chat_theme.dart';
import 'conversation_tile.dart';

/// A scrollable list of conversations with search and long-press menu.
///
/// Use with [ConversationListController]. Supports [header], [footer],
/// custom [tileBuilder], and [trailingBuilder] for badges.
class ConversationList extends StatefulWidget {
  /// Creates a conversation list with [controller] and optional customization.
  const ConversationList({
    super.key,
    required this.controller,
    this.theme,
    this.appBarTitle = 'Messages',
    this.searchHint = 'Search conversations',
    this.header,
    this.footer,
    this.onConversationTap,
    this.onDelete,
    this.onPinChanged,
    this.onMuteChanged,
    this.tileBuilder,
    this.trailingBuilder,
  });

  /// The state controller for the list.
  final ConversationListController controller;

  /// Optional theme; defaults to [ChatTheme.fromContext].
  final ChatTheme? theme;

  /// App bar title.
  final String appBarTitle;

  /// Search field hint text.
  final String searchHint;

  /// Optional widget above the list.
  final Widget? header;

  /// Optional widget below the list.
  final Widget? footer;

  /// Called when a conversation is tapped.
  final void Function(Conversation)? onConversationTap;

  /// Called when delete is chosen from the menu.
  final void Function(Conversation)? onDelete;

  /// Called when pin state changes.
  final void Function(Conversation, bool pinned)? onPinChanged;

  /// Called when mute state changes.
  final void Function(Conversation, bool muted)? onMuteChanged;

  /// Custom tile builder; if null, uses default [ConversationTile].
  final Widget Function(BuildContext, Conversation)? tileBuilder;

  /// Trailing widget (e.g., unread badge) for each tile.
  final Widget Function(Conversation)? trailingBuilder;

  @override
  State<ConversationList> createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  late final TextEditingController _searchController;
  late ChatTheme _theme;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _theme = widget.theme ?? ChatTheme.fromContext(context);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onControllerChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.background,
      appBar: AppBar(
        title: Text(
          widget.appBarTitle,
          style: TextStyle(
            color: _theme.onBackground,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: _theme.background,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          if (widget.header != null) widget.header!,
          Expanded(
            child: ListView.builder(
              itemCount: widget.controller.items.length,
              itemBuilder: (context, index) {
                final conv = widget.controller.items[index];
                if (widget.tileBuilder != null) {
                  return widget.tileBuilder!(context, conv);
                }
                return ConversationTile(
                  conversation: conv,
                  theme: _theme,
                  onTap: () => widget.onConversationTap?.call(conv),
                  onLongPress: () => _showContextMenu(context, conv),
                  trailing: widget.trailingBuilder?.call(conv),
                );
              },
            ),
          ),
          if (widget.footer != null) widget.footer!,
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: TextField(
        controller: _searchController,
        onChanged: widget.controller.applySearch,
        decoration: InputDecoration(
          hintText: widget.searchHint,
          hintStyle: TextStyle(color: _theme.onSurface?.withValues(alpha: 0.5)),
          prefixIcon: Icon(
            Icons.search,
            color: _theme.onSurface?.withValues(alpha: 0.6),
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: _theme.onSurface),
                  onPressed: () {
                    _searchController.clear();
                    widget.controller.clearSearch();
                  },
                )
              : null,
          filled: true,
          fillColor:
              _theme.surface?.withValues(alpha: 0.5) ?? Colors.grey.shade200,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context, Conversation conv) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _theme.surface,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                conv.settings.isPinned
                    ? Icons.push_pin
                    : Icons.push_pin_outlined,
                color: _theme.primary,
              ),
              title: Text(conv.settings.isPinned ? 'Unpin' : 'Pin'),
              onTap: () {
                Navigator.pop(ctx);
                final next = !conv.settings.isPinned;
                widget.controller.setPin(conv.id, next);
                widget.onPinChanged?.call(conv, next);
              },
            ),
            ListTile(
              leading: Icon(
                conv.settings.isMuted
                    ? Icons.notifications
                    : Icons.notifications_off_outlined,
                color: _theme.primary,
              ),
              title: Text(conv.settings.isMuted ? 'Unmute' : 'Mute'),
              onTap: () {
                Navigator.pop(ctx);
                final next = !conv.settings.isMuted;
                widget.controller.setMute(conv.id, next);
                widget.onMuteChanged?.call(conv, next);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_outline, color: _theme.error),
              title: Text('Delete', style: TextStyle(color: _theme.error)),
              onTap: () {
                Navigator.pop(ctx);
                widget.controller.removeConversation(conv.id);
                widget.onDelete?.call(conv);
              },
            ),
          ],
        ),
      ),
    );
  }
}
