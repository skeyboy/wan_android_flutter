import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mmkv/mmkv.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:base/constants/constants.dart';
import 'package:network/request_util.dart';
import 'package:network/user.dart';
import 'package:base/utils/error_handle.dart';
import 'package:base/utils/log_util.dart';
import 'package:main_page/routes/routes.dart';

Future<void> main() async {
  handleError(() async {
    WidgetsFlutterBinding.ensureInitialized();

    final rootDir = await MMKV.initialize();
    WanLog.i("mmkv rootDir: ${rootDir}");

    User().loadFromLocal();

    configDio(baseUrl: Constant.baseUrl);

    setPathUrlStrategy();
    runApp(ChangeNotifierProvider(
        create: (context) => User(), child: const MyApp()));
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: FToastBuilder(),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: "/",
      getPages: Routes.pages(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
