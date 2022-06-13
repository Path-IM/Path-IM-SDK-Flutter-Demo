import 'package:path_im_sdk_flutter_demo/main.dart';

class MenuLogic extends GetxController {
  static MenuLogic? logic() => Tool.capture(Get.find);
}

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MenuLogic logic = Get.put(MenuLogic());
    return Container();
  }
}
