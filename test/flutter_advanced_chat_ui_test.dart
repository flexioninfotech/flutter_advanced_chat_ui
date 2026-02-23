import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_advanced_chat_ui/flutter_advanced_chat_ui.dart';

void main() {
  test('ConversationListController applies search filter', () {
    final controller = ConversationListController(
      initial: [
        Conversation(
          id: '1',
          title: 'Alice',
          participants: [const Participant(id: 'a', displayName: 'Alice')],
        ),
        Conversation(
          id: '2',
          title: 'Bob',
          participants: [const Participant(id: 'b', displayName: 'Bob')],
        ),
      ],
    );

    expect(controller.items.length, 2);
    controller.applySearch('alice');
    expect(controller.items.length, 1);
    expect(controller.items.first.title, 'Alice');
    controller.clearSearch();
    expect(controller.items.length, 2);
  });
}
