import 'package:path_im_sdk_flutter_demo/main.dart';
import 'package:path_im_sdk_flutter_demo/pages/conversation.dart';
import 'package:path_im_sdk_flutter_demo/pages/message.dart';

Future initServices() async {
  await Get.putAsync(() => HttpService().init());
  initPathIM();
}

class HttpService extends GetxService {
  static HttpService get service => Get.find();
  late Dio _dio;

  Future<HttpService> init() async {
    _dio = Dio(BaseOptions(
      connectTimeout: 60000,
      receiveTimeout: 300000,
      sendTimeout: 300000,
      baseUrl: baseUrl,
      responseType: ResponseType.json,
    ));
    _dio.interceptors.add(LogInterceptor(
      request: false,
      requestHeader: true,
      requestBody: true,
      responseHeader: false,
      responseBody: true,
    ));
    return this;
  }

  Dio getDio() {
    return _dio;
  }
}

void initPathIM() {
  PathIMSDK.instance.init(
    wsUrl: wsUrl,
    autoPull: true,
    autoRetry: true,
    groupIDCallback: GroupIDCallback(
      onGroupIDList: () async {
        return ["default_group"];
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
        ConversationLogic.logic()?.loadList();
      },
      onUpdate: (conversation) {
        ConversationLogic.logic()?.loadList();
      },
    ),
    messageListener: MessageListener(
      onReceiveMsg: (message) {
        ConversationLogic.logic()?.loadList();
        String receiveID = message.receiveID;
        if (message.conversationType == ConversationType.single &&
            message.sendID != ConversationLogic.logic()?.userId) {
          receiveID = message.sendID;
        }
        MessageLogic.logic(receiveID)?.receive(message);
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
      onRead: (message) {
        String receiveID = message.receiveID;
        if (message.conversationType == ConversationType.single &&
            message.sendID != ConversationLogic.logic()?.userId) {
          receiveID = message.sendID;
        }
        MessageLogic.logic(receiveID)?.updateRead(message);
      },
    ),
    revokeReceiptListener: RevokeReceiptListener(
      onRevoke: (message) {
        String receiveID = message.receiveID;
        if (message.conversationType == ConversationType.single &&
            message.sendID != ConversationLogic.logic()?.userId) {
          receiveID = message.sendID;
        }
        MessageLogic.logic(receiveID)?.updateRevoke(message);
      },
    ),
    totalUnreadListener: TotalUnreadListener(
      onTotalUnread: (count) {
        ConversationLogic.logic()?.unreadCount.value = count;
      },
    ),
  );
}
