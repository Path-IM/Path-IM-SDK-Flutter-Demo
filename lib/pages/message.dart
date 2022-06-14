import 'package:path_im_sdk_flutter_demo/main.dart';

class MessageLogic extends GetxController {
  static MessageLogic? logic() => Tool.capture(Get.find);
}

class MessagePage extends StatelessWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MessageLogic logic = Get.put(MessageLogic());
    return Container();
  }
}
