import 'package:path_im_sdk_flutter_demo/main.dart';

export 'package:hive/hive.dart';

class HiveTool {
  static Box get userBox => HiveService.service(HiveService.user);

  static String userName = "userName";
  static String userPwd = "userPwd";

  static String getUserToken() => userBox.get(userName, defaultValue: "");

  static String getUserPwd() => userBox.get(userPwd, defaultValue: "");

  static bool isLogin() => getUserToken().isNotEmpty && getUserPwd().isNotEmpty;

  static void login(
    String userName,
    String userPwd,
  ) {
    userBox.put(HiveTool.userName, userName);
    userBox.put(HiveTool.userPwd, userPwd);
  }

  static void logout() => userBox.clear();
}
