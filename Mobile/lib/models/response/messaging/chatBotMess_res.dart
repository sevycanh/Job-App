class ChatBotMessages {
  final String msg;
  final MessageType msgType;

  ChatBotMessages({required this.msg, required this.msgType});
}

enum MessageType { user, bot }
