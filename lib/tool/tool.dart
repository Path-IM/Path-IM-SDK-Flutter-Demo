import 'package:path_im_sdk_flutter_demo/main.dart';
import 'package:uuid/uuid.dart';

export 'design_tool.dart';
export 'hive_tool.dart';
export 'http_tool.dart';
export 'time_tool.dart';

final String baseUrl = "";

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

  static String getUUId() {
    return const Uuid().v1().replaceAll("-", "");
  }

  static void hideKeyboard() {
    Get.focusScope?.unfocus();
  }
}
