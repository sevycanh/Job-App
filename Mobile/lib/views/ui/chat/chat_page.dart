import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:job_app/controllers/chat_provider.dart';
import 'package:job_app/models/response/messaging/messaging_res.dart';
import 'package:job_app/views/common/app_bar.dart';
import 'package:job_app/views/common/exports.dart';
import 'package:job_app/views/ui/chat/widgets/textfield.dart';
import 'package:job_app/views/ui/mainscreen.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(
      {super.key,
      required this.title,
      required this.id,
      required this.profile,
      required this.user});

  final String title;
  final String id;
  final String profile;
  final List<String> user;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  int offset = 1;

  final messageController = TextEditingController();
  List<ReceivedMessage> messages = [];
  String receiver = '';
  final _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<ChatNotifier>(context, listen: false).connect(widget.id);
    Provider.of<ChatNotifier>(context, listen: false).joinChat(widget.id);
    handleNext();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatNotifier>(context, listen: false).clearMessages();
      Provider.of<ChatNotifier>(context, listen: false)
          .fetchMessages(widget.id);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  void handleNext() {
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        Provider.of<ChatNotifier>(context, listen: false)
            .fetchMessages(widget.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatNotifier>(
      builder: (context, chatNotifier, child) {
        receiver =
            widget.user.firstWhere((element) => element != chatNotifier.userId);
        return Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(50.h),
              child: CustomAppBar(
                  text: !chatNotifier.typing ? widget.title : "typing ...",
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(widget.profile),
                          ),
                          Positioned(
                              right: 3,
                              child: CircleAvatar(
                                radius: 5,
                                backgroundColor:
                                    chatNotifier.online.contains(receiver)
                                        ? Colors.green
                                        : Colors.grey,
                              ))
                        ],
                      ),
                    )
                  ],
                  child: Padding(
                    padding: EdgeInsets.all(12.h),
                    child: GestureDetector(
                      onTap: () {
                        //Get.back();
                        Get.off(() => const MainScreen());
                      },
                      child: const Icon(MaterialCommunityIcons.arrow_left),
                    ),
                  ))),
          body: SafeArea(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.h),
            child: Column(
              children: [
                Expanded(child: Consumer<ChatNotifier>(
                  builder: (context, chatNotifier, child) {
                    if (chatNotifier.messages.isEmpty &&
                        chatNotifier.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.fromLTRB(1.w, 10.h, 1.w, 0),
                      itemCount: chatNotifier.messages.length +
                          (chatNotifier.hasMore ? 1 : 0),
                      controller: _scrollController,
                      reverse: true,
                      itemBuilder: (context, index) {
                        if (index == chatNotifier.messages.length) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final data = chatNotifier.messages[index];
                        final bool isMe = data.sender.id == chatNotifier.userId;
                        String currentDate =
                            chatNotifier.msgDate(data.updatedAt.toString());
                        String nextDate =
                            index == chatNotifier.messages.length - 1
                                ? ''
                                : chatNotifier.msgDate(chatNotifier
                                    .messages[index + 1].updatedAt
                                    .toString());

                        return Padding(
                          padding: EdgeInsets.only(top: 4.h, bottom: 6.h),
                          child: Column(
                            children: [
                              if (currentDate != nextDate)
                                ReusableText(
                                    text: currentDate,
                                    style: appstyle(14, Color(kDark.value),
                                        FontWeight.normal)),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: isMe
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  if (!isMe)
                                    CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(data.sender.profile),
                                    ),
                                  SizedBox(
                                    width: isMe ? 0 : 8.w,
                                  ),
                                  ChatBubble(
                                    alignment: isMe
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    backGroundColor: isMe
                                        ? Color(kOrange.value)
                                        : Color(kLightBlue.value),
                                    elevation: 0,
                                    clipper: ChatBubbleClipper4(
                                        radius: 8,
                                        type: isMe
                                            ? BubbleType.sendBubble
                                            : BubbleType.receiverBubble),
                                    child: Container(
                                      constraints:
                                          BoxConstraints(maxWidth: width * 0.6),
                                      child: ReusableText(
                                          softWrap: true,
                                          text: data.content,
                                          style: appstyle(
                                              14,
                                              Color(kLight.value),
                                              FontWeight.normal)),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                )),
                Container(
                    padding: EdgeInsets.all(12.h),
                    alignment: Alignment.bottomCenter,
                    child: MessageTextField(
                      messageController: messageController,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          String msg = messageController.text;
                          Provider.of<ChatNotifier>(context, listen: false)
                              .sendMessage(msg, widget.id, receiver);
                            messageController.clear();
                        },
                        child: Icon(
                          Icons.send,
                          size: 24,
                          color: Color(kLightBlue.value),
                        ),
                      ),
                      onSubmitted: (p0) {
                        String msg = messageController.text;
                        Provider.of<ChatNotifier>(context, listen: false)
                            .sendMessage(msg, widget.id, receiver);
                          messageController.clear();
                      },
                      onTapOutside: (p0) {
                        Provider.of<ChatNotifier>(context, listen: false)
                            .sendStopTypingEvent(widget.id);
                      },
                      onChanged: (p0) {
                        Provider.of<ChatNotifier>(context, listen: false)
                            .sendTypingEvent(widget.id);
                      },
                      onEditingComplete: () {
                        String msg = messageController.text;
                        Provider.of<ChatNotifier>(context, listen: false)
                            .sendMessage(msg, widget.id, receiver);
                          messageController.clear();
                      },
                    ))
              ],
            ),
          )),
        );
      },
    );
  }
}
