import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_app/models/response/messaging/chatBotMess_res.dart';
import 'package:job_app/models/response/messaging/messaging_res.dart';
import 'package:job_app/services/helpers/chat_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../models/request/messaging/send_message.dart';
import '../models/response/chat/get_chat.dart';
import '../services/helpers/messaging_helper.dart';

class ChatNotifier extends ChangeNotifier {
  late Future<List<GetChats>> chats;
  String? userId;
  List<String> _online = [];
  bool _typing = false;

  List<ReceivedMessage> messages = [];
  int _page = 1;
  bool isLoading = false;
  bool hasMore = true;
  IO.Socket? socket;

  final List<ChatBotMessages> _chatBotMessages = [
    ChatBotMessages(
        msg: 'Hello. How can I help you?', msgType: MessageType.bot),
  ];
  final chatBotScrollController = ScrollController();

  void _scrollDown() {
    chatBotScrollController.animateTo(
      chatBotScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> askQuestion(String question) async {
    if (question.isNotEmpty) {
      _chatBotMessages
          .add(ChatBotMessages(msg: question, msgType: MessageType.user));
      _chatBotMessages.add(ChatBotMessages(msg: '', msgType: MessageType.bot));
      notifyListeners();
      await Future.delayed(Duration(milliseconds: 100));
      _scrollDown();

      final answer = await ChatHelper.getAnswerWithGemini(question);
      _chatBotMessages.removeLast();
      _chatBotMessages
          .add(ChatBotMessages(msg: answer, msgType: MessageType.bot));
      notifyListeners();
      await Future.delayed(Duration(milliseconds: 100));
      _scrollDown();
    }
  }

  List<ChatBotMessages> get chatBotMessages => _chatBotMessages;

  void connect(String id) {
    socket = IO.io("http://10.0.2.2:3000", <String, dynamic>{
      "transports": ['websocket'],
      "autoConnect": false,
    });
    socket!.emit("setup", userId);
    socket!.connect();
    socket!.onConnect((_) {
      // print("Connect to front end");
      socket!.on('online-users', (userId) {
        if (!_online.contains(userId)) {
          _online.add(userId);
        }
        notifyListeners();
      });

      socket!.on('typing', (status) {
        typingStatus = true;
      });

      socket!.on('stop typing', (status) {
        typingStatus = false;
      });

      socket!.on('message received', (newMessageReceived) {
        // sendStopTypingEvent(id);

        ReceivedMessage receivedMessage =
            ReceivedMessage.fromJson(newMessageReceived);

        if (receivedMessage.sender.id != userId) {
          messages.insert(0, receivedMessage);
          notifyListeners();
        }
      });
    });
  }

  void sendMessage(String content, String chatId, String receiver) {
    SendMessage model =
        SendMessage(content: content, chatId: chatId, receiver: receiver);

    MessagingHelper.sendMessage(model).then((response) {
      var emission = response[2];
      socket!.emit('new message', emission);
      sendStopTypingEvent(chatId);
      messages.insert(0, response[1]);
      notifyListeners();
    });
  }

  void sendTypingEvent(String chatId) {
    socket!.emit('typing', chatId);
  }

  void sendStopTypingEvent(String chatId) {
    socket!.emit('stop typing', chatId);
  }

  void joinChat(String id) {
    socket!.emit('join chat', id);
  }

  Future<void> fetchMessages(String id) async {
    if (isLoading || !hasMore) return;

    isLoading = true;
    notifyListeners();

    try {
      List<ReceivedMessage> newMessages =
          await MessagingHelper.getMessages(id, _page);
      if (newMessages.isEmpty) {
        hasMore = false;
      } else {
        messages.addAll(newMessages);
        _page++;
      }
    } catch (e) {
      print("Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  void clearMessages() {
    messages.clear();
    hasMore = true;
    _page = 1;
    notifyListeners();
  }

  bool get typing => _typing;
  set typingStatus(bool newState) {
    _typing = newState;
    notifyListeners();
  }

  List<String> get online => _online;
  set onlineUsers(List<String> newList) {
    _online = newList;
    notifyListeners();
  }

  getChats() {
    chats = ChatHelper.getConversations();
  }

  getPrefs() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    userId = preferences.getString('userId');
  }

  String msgDate(String dateTimeString) {
    DateTime dateTimeUtc = DateTime.parse(dateTimeString);
    DateTime dateTimeVn =
        dateTimeUtc.add(Duration(hours: 7)); // Chuyển sang giờ Việt Nam

    DateTime nowVn = DateTime.now()
        .toUtc()
        .add(Duration(hours: 7)); // Lấy thời gian hiện tại theo giờ VN
    DateTime todayVn = DateTime(nowVn.year, nowVn.month, nowVn.day);
    DateTime yesterdayVn = todayVn.subtract(Duration(days: 1));

    DateTime messageDate =
        DateTime(dateTimeVn.year, dateTimeVn.month, dateTimeVn.day);

    if (messageDate == todayVn) {
      return "Today";
    } else if (messageDate == yesterdayVn) {
      return "Yesterday";
    } else {
      return DateFormat("dd/MM/yyyy").format(dateTimeVn);
    }
  }
}
