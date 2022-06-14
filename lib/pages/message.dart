import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_im_sdk_flutter_demo/main.dart';

class MessageLogic extends GetxController {
  static MessageLogic? logic() => Tool.capture(Get.find);

  late TextEditingController controller;

  @override
  void onInit() {
    super.onInit();
    controller = TextEditingController();
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }

  void pick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["jpg", "png", "aac", "mp4"],
    );
    if (result != null) {
      PlatformFile platformFile = result.files.single;
      File file = File(platformFile.path!);
      String? extension = platformFile.extension;
      if (extension == "jpg" || extension == "png") {
        print("图片");
      } else if (extension == "aac") {
        print("语音");
      } else if (extension == "mp4") {
        print("视频");
      }
    }
  }

  void send() {}
}

class MessagePage extends StatelessWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MessageLogic logic = Get.put(MessageLogic());
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.black,
        ),
        title: const Text("名称是什么"),
      ),
      body: Container(),
      bottomNavigationBar: _buildNavigationBar(logic),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget _buildNavigationBar(MessageLogic logic) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: getDividerColor,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: getNavigationBarHeight,
                maxHeight: 150,
              ),
              child: GetTextInput(
                logic.controller,
                "点击输入",
                hintSize: 16,
                textSize: 16,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 10,
                ),
                autoFocus: true,
                maxLines: null,
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: logic.pick,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
