import 'package:path_im_sdk_flutter_demo/main.dart';
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
  IMTool.init();
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
