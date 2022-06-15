import 'package:path_im_sdk_flutter_demo/main.dart';

class TimeItem extends StatelessWidget {
  final int messageTime;

  const TimeItem({
    Key? key,
    required this.messageTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        TimeTool.formatMessageTimestamp(messageTime),
        style: const TextStyle(
          color: getTextBlack,
          fontSize: 12,
        ),
      ),
    );
  }
}
