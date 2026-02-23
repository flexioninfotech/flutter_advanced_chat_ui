/// Delivery state of a message.
///
/// Represents the lifecycle: [pending] → [sent] → [delivered] → [read],
/// or [failed] if sending fails.
enum DeliveryState {
  pending,
  sent,
  delivered,
  read,
  failed,
}

/// Extension providing convenience getters for [DeliveryState].
extension DeliveryStateX on DeliveryState {
  /// Whether the message is pending (sending).
  bool get isPending => this == DeliveryState.pending;

  /// Whether the message has been sent.
  bool get isSent => this == DeliveryState.sent;

  /// Whether the message has been delivered.
  bool get isDelivered => this == DeliveryState.delivered;

  /// Whether the message has been read.
  bool get isRead => this == DeliveryState.read;

  /// Whether sending failed.
  bool get isFailed => this == DeliveryState.failed;
}
