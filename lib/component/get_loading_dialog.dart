import 'package:path_im_sdk_flutter_demo/main.dart';

class GetLoadingDialog extends StatelessWidget {
  static Future show(
    String? text, {
    bool willPop = true,
    bool barrierDismissible = false,
    Color barrierColor = Colors.black54,
  }) {
    return Get.dialog(
      WillPopScope(
        onWillPop: () {
          return Future.value(willPop);
        },
        child: GetLoadingDialog(text: text),
      ),
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
    );
  }

  static void hide() {
    if (Get.isDialogOpen ?? true) {
      Get.back();
    }
  }

  final String? text;

  const GetLoadingDialog({
    Key? key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0F000000),
                  offset: Offset(0, 0),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _buildChildren(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildChildren() {
    List<Widget> children = [
      const Icon(
        Icons.circle_notifications_outlined,
        size: 40,
        color: Colors.orange,
      ),
    ];
    if (text != null && text!.isNotEmpty) {
      children.insert(0, const SizedBox(height: 10));
      children.add(const SizedBox(height: 10));
      children.add(
        Text(
          text!,
          style: const TextStyle(
            color: getTextBlack,
            fontSize: 12,
          ),
        ),
      );
    }
    return children;
  }
}
