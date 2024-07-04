import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';
// import '../../models/chat_message.dart';

class ChatScreen extends StatelessWidget {
  final String chatId;

  ChatScreen({required this.chatId});

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: chatProvider.getMessages(chatId).length,
              itemBuilder: (context, index) {
                final message = chatProvider.getMessages(chatId)[index];
                return ListTile(
                  title: Text(message.text),
                  subtitle: Text(message.timestamp.toString()),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(labelText: 'Type a message'),
                    onChanged: (value) => chatProvider.setNewMessage(value),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    chatProvider.sendMessage(chatId);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
