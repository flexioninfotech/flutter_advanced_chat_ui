/// A reaction on a message.
///
/// Groups an emoji (e.g., 👍 or ❤️) with the [userIds] who added it.
class MessageReaction {
  /// Creates a reaction with the given [emoji] and [userIds].
  const MessageReaction({
    required this.emoji,
    required this.userIds,
  });

  /// The emoji character (e.g., '👍', '❤️').
  final String emoji;

  /// IDs of users who added this reaction.
  final List<String> userIds;

  /// Creates a copy with the given fields replaced.
  MessageReaction copyWith({
    String? emoji,
    List<String>? userIds,
  }) =>
      MessageReaction(
        emoji: emoji ?? this.emoji,
        userIds: userIds ?? this.userIds,
      );
}
