import 'package:base_widgets/pages/detail_page.dart';
import 'package:base_widgets/pages/login_register_page.dart';
import 'package:base_widgets/pages/my_colllect_page.dart';
import 'package:base_widgets/pages/my_shared_page.dart';
import 'package:base_widgets/pages/my_todo_page.dart';
import 'package:base_widgets/pages/search_page.dart';
import 'package:base_widgets/pages/search_result_page.dart';
import 'package:base_widgets/pages/setting_page.dart';
import 'package:get/get.dart';
import 'package:main_page/main_page.dart';

class Routes {
  static List<GetPage> pages() {
    return List.from([
      GetPage(name: "/", page: () => const MainPage()),
      GetPage(name: "/DetailPage", page: () => const DetailPage()),
      GetPage(name: "/SettingPage", page: () => const SettingPage()),
      GetPage(name: "/MyTodoListPage", page: () => const MyTodoListPage()),
      GetPage(name: "/MySharedPage", page: () => const MySharedPage()),
      GetPage(name: "/MyColllectPage", page: () => const MyColllectPage()),
      GetPage(name: "/SearchPage", page: () => const SearchPage()),
      GetPage(name: "/SearchResultPage", page: () => SearchResultPage()),
      GetPage(
          name: "/LoginRegisterPage", page: () => const LoginRegisterPage()),
    ]);
  }
}
