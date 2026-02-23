/// Type of message content.
///
/// Use [text] for plain text, [image] when [ChatMessage.body] is an image URL,
/// [audio] for voice messages, and [custom] with [MessageThread.customMessageBuilder].
enum ContentType {
  text,
  image,
  audio,
  custom,
}
