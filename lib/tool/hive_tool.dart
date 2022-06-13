import 'package:path_im_sdk_flutter_demo/main.dart';

export 'package:hive/hive.dart';

class HiveTool {
  static Box get userBox => HiveService.service(HiveService.user);

  static String userName = "userName";
  static String userPassword = "userPassword";

  static String getUserToken() => userBox.get(userName, defaultValue: "");

  static String getUserPassword() =>
      userBox.get(userPassword, defaultValue: "");

  static bool isLogin() =>
      getUserToken().isNotEmpty && getUserPassword().isNotEmpty;

  static void login(
    String userName,
    String userPassword,
  ) {
    userBox.put(HiveTool.userName, userName);
    userBox.put(HiveTool.userPassword, userPassword);
  }

  static void logout() => userBox.clear();
}
