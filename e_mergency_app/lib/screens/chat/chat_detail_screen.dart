import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';

class ChatDetailScreen extends StatelessWidget {
  final String chatId;

  ChatDetailScreen({required this.chatId});

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final chat = chatProvider.getChatById(chatId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Chat with: ${chat.name}', style: TextStyle(fontSize: 18)),
            Text('Last message: ${chat.lastMessage}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
