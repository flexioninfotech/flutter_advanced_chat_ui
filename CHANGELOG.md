# Changelog

## 1.0.0
- **ConversationList** — Scrollable conversation list with search bar
- **ConversationListController** — State management for conversation list (search, pin, mute, add/remove)
- **ConversationTile** — Default conversation row with avatar, title, last message preview
- **MessageThread** — Full chat screen with message list and input
- **MessageThreadController** — State management for messages (append, reactions, typing, reply suggestions)
- **MessageBubble** — Message bubble with reply preview, reactions, delivery status
- **MessageInput** — Text input bar with send button and reply preview
- **ChatTheme** — Theme system with light/dark presets and `fromContext`
- **Models** — `Conversation`, `Participant`, `ChatMessage`, `ConversationSettings`, `ReplyContext`, `MessageReaction`
- **Enums** — `ContentType` (text, image, audio, custom), `DeliveryState` (pending, sent, delivered, read, failed)
- Search with custom filter support
- Long-press menu on conversations (Pin, Mute, Delete)
- Long-press menu on messages (Reply, React with 👍, React with ❤️)
- Typing indicator in conversation list and message thread
- Unread badges via `trailingBuilder`
- Header and footer support for `ConversationList`
- Custom tile builder for `ConversationList`
- Custom message builder for `MessageThread`
- Reply suggestions builder for quick-reply chips
- Example app with conversation list, message thread, dark/light theme
