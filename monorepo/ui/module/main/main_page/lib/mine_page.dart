import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:base/base/base_page.dart';
import 'package:base/routes/routes.dart';
import 'package:network/user.dart';
import 'package:base/utils/log_util.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<StatefulWidget> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage>
    with BasePage<MinePage>, AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    WanLog.i("change mine");
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            // color: Theme.of(context).primaryColor
            ),
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundImage:
                          AssetImage("assets/images/ic_default_avatar.png"),
                    ),
                    GestureDetector(
                        onTap: () {
                          if (!User().isLoggedIn()) {
                            Routes.loginRegisterPage();
                          }
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
                          child: Text(context.select<User, bool>(
                                  (user) => user.isLoggedIn())
                              ? context
                                  .select<User, String>((user) => user.userName)
                              : "登录/注册"),
                        )),
                    Expanded(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(context.select<User, bool>(
                                  (user) => user.isLoggedIn())
                              ? "积分：${context.select<User, String>((user) => user.userCoinCount.toString())}"
                              : "积分：--")),
                    )
                  ],
                )),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 8,
                  )
                ],
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24)),
              ),
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Routes.myColllectPage();
                          },
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "我的收藏",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Expanded(
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 15,
                                        )))
                              ],
                            ),
                          )),
                      GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Routes.mySharedPage();
                          },
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "我的分享",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Expanded(
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 15,
                                        )))
                              ],
                            ),
                          )),
                      GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Routes.myTodoListPage();
                          },
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "我的待办",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Expanded(
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 15,
                                        )))
                              ],
                            ),
                          )),
                      GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Routes.settingPage();
                          },
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "系统设置",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Expanded(
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 15,
                                        )))
                              ],
                            ),
                          ))
                    ],
                  )),
            ))
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
