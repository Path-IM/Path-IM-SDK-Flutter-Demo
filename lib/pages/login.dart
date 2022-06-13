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

  void login() {
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
          body: Padding(
            padding: const EdgeInsets.all(45),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "登录",
                  style: TextStyle(
                    color: getTextBlack,
                    fontSize: 20,
                    fontWeight: getBold,
                  ),
                ),
                const SizedBox(height: 50),
                _buildPhone(logic),
                const SizedBox(height: 20),
                _buildPassword(logic),
                const SizedBox(height: 45),
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

  Widget _buildPhone(LoginLogic logic) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: getTextBlack,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextInput(
        logic.phone,
        "请输入手机号",
        hintSize: 16,
        textSize: 16,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 10,
        ),
        autoFocus: true,
        textInputType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[0-9]")),
          LengthLimitingTextInputFormatter(11),
        ],
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
      child: TextInput(
        logic.password,
        "请输入密码",
        hintSize: 16,
        textSize: 16,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 10,
        ),
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
        width: 100,
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
