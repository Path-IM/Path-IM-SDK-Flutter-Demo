import 'package:path_im_sdk_flutter_demo/main.dart';

const double getToolbarHeight = 48;
const double getNavigationBarHeight = 58;

const Color getMainColor = Color(0xFFFF1155);
const Color getToolbarColor = Color(0xFFFFFFFF);
const Color getBackgroundColor = Color(0xFFF5F5F5);
const Color getDividerColor = Color(0xFFF5F5F5);

const Color getTextBlack = Color(0xFF000000);
const Color getHintBlack = Color(0x80000000);
const Color getTextWhite = Color(0xFFFFFFFF);
const Color getHintWhite = Color(0x80FFFFFF);

const FontWeight getRegular = FontWeight.w400;
const FontWeight getMedium = FontWeight.w500;
const FontWeight getSemiBold = FontWeight.w600;
const FontWeight getBold = FontWeight.w700;

class DesignTool {
  static ThemeData theme(Brightness brightness) {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.white,
      scaffoldBackgroundColor: getBackgroundColor,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        backgroundColor: getToolbarColor,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: getToolbarHeight,
        titleTextStyle: TextStyle(
          color: getTextBlack,
          fontSize: 18,
          fontWeight: getSemiBold,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: getDividerColor,
        space: 1,
        thickness: 1,
      ),
      textTheme: const TextTheme(
        bodyText2: TextStyle(
          height: 1.25,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: Colors.black,
          splashFactory: NoSplash.splashFactory,
        ),
      ),
    );
  }
}
