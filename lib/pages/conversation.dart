import 'package:path_im_sdk_flutter_demo/main.dart';

class ConversationLogic extends GetxController {
  static ConversationLogic? logic() => Tool.capture(Get.find);
}

class ConversationPage extends StatelessWidget {
  const ConversationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConversationLogic logic = Get.put(ConversationLogic());
    return Container();
  }
}
