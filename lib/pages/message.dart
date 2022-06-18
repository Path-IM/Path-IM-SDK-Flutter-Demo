import 'package:file_picker/file_picker.dart';
import 'package:path_im_sdk_flutter_demo/main.dart';
import 'package:path_im_sdk_flutter_demo/pages/conversation.dart';
import 'package:path_im_sdk_flutter_demo/pages/widgets/message_item.dart';
import 'package:path_im_sdk_flutter_demo/pages/widgets/time_item.dart';

class MessageLogic extends GetxController {
  static MessageLogic? logic() => Tool.capture(Get.find);

  late String conversationID;
  late int conversationType;
  late String receiveID;

  late ScrollController scrollController;
  bool isLoadMore = false;

  late TextEditingController controller;
  late FocusNode focusNode;

  int offset = 0;
  List<MessageModel> list = [];

  @override
  void onInit() {
    super.onInit();
    Map args = Get.arguments;
    conversationID = args["conversationID"];
    conversationType = args["conversationType"];
    receiveID = args["receiveID"];
    scrollController = ScrollController()
      ..addListener(() {
        hideOperate();
        ScrollPosition position = scrollController.position;
        if (position.pixels >= position.maxScrollExtent && !isLoadMore) {
          isLoadMore = true;
          Future.delayed(kThemeChangeDuration, () {
            ++offset;
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
    PathIMSDK.instance.conversationManager
        .markConversationRead(
      conversationID: conversationID,
      conversationType: conversationType,
      receiveID: receiveID,
    )
        .then((value) {
      ConversationLogic.logic()?.loadList();
    });
    super.onClose();
  }

  void loadList() {
    PathIMSDK.instance.messageManager
        .getMessageList(
      conversationID: conversationID,
      limit: 20,
      offset: offset * 20,
    )
        .then((value) {
      list.addAll(value);
      update(["list"]);
      isLoadMore = false;
    });
  }

  void receive(MessageModel message) {
    bool updateList = false;
    if (conversationType == ConversationType.single) {
      if (message.sendID == receiveID) {
        updateList = true;
      }
    } else {
      if (message.receiveID == receiveID) {
        updateList = true;
      }
    }
    if (!updateList) return;
    int index = list.indexWhere((msg) {
      return msg.clientMsgID == message.clientMsgID;
    });
    if (index != -1) {
      list[index] = message;
    } else {
      list.insert(0, message);
    }
    update(["list"]);
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

  void sendText(String text) async {
    MessageModel message = await PathIMSDK.instance.messageManager.sendText(
      conversationType: conversationType,
      receiveID: receiveID,
      text: text,
    );
    list.insert(0, message);
    update(["list"]);
  }

  void sendPicture(String pictureUrl) async {
    MessageModel message = await PathIMSDK.instance.messageManager.sendPicture(
      conversationType: conversationType,
      receiveID: receiveID,
      content: PictureContent(pictureUrl: pictureUrl),
    );
    list.insert(0, message);
    update(["list"]);
  }

  void sendVoice(String voiceUrl, int duration) async {
    MessageModel message = await PathIMSDK.instance.messageManager.sendVoice(
      conversationType: conversationType,
      receiveID: receiveID,
      content: VoiceContent(
        voiceUrl: voiceUrl,
        duration: duration,
      ),
    );
    list.insert(0, message);
    update(["list"]);
  }

  void sendVideo(String videoUrl, int duration) async {
    MessageModel message = await PathIMSDK.instance.messageManager.sendVideo(
      conversationType: conversationType,
      receiveID: receiveID,
      content: VideoContent(
        videoUrl: videoUrl,
        duration: duration,
      ),
    );
    list.insert(0, message);
    update(["list"]);
  }

  void sendFile(String fileUrl, String type, int size) async {
    MessageModel message = await PathIMSDK.instance.messageManager.sendFile(
      conversationType: conversationType,
      receiveID: receiveID,
      content: FileContent(
        fileUrl: fileUrl,
        type: type,
        size: size,
      ),
    );
    list.insert(0, message);
    update(["list"]);
  }

  void sendRevoke(String clientMsgID) {
    PathIMSDK.instance.messageManager.markMessageRevoke(
      conversationType: conversationType,
      receiveID: receiveID,
      clientMsgID: clientMsgID,
      revokeContent: "撤回内容-可以随意定义",
    );
  }

  void updateRead(MessageModel message) {
    int index = list.indexWhere((item) {
      return item.clientMsgID == message.clientMsgID;
    });
    if (index != -1) {
      list[index] = message;
      update(["list"]);
    }
  }

  void updateRevoke(MessageModel message) {
    int index = list.indexWhere((item) {
      return item.clientMsgID == message.clientMsgID;
    });
    if (index != -1) {
      list[index] = message;
      update(["list"]);
    }
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
        title: Text(logic.receiveID),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildList(logic),
          ),
          _buildOperate(logic),
        ],
      ),
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
            reverse: true,
            controller: logic.scrollController,
            padding: const EdgeInsets.symmetric(vertical: 20),
            itemBuilder: (context, index) {
              MessageModel message = logic.list[index];
              return MessageItem(
                key: ValueKey(message.toJson()),
                message: message,
              );
            },
            separatorBuilder: (context, index) {
              MessageModel message = logic.list[index];
              int clientTime = message.clientTime;
              if (index == logic.list.length - 1) {
                return TimeItem(messageTime: clientTime);
              } else {
                MessageModel lastMessage = logic.list[index + 1];
                int lastSentTime = lastMessage.clientTime;
                if ((lastSentTime - clientTime).abs() > 300000) {
                  return TimeItem(messageTime: clientTime);
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

  Widget _buildOperate(MessageLogic logic) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
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
                textInputType: TextInputType.text,
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
