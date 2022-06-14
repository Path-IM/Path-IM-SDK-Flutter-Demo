import 'package:path_im_sdk_flutter_demo/main.dart';
import 'package:path_im_sdk_flutter_demo/pages/conversation.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

Future initServices() async {
  Hive.init(
    (await path_provider.getApplicationDocumentsDirectory()).path,
  );
  await Get.putAsync(
    () => HiveService().init(HiveService.user),
    tag: HiveService.user,
  );
  await Get.putAsync(() => HttpService().init());
  initPathIM();
}

class HiveService extends GetxService {
  static Box service(String name) => Get.find(tag: name);

  static String user = "user";

  Future<Box> init(String name) async {
    return await Hive.openBox(name);
  }
}

class HttpService extends GetxService {
  static HttpService get service => Get.find();
  late Dio _dio;
  final Map<String, dynamic> _headers = {};

  Future<HttpService> init() async {
    _dio = Dio(BaseOptions(
      connectTimeout: 60000,
      receiveTimeout: 300000,
      sendTimeout: 300000,
      baseUrl: baseUrl,
      headers: _headers,
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

  BaseOptions getOptions() {
    return _dio.options;
  }

  Map<String, dynamic> getHeaders({Map<String, dynamic>? headers}) {
    if (headers != null && headers.isNotEmpty) {
      return {..._headers, ...headers};
    }
    return {
      ..._headers,
      "token": HiveTool.getUserToken(),
    };
  }
}

void initPathIM() {
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
        ConversationLogic.logic()?.unreadCount.value = count;
      },
    ),
  );
}
