class Chat {
  final String id;
  final String name;
  final List<ChatMessage> messages;

  Chat({
    required this.id,
    required this.name,
    required this.messages,
  });

  String get lastMessage => messages.isNotEmpty ? messages.last.text : 'No messages yet';
}

class ChatMessage {
  final String text;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.timestamp,
  });
}
