import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';
import 'chat_screen.dart';

class StartChatScreen extends StatefulWidget {
  @override
  _StartChatScreenState createState() => _StartChatScreenState();
}

class _StartChatScreenState extends State<StartChatScreen> {
  final _formKey = GlobalKey<FormState>();
  final _chatNameController = TextEditingController();

  void _startChat() {
    if (_formKey.currentState!.validate()) {
      final chatName = _chatNameController.text;

      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      final newChatId = chatProvider.startNewChat(chatName);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(chatId: newChatId),
        ),
      );
    }
  }

  @override
  void dispose() {
    _chatNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start a New Chat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _chatNameController,
                decoration: InputDecoration(
                  labelText: 'Chat Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a chat name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _startChat,
                child: Text('Start Chat'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
