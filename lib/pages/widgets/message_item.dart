import 'package:path_im_sdk_flutter_demo/main.dart';
import 'package:path_im_sdk_flutter_demo/pages/conversation.dart';
import 'package:path_im_sdk_flutter_demo/pages/message.dart';

enum Direction {
  left,
  right,
}

class MessageItem extends StatefulWidget {
  final MessageModel message;

  const MessageItem({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  State<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  late MessageModel _message;
  late Direction _direction;
  late int _contentType;
  late String _content;

  @override
  void initState() {
    super.initState();
    _message = widget.message;
    _direction = _message.sendID == ConversationLogic.logic()?.userId
        ? Direction.right
        : Direction.left;
    _contentType = _message.contentType;
    _content = _message.content;
  }

  @override
  Widget build(BuildContext context) {
    Widget widget = const SizedBox();
    if (_message.markRevoke == true) {
      widget = _buildText(_message.revokeContent ?? "消息已经撤回！");
    } else {
      if (_contentType == ContentType.text) {
        widget = _buildText(_content);
        // } else if (_contentType == ContentType.picture) {
        //   widget = _buildImage(PictureContent.fromJson(_content));
        // } else if (_contentType == ContentType.voice) {
        //   widget = _buildVoice(VoiceContent.fromJson(_content));
        // } else if (_contentType == ContentType.video) {
        //   widget = _buildVideo(VideoContent.fromJson(_content));
        // } else if (_contentType == ContentType.file) {
        //   widget = _buildFile(FileContent.fromJson(_content));
      } else {
        widget = _buildText("暂不支持查看此消息");
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatar(_direction == Direction.left, _direction),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: _direction == Direction.left
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                Text(
                  _message.sendID,
                  style: const TextStyle(
                    color: getTextBlack,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                widget,
              ],
            ),
          ),
          const SizedBox(width: 10),
          _buildAvatar(_direction == Direction.right, _direction),
        ],
      ),
    );
  }

  Widget _buildAvatar(bool visible, Direction direction) {
    return Visibility(
      visible: visible,
      maintainState: true,
      maintainAnimation: true,
      maintainSize: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (_direction == Direction.left) {
            Get.offAndToNamed(
              Routes.message,
              arguments: {
                "conversationType": ConversationType.single,
                "receiveID": _message.sendID,
              },
            );
          }
        },
        child: ClipOval(
          child: Image.network(
            "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fblog%2F202107%2F09%2F20210709142454_dc8dc.thumb.1000_0.jpeg&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1658225627&t=96447835672841c5d042e59720bcb48b",
            width: 40,
            height: 40,
          ),
        ),
      ),
    );
  }

  Widget _buildText(String text) {
    return Row(
      mainAxisAlignment: _direction == Direction.right
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_direction == Direction.left)
          Image.asset(
            "assets/images/icon_receive_horn.png",
            width: 3,
            height: 11,
          ),
        Flexible(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onLongPress: () {
              Clipboard.setData(ClipboardData(text: text));
              // if (_direction == Direction.right) {
              //   MessageLogic.logic(_message.receiveID)
              //       ?.sendRevoke(_message.clientMsgID);
              // }
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _direction == Direction.right
                    ? const Color(0xFF121212)
                    : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: _direction == Direction.right
                      ? const Radius.circular(4)
                      : Radius.zero,
                  topRight: _direction == Direction.right
                      ? Radius.zero
                      : const Radius.circular(4),
                  bottomLeft: const Radius.circular(4),
                  bottomRight: const Radius.circular(4),
                ),
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: _direction == Direction.right
                      ? getTextWhite
                      : const Color(0xFF121212),
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
        if (_direction == Direction.right)
          Image.asset(
            "assets/images/icon_send_horn.png",
            width: 3,
            height: 11,
          ),
      ],
    );
  }
}
