import 'package:path_im_sdk_flutter_demo/main.dart';

export 'package:path_im_sdk_flutter/path_im_sdk_flutter.dart';

class IMTool {
  static void init() {
    PathIMSDK.instance.init(
      wsUrl: wsUrl,
      autoPull: true,
      autoRetry: true,
      groupIDCallback: GroupIDCallback(
        onGroupIDList: () async {
          return [""];
        },
      ),
      connectListener: ConnectListener(
        onConnecting: () {
          print("连接中");
        },
        onSuccess: () {
          print("连接成功");
        },
        onError: (error) {
          print("发生错误：$error");
        },
        onClose: () {
          print("连接关闭");
        },
      ),
      conversationListener: ConversationListener(
        onAdded: (conversation) {
          print("新增会话：${conversation.toJsonMap()}");
        },
        onUpdate: (conversation) {
          print("更新会话：${conversation.toJsonMap()}");
        },
      ),
      messageListener: MessageListener(
        onReceiveMsg: (message) {
          print("接收消息：${message.toJson()}"
              "\ncontent：${message.content}"
              "\nseq：${message.seq}");
        },
        onSendSuccess: (clientMsgID) {
          print("发送成功：$clientMsgID");
        },
        onSendFailed: (clientMsgID, errMsg) {
          print("发送失败：$clientMsgID - $errMsg");
        },
        onSendLimit: (clientMsgID, errMsg) {
          print("发送限流：$clientMsgID - $errMsg");
        },
      ),
      typingReceiptListener: TypingReceiptListener(
        onTyping: (userID, focus) {
          print("正在输入：$userID - $focus");
        },
      ),
      readReceiptListener: ReadReceiptListener(
        onSingle: (clientMsgID) {
          print("单聊已读：$clientMsgID");
        },
        onGroup: (clientMsgID, readCount) {
          print("群聊已读：$clientMsgID - $readCount");
        },
      ),
      revokeReceiptListener: RevokeReceiptListener(
        onRevoke: (clientMsgID) {
          print("消息撤回：$clientMsgID");
        },
      ),
      totalUnreadListener: TotalUnreadListener(
        onTotalUnread: (count) {
          print("总未读数：$count");
        },
      ),
    );
  }
}
