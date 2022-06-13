import 'package:path_im_sdk_flutter_demo/main.dart';

class Header extends StatelessWidget {
  final double height;
  final RefreshStyle refreshStyle;

  const Header({
    Key? key,
    this.height = 60,
    this.refreshStyle = RefreshStyle.Follow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      height: height,
      refreshStyle: refreshStyle,
      builder: (context, mode) {
        return Container(
          alignment: Alignment.center,
          height: height,
          child: const Text(
            "刷新中～",
            style: TextStyle(
              color: getTextBlack,
              fontSize: 12,
            ),
          ),
        );
      },
    );
  }
}
