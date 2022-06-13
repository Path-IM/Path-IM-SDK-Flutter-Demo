import 'package:path_im_sdk_flutter_demo/main.dart';

class Footer extends StatelessWidget {
  final double height;
  final LoadStyle loadStyle;

  const Footer({
    Key? key,
    this.height = 60,
    this.loadStyle = LoadStyle.ShowAlways,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFooter(
      height: height,
      loadStyle: loadStyle,
      builder: (context, mode) {
        Widget widget = const Text(
          "加载中～",
          style: TextStyle(
            color: getTextBlack,
            fontSize: 12,
          ),
        );
        if (mode == LoadStatus.noMore) {
          widget = const Text(
            "到底啦~",
            style: TextStyle(
              color: getTextBlack,
              fontSize: 12,
            ),
          );
        } else if (mode == LoadStatus.failed) {
          widget = const Text(
            "加载失败",
            style: TextStyle(
              color: getTextBlack,
              fontSize: 12,
            ),
          );
        }
        return Container(
          alignment: Alignment.center,
          height: height,
          child: widget,
        );
      },
    );
  }
}
