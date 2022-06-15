import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_im_sdk_flutter_demo/main.dart';
import 'package:path_im_sdk_flutter_demo/pages/widgets/message_item.dart';
import 'package:path_im_sdk_flutter_demo/pages/widgets/time_item.dart';

class MessageLogic extends GetxController {
  static MessageLogic? logic() => Tool.capture(Get.find);

  late int conversationType;
  late String conversationID;

  late ScrollController scrollController;
  bool isLoadMore = false;

  late TextEditingController controller;
  late FocusNode focusNode;

  int limit = 0;
  int offset = 100;
  List<MessageModel> list = [];

  @override
  void onInit() {
    super.onInit();
    Map args = Get.arguments;
    conversationType = args["conversationType"];
    conversationID = args["conversationID"];
    scrollController = ScrollController()
      ..addListener(() {
        hideOperate();
        ScrollPosition position = scrollController.position;
        if (position.pixels >= position.maxScrollExtent && !isLoadMore) {
          isLoadMore = true;
          Future.delayed(kThemeChangeDuration, () {
            loadList();
          });
        }
      });
    controller = TextEditingController();
    focusNode = FocusNode();
    loadList();
  }

  @override
  void onClose() {
    controller.dispose();
    focusNode.dispose();
    super.onClose();
  }

  void loadList() {
    PathIMSDK.instance.messageManager
        .getMessageList(
      conversationID: conversationID,
      limit: ++limit,
      offset: offset,
    )
        .then((value) {
      list.addAll(value);
      update(["list"]);
      isLoadMore = false;
    });
  }

  void scrollToTop({bool animateTo = false}) {
    if (animateTo) {
      scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    } else {
      scrollController.jumpTo(0.0);
    }
  }

  void hideOperate() {
    if (focusNode.hasFocus) {
      focusNode.unfocus();
    }
  }

  void sendText(String text) {
    PathIMSDK.instance.messageManager.sendText(
      conversationType: conversationType,
      receiveID: conversationID,
      text: text,
    );
  }

  void sendPicture(String pictureUrl) {
    PathIMSDK.instance.messageManager.sendPicture(
      conversationType: conversationType,
      receiveID: conversationID,
      content: PictureContent(pictureUrl: pictureUrl),
    );
  }

  void sendVoice(String voiceUrl, int duration) {
    PathIMSDK.instance.messageManager.sendVoice(
      conversationType: conversationType,
      receiveID: conversationID,
      content: VoiceContent(
        voiceUrl: voiceUrl,
        duration: duration,
      ),
    );
  }

  void sendVideo(String videoUrl, int duration) {
    PathIMSDK.instance.messageManager.sendVideo(
      conversationType: conversationType,
      receiveID: conversationID,
      content: VideoContent(
        videoUrl: videoUrl,
        duration: duration,
      ),
    );
  }

  void sendFile(String fileUrl, String type, int size) {
    PathIMSDK.instance.messageManager.sendFile(
      conversationType: conversationType,
      receiveID: conversationID,
      content: FileContent(
        fileUrl: fileUrl,
        type: type,
        size: size,
      ),
    );
  }

  void pick() async {
    hideOperate();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["jpg", "png", "aac", "mp4"],
    );
    if (result != null) {
      PlatformFile platformFile = result.files.single;
      String? extension = platformFile.extension;
      // File file = File(platformFile.path!);
      if (extension == "jpg" || extension == "png") {
        print("图片");
      } else if (extension == "aac") {
        print("语音");
      } else if (extension == "mp4") {
        print("视频");
      }
    }
  }
}

class MessagePage extends StatelessWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MessageLogic logic = Get.put(MessageLogic());
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.black,
        ),
        title: const Text("名称是什么"),
      ),
      body: _buildList(logic),
      bottomNavigationBar: _buildNavigationBar(logic),
      backgroundColor: const Color(0xFFF9F9F9),
    );
  }

  Widget _buildList(MessageLogic logic) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: logic.hideOperate,
      child: GetBuilder<MessageLogic>(
        id: "list",
        builder: (logic) {
          return ListView.separated(
            controller: logic.scrollController,
            itemBuilder: (context, index) {
              return MessageItem(message: logic.list[index]);
            },
            separatorBuilder: (context, index) {
              MessageModel message = logic.list[index];
              int clientTime = message.clientTime;
              if (index == logic.list.length - 1) {
                return TimeItem(messageTime: clientTime);
              } else {
                MessageModel? lastMessage = logic.list[index + 1];
                if (lastMessage != null) {
                  int lastSentTime = lastMessage.clientTime;
                  if ((lastSentTime - clientTime).abs() > 300000) {
                    return TimeItem(messageTime: clientTime);
                  } else {
                    return const SizedBox(height: 20);
                  }
                } else {
                  return const SizedBox(height: 20);
                }
              }
            },
            itemCount: logic.list.length,
          );
        },
      ),
    );
  }

  Widget _buildNavigationBar(MessageLogic logic) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: getDividerColor,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: getNavigationBarHeight,
                maxHeight: 150,
              ),
              child: GetTextInput(
                logic.controller,
                "点击输入",
                focusNode: logic.focusNode,
                hintSize: 16,
                textSize: 16,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 10,
                ),
                autoFocus: true,
                maxLines: null,
                textInputAction: TextInputAction.send,
                onComplete: () {
                  String value = logic.controller.text;
                  if (value.isNotEmpty) {
                    logic.sendText(value);
                    logic.controller.clear();
                  }
                },
                onTap: () {
                  logic.scrollToTop();
                },
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: logic.pick,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
