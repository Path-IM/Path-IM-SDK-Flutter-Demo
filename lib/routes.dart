import 'package:path_im_sdk_flutter_demo/main.dart';
import 'package:path_im_sdk_flutter_demo/pages/login.dart';
import 'package:path_im_sdk_flutter_demo/pages/menu.dart';

export 'package:path_im_sdk_flutter_demo/pages/unknown.dart';

class Routes {
  static String unknown = "/unknown";

  static String login = "/login";
  static String menu = "/menu";

  static final pages = [
    GetPage(
      name: login,
      page: () => const LoginPage(),
      transition: Transition.fade,
      showCupertinoParallax: false,
    ),
    GetPage(
      name: menu,
      page: () => const MenuPage(),
      transition: Transition.fadeIn,
      showCupertinoParallax: false,
    ),
  ];

  static void untilMenu() {
    Get.until((route) {
      return Get.currentRoute == Routes.menu;
    });
  }
}
