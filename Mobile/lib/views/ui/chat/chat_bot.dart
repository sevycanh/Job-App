import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:job_app/constants/app_constants.dart';
import 'package:job_app/controllers/chat_provider.dart';
import 'package:job_app/models/response/messaging/chatBotMess_res.dart';
import 'package:job_app/views/ui/chat/widgets/textfield.dart';
import 'package:provider/provider.dart';

import '../../common/app_bar.dart';
import '../../common/app_style.dart';
import '../../common/drawer/drawer_widget.dart';
import '../../common/reusable_text.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //app bar
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: CustomAppBar(
          text: "ChatBot",
          child: Padding(
            padding: EdgeInsets.all(12.0.h),
            child: const DrawerWidget(),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.h),
          child: Column(
            children: [
              Expanded(
                child: Consumer<ChatNotifier>(
                  builder: (BuildContext context, chatNotifier, Widget? child) {
                    return ListView.builder(
                      itemCount: chatNotifier.chatBotMessages.length,
                      controller: chatNotifier.chatBotScrollController,
                      itemBuilder: (context, index) {
                        final data = chatNotifier.chatBotMessages[index];
                        return Padding(
                            padding: EdgeInsets.only(top: 4.h, bottom: 6.h),
                            child: ChatBubble(
                              alignment: data.msgType == MessageType.user
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              backGroundColor: data.msgType == MessageType.user
                                  ? Color(kOrange.value)
                                  : Color(kLightBlue.value),
                              elevation: 0,
                              clipper: ChatBubbleClipper4(
                                  radius: 8,
                                  type: data.msgType == MessageType.user
                                      ? BubbleType.sendBubble
                                      : BubbleType.receiverBubble),
                              child: Container(
                                constraints:
                                    BoxConstraints(maxWidth: width * 0.6),
                                child: data.msg.isEmpty 
                                    ? SizedBox(
                                      width: 50,
                                      child: SpinKitThreeBounce(
                                            color: Colors.white,
                                            size: 20.0,
                                        ),
                                    )
                                    : ReusableText(
                                        softWrap: true,
                                        text: data.msg.trim(),
                                        style: appstyle(14, Color(kLight.value),
                                            FontWeight.normal)),
                              ),
                            ));
                      },
                    );
                  },
                ),
              ),
              Container(
                  padding: EdgeInsets.all(12.h),
                  alignment: Alignment.bottomCenter,
                  child: MessageTextField(
                    messageController: _controller,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        String msg = _controller.text;
                        Provider.of<ChatNotifier>(context, listen: false)
                            .askQuestion(msg);
                        _controller.clear();
                      },
                      child: Icon(
                        Icons.rocket_launch_rounded,
                        size: 24,
                        color: kLightBlue,
                      ),
                    ),
                    onSubmitted: (p0) {
                      String msg = _controller.text;
                      Provider.of<ChatNotifier>(context, listen: false)
                          .askQuestion(msg);
                      _controller.clear();
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
