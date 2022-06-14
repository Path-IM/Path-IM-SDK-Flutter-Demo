import 'package:path_im_sdk_flutter_demo/main.dart';
import 'package:path_im_sdk_flutter_demo/pages/login.dart';
import 'package:path_im_sdk_flutter_demo/pages/conversation.dart';

export 'package:path_im_sdk_flutter_demo/pages/unknown.dart';

class Routes {
  static String unknown = "/unknown";

  static String login = "/login";
  static String conversation = "/conversation";

  static final pages = [
    GetPage(
      name: login,
      page: () => const LoginPage(),
      transition: Transition.fade,
      showCupertinoParallax: false,
    ),
    GetPage(
      name: conversation,
      page: () => const ConversationPage(),
      transition: Transition.fadeIn,
      showCupertinoParallax: false,
    ),
  ];
}
