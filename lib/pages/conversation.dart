import 'package:path_im_sdk_flutter_demo/main.dart';

class ConversationLogic extends GetxController {
  static ConversationLogic? logic() => Tool.capture(Get.find);

  RxInt unreadCount = 0.obs;
  List<ConversationModel> list = [];

  @override
  void onReady() {
    super.onReady();
    PathIMSDK.instance.conversationManager.getTotalUnread().then(
      (value) {
        unreadCount.value = value;
      },
    );
    PathIMSDK.instance.conversationManager.getAllConversationList().then(
      (value) {
        list = value;
        update(["list"]);
      },
    );
  }
}

class ConversationPage extends StatelessWidget {
  const ConversationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConversationLogic logic = Get.put(ConversationLogic());
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text("会话（${logic.unreadCount.value}）")),
        actions: [
          TextButton(
            onPressed: () async {
              await PathIMSDK.instance.logout();
              Get.offAllNamed(Routes.login);
            },
            child: const Text("退出"),
          ),
        ],
      ),
      body: GetBuilder<ConversationLogic>(
        id: "list",
        builder: (controller) {
          return ListView.separated(
            itemBuilder: (context, index) {
              ConversationModel conversation = logic.list[index];
              return _buildItem(
                logic.list[index],
                onTap: () {
                  Get.toNamed(Routes.message, arguments: {
                    "conversationType": conversation.conversationType,
                    "conversationID": conversation.conversationID,
                  });
                },
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(
                indent: 76,
                endIndent: 16,
              );
            },
            itemCount: logic.list.length,
          );
        },
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildItem(
    ConversationModel item, {
    Function()? onTap,
  }) {
    String content = "";
    MessageModel? message = item.message;
    if (message != null) {
      int contentType = message.contentType;
      if (contentType == ContentType.text) {
        content = message.content;
      } else if (contentType == ContentType.picture) {
        content = "[图片]";
      } else if (contentType == ContentType.voice) {
        content = "[语音]";
      } else if (contentType == ContentType.video) {
        content = "[视频]";
      } else if (contentType == ContentType.file) {
        content = "[文件]";
      } else {
        content = "[未知]";
      }
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(
          children: [
            ClipOval(
              child: Image.network(
                "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fblog%2F202107%2F16%2F20210716174622_853a5.thumb.1000_0.jpeg&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1657806416&t=198ffd53bb7bc1edb365d3a1073e422f",
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "名称是什么",
                    style: TextStyle(
                      color: getTextBlack,
                      fontSize: 16,
                      fontWeight: getSemiBold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    content,
                    style: const TextStyle(
                      color: getHintBlack,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.unreadCount?.toString() ?? "0",
                    style: const TextStyle(
                      color: getTextWhite,
                      fontSize: 10,
                      fontWeight: getSemiBold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                if (item.messageTime != null)
                  Text(
                    TimeTool.formatMessageTimestamp(item.messageTime!),
                    style: const TextStyle(
                      color: getHintBlack,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
