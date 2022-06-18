import 'package:path_im_sdk_flutter_demo/main.dart';

export 'design_tool.dart';
export 'http_tool.dart';
export 'time_tool.dart';

const String baseUrl = "http://42.194.149.177:8080";
const String wsUrl = "ws://42.194.149.177:9090";

class Tool {
  static Logic? capture<Logic extends GetxController>(
    Function logic, {
    String? tag,
  }) {
    try {
      return logic<Logic>(tag: tag);
    } catch (_) {
      return null;
    }
  }

  static void hideKeyboard() {
    Get.focusScope?.unfocus();
  }
}
