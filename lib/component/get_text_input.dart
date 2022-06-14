import 'package:path_im_sdk_flutter_demo/main.dart';

class GetTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final FocusNode? focusNode;
  final double hintSize;
  final FontWeight hintWeight;
  final double textSize;
  final FontWeight textWeight;
  final EdgeInsets contentPadding;
  final bool autoFocus;
  final bool obscureText;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final int maxLines;
  final Function(String value)? onSubmitted;

  const GetTextInput(
    this.controller,
    this.hintText, {
    Key? key,
    this.focusNode,
    this.hintSize = 14,
    this.hintWeight = getRegular,
    this.textSize = 14,
    this.textWeight = getSemiBold,
    this.contentPadding = const EdgeInsets.symmetric(
      vertical: 10,
      horizontal: 8,
    ),
    this.autoFocus = false,
    this.obscureText = false,
    this.textInputType,
    this.inputFormatters,
    this.textInputAction,
    this.maxLines = 1,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: getHintBlack,
          fontSize: hintSize,
          fontWeight: hintWeight,
        ),
        contentPadding: contentPadding,
        border: InputBorder.none,
      ),
      style: TextStyle(
        color: getTextBlack,
        fontSize: textSize,
        fontWeight: textWeight,
      ),
      cursorColor: getTextBlack,
      autofocus: autoFocus,
      obscureText: obscureText,
      keyboardType: textInputType,
      inputFormatters: inputFormatters,
      textInputAction: textInputAction,
      maxLines: maxLines,
      onSubmitted: (value) {
        if (value.isEmpty) {
          return;
        }
        if (onSubmitted != null) {
          onSubmitted!(value);
        }
      },
    );
  }
}
