/// Settings for a conversation.
///
/// Controls pin and mute state shown in [ConversationList].
class ConversationSettings {
  /// Creates settings with optional [isPinned] and [isMuted].
  const ConversationSettings({
    this.isPinned = false,
    this.isMuted = false,
  });

  /// Whether this conversation is pinned to the top.
  final bool isPinned;

  /// Whether notifications are muted.
  final bool isMuted;

  /// Creates a copy with the given fields replaced.
  ConversationSettings copyWith({
    bool? isPinned,
    bool? isMuted,
  }) =>
      ConversationSettings(
        isPinned: isPinned ?? this.isPinned,
        isMuted: isMuted ?? this.isMuted,
      );
}
