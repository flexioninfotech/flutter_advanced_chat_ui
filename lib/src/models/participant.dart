/// Represents a chat participant.
///
/// Used in [Conversation.participants] and [MessageThreadController].
class Participant {
  /// Creates a participant with the given [id], [displayName], and optional
  /// [avatarUrl] and [isOnline] status.
  const Participant({
    required this.id,
    required this.displayName,
    this.avatarUrl,
    this.isOnline = false,
  });

  /// Unique identifier for this participant.
  final String id;

  /// Display name shown in the UI.
  final String displayName;

  /// Optional URL for the participant's avatar image.
  final String? avatarUrl;

  /// Whether the participant is currently online.
  final bool isOnline;

  /// Creates a copy with the given fields replaced.
  Participant copyWith({
    String? id,
    String? displayName,
    String? avatarUrl,
    bool? isOnline,
  }) =>
      Participant(
        id: id ?? this.id,
        displayName: displayName ?? this.displayName,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        isOnline: isOnline ?? this.isOnline,
      );
}
