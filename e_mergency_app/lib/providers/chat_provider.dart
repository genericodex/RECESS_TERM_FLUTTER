import 'package:flutter/material.dart';
import '../models/chat_message.dart';

class ChatProvider with ChangeNotifier {
  final List<Chat> _chats = [];
  String _newMessage = '';

  List<Chat> get chats => _chats;

  Chat getChatById(String chatId) {
    return _chats.firstWhere((chat) => chat.id == chatId);
  }

  String startNewChat(String chatName) {
    final newChat = Chat(
      id: DateTime.now().toString(),
      name: chatName,
      messages: [],
    );
    _chats.add(newChat);
    notifyListeners();
    return newChat.id;
  }

  List<ChatMessage> getMessages(String chatId) {
    return getChatById(chatId).messages;
  }

  void setNewMessage(String message) {
    _newMessage = message;
  }

  void sendMessage(String chatId) {
    if (_newMessage.isNotEmpty) {
      final chat = getChatById(chatId);
      chat.messages.add(ChatMessage(text: _newMessage, timestamp: DateTime.now()));
      _newMessage = '';
      notifyListeners();
    }
  }
}
