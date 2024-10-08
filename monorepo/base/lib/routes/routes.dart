import 'package:get/get.dart';

class Routes {
  static Future<T?>? toNamed<T>(
    String page, {
    dynamic arguments,
    int? id,
    Map<String, String>? parameters,
    bool preventDuplicates = true,
  }) {
    return Get.toNamed(page,
        arguments: arguments,
        id: id,
        parameters: parameters,
        preventDuplicates: preventDuplicates);
  }

  static Future<dynamic>? main() {
    return toNamed("/");
  }

  static Future<dynamic>? detailPage(String link, String title) {
    return toNamed("/DetailPage", parameters: {"link": link, "title": title});
  }

  static Future<dynamic>? settingPage() {
    return toNamed("/SettingPage");
  }

  static Future<dynamic>? myTodoListPage() {
    return toNamed("/MyTodoListPage");
  }

  static Future<dynamic>? mySharedPage() {
    return toNamed("/MySharedPage");
  }

  static Future<dynamic>? myColllectPage() {
    return toNamed("/MyColllectPage");
  }

  static Future<dynamic>? loginRegisterPage() {
    return toNamed("/LoginRegisterPage");
  }

  static Future<dynamic>? searchResultPage(String keyword) {
    return toNamed("/SearchResultPage", parameters: {keyword: keyword});
  }

  static Future<dynamic>? searchPage() {
    return toNamed("/SearchPage");
  }
}
