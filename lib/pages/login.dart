import 'package:path_im_sdk_flutter_demo/main.dart';

class LoginLogic extends GetxController {
  static LoginLogic? logic() => Tool.capture(Get.find);
  final HttpTool _http = HttpTool.getHttp(LoginLogic);

  late TextEditingController phone;
  late TextEditingController password;

  @override
  void onInit() {
    super.onInit();
    phone = TextEditingController();
    password = TextEditingController();
  }

  @override
  void onClose() {
    phone.dispose();
    password.dispose();
    super.onClose();
  }

  void login() async {
    await PathIMSDK.instance.login(
      token: "dizzy",
      userID: "dizzy",
    );
    Get.offAllNamed(Routes.conversation);
    return;
    Tool.hideKeyboard();
    if (phone.text.isEmpty) {
      return;
    }
    if (password.text.isEmpty) {
      return;
    }
    GetLoadingDialog.show("登录中");
    _http.post(
      "",
      data: {
        "phone": phone.text,
        "password": password.text,
      },
      onSuccess: (body) {
        GetLoadingDialog.hide();
        Map data = body["data"];
        Get.offAllNamed(Routes.conversation);
      },
      onError: (code, error) {
        GetLoadingDialog.hide();
      },
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginLogic logic = Get.put(LoginLogic());
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: Tool.hideKeyboard,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          systemNavigationBarColor: Colors.white,
        ),
        child: Scaffold(
          appBar: AppBar(
            title: const Text("登录"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(45),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),
                _buildName(logic),
                const SizedBox(height: 20),
                _buildPassword(logic),
                const SizedBox(height: 50),
                Center(
                  child: _buildLogin(logic),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
        ),
      ),
    );
  }

  Widget _buildName(LoginLogic logic) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: getTextBlack,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: GetTextInput(
        logic.phone,
        "请输入用户名",
        hintSize: 16,
        textSize: 16,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 10,
        ),
        autoFocus: true,
        textInputType: TextInputType.text,
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Widget _buildPassword(LoginLogic logic) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: getTextBlack,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: GetTextInput(
        logic.password,
        "请输入密码",
        hintSize: 16,
        textSize: 16,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 10,
        ),
        obscureText: true,
        textInputType: TextInputType.text,
      ),
    );
  }

  Widget _buildLogin(LoginLogic logic) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: logic.login,
      child: Container(
        alignment: Alignment.center,
        width: 150,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(25),
        ),
        child: const Text(
          "进入",
          style: TextStyle(
            color: getTextWhite,
            fontSize: 18,
            fontWeight: getSemiBold,
          ),
        ),
      ),
    );
  }
}
