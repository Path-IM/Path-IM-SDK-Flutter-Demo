import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:path_im_sdk_flutter_demo/component/component.dart';
import 'package:path_im_sdk_flutter_demo/tool/tool.dart';
import 'package:path_im_sdk_flutter_demo/routes.dart';
import 'package:path_im_sdk_flutter_demo/services.dart';

export 'package:flutter/material.dart';
export 'package:flutter/cupertino.dart' hide RefreshCallback;
export 'package:flutter/services.dart' hide TextInput;
export 'package:get/get.dart' hide Response, MultipartFile, FormData;
export 'package:path_im_sdk_flutter_demo/component/component.dart';
export 'package:path_im_sdk_flutter_demo/pages/widgets/widgets.dart';
export 'package:path_im_sdk_flutter_demo/tool/tool.dart';
export 'routes.dart';
export 'services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  runApp(const MyApp());
  errorWidget();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Refresh.configuration(
      GetMaterialApp(
        title: "PathIMDemo",
        theme: DesignTool.theme(Brightness.light),
        darkTheme: DesignTool.theme(Brightness.dark),
        initialRoute: Routes.login,
        getPages: Routes.pages,
        unknownRoute: GetPage(
          name: Routes.unknown,
          page: () => const UnknownPage(),
        ),
        defaultTransition: Transition.cupertino,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: 1.0,
              boldText: false,
            ),
            child: ScrollConfiguration(
              behavior: OverscrollBehavior(),
              child: child!,
            ),
          );
        },
      ),
    );
  }
}

void errorWidget() {
  if (kReleaseMode) {
    ErrorWidget.builder = (details) {
      return Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: const Text(
          "Error",
          style: TextStyle(
            color: Colors.red,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    };
  }
}
