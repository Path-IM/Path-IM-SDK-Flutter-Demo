import 'package:path_im_sdk_flutter_demo/main.dart';

class GetAlertDialog extends StatelessWidget {
  static Future show(
    Widget child, {
    List<Widget>? actions,
    double width = 280,
    EdgeInsets padding = const EdgeInsets.symmetric(
      vertical: 30,
      horizontal: 20,
    ),
    Color bgColor = Colors.white,
    double bgRadius = 8,
    bool willPop = true,
    bool barrierDismissible = true,
    Color barrierColor = Colors.black54,
  }) {
    return Get.dialog(
      WillPopScope(
        onWillPop: () {
          return Future.value(willPop);
        },
        child: GetAlertDialog(
          child,
          actions: actions,
          width: width,
          padding: padding,
          bgColor: bgColor,
          bgRadius: bgRadius,
        ),
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

  final Widget child;
  final List<Widget>? actions;
  final double width;
  final EdgeInsets padding;
  final Color bgColor;
  final double bgRadius;

  const GetAlertDialog(
    this.child, {
    Key? key,
    this.actions,
    this.width = 280,
    this.padding = const EdgeInsets.symmetric(
      vertical: 30,
      horizontal: 20,
    ),
    this.bgColor = Colors.white,
    this.bgRadius = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasActions = false;
    double itemWidth = 0;
    if (actions != null && actions!.isNotEmpty) {
      hasActions = true;
      int length = actions!.length;
      itemWidth = (width - (length - 1)) / length;
    }
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: width,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(bgRadius),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: padding,
                child: child,
              ),
              hasActions
                  ? const Divider(height: 1, thickness: 1)
                  : const SizedBox(),
              hasActions
                  ? _buildActions(actions!, itemWidth)
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActions(List<Widget> actions, double itemWidth) {
    return SizedBox(
      height: 45,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return SizedBox(
            width: itemWidth,
            child: actions[index],
          );
        },
        separatorBuilder: (context, index) {
          return const VerticalDivider(width: 1, thickness: 1);
        },
        itemCount: actions.length,
      ),
    );
  }
}
