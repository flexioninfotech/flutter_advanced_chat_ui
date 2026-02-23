import 'package:flutter/material.dart';

/// Theme for chat UI components.
///
/// Use [fromContext] to derive from [ThemeData], or [light]/[dark] presets.
/// All color properties are optional and fall back to defaults.
@immutable
class ChatTheme {
  const ChatTheme({
    this.background,
    this.surface,
    this.primary,
    this.onBackground,
    this.onSurface,
    this.onPrimary,
    this.bubbleOutgoing,
    this.bubbleIncoming,
    this.bubbleTextOutgoing,
    this.bubbleTextIncoming,
    this.divider,
    this.error,
  });

  /// Scaffold background color.
  final Color? background;

  /// Card/surface color.
  final Color? surface;

  /// Primary accent color.
  final Color? primary;

  /// Text color on background.
  final Color? onBackground;

  /// Text color on surface.
  final Color? onSurface;

  /// Text color on primary.
  final Color? onPrimary;

  /// Outgoing message bubble color.
  final Color? bubbleOutgoing;

  /// Incoming message bubble color.
  final Color? bubbleIncoming;

  /// Outgoing message text color.
  final Color? bubbleTextOutgoing;

  /// Incoming message text color.
  final Color? bubbleTextIncoming;

  /// Divider color.
  final Color? divider;

  /// Error color.
  final Color? error;

  /// Creates a copy with the given fields replaced.
  ChatTheme copyWith({
    Color? background,
    Color? surface,
    Color? primary,
    Color? onBackground,
    Color? onSurface,
    Color? onPrimary,
    Color? bubbleOutgoing,
    Color? bubbleIncoming,
    Color? bubbleTextOutgoing,
    Color? bubbleTextIncoming,
    Color? divider,
    Color? error,
  }) =>
      ChatTheme(
        background: background ?? this.background,
        surface: surface ?? this.surface,
        primary: primary ?? this.primary,
        onBackground: onBackground ?? this.onBackground,
        onSurface: onSurface ?? this.onSurface,
        onPrimary: onPrimary ?? this.onPrimary,
        bubbleOutgoing: bubbleOutgoing ?? this.bubbleOutgoing,
        bubbleIncoming: bubbleIncoming ?? this.bubbleIncoming,
        bubbleTextOutgoing: bubbleTextOutgoing ?? this.bubbleTextOutgoing,
        bubbleTextIncoming: bubbleTextIncoming ?? this.bubbleTextIncoming,
        divider: divider ?? this.divider,
        error: error ?? this.error,
      );

  /// Derives theme colors from [Theme.of] the given [context].
  static ChatTheme fromContext(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return ChatTheme(
      background: theme.scaffoldBackgroundColor,
      surface: theme.cardColor,
      primary: theme.colorScheme.primary,
      onBackground: theme.colorScheme.onSurface,
      onSurface: theme.colorScheme.onSurface,
      onPrimary: theme.colorScheme.onPrimary,
      bubbleOutgoing: theme.colorScheme.primary,
      bubbleIncoming: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
      bubbleTextOutgoing: theme.colorScheme.onPrimary,
      bubbleTextIncoming: theme.colorScheme.onSurface,
      divider: theme.dividerColor,
      error: theme.colorScheme.error,
    );
  }

  /// Light theme preset.
  static const light = ChatTheme(
    background: Color(0xFFF5F5F5),
    surface: Colors.white,
    primary: Color(0xFF6C63FF),
    onBackground: Color(0xFF1A1A1A),
    onSurface: Color(0xFF1A1A1A),
    onPrimary: Colors.white,
    bubbleOutgoing: Color(0xFF6C63FF),
    bubbleIncoming: Color(0xFFE8E8E8),
    bubbleTextOutgoing: Colors.white,
    bubbleTextIncoming: Color(0xFF1A1A1A),
    divider: Color(0xFFE0E0E0),
    error: Color(0xFFE53935),
  );

  /// Dark theme preset.
  static const dark = ChatTheme(
    background: Color(0xFF121212),
    surface: Color(0xFF1E1E1E),
    primary: Color(0xFF7C74FF),
    onBackground: Color(0xFFE0E0E0),
    onSurface: Color(0xFFE0E0E0),
    onPrimary: Colors.white,
    bubbleOutgoing: Color(0xFF6C63FF),
    bubbleIncoming: Color(0xFF2C2C2C),
    bubbleTextOutgoing: Colors.white,
    bubbleTextIncoming: Color(0xFFE0E0E0),
    divider: Color(0xFF333333),
    error: Color(0xFFEF5350),
  );
}
