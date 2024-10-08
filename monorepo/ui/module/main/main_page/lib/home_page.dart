import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:base/base/base_page.dart';
import 'package:network/api.dart';
import 'package:network/bean/AppResponse.dart';
import 'package:network/bean/article_data_entity.dart';
import 'package:network/bean/banner_entity.dart';
import 'package:network/request_util.dart';
import 'package:network/user.dart';
import 'package:base/utils/log_util.dart';
import 'package:base/routes/routes.dart';
import "package:base_widgets/article_item_layout.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with BasePage<HomePage>, AutomaticKeepAliveClientMixin {
  var _pageIndex = 0;

  List<ArticleItemEntity> _articleList = List.empty();

  List<BannerEntity>? bannerData;

  var retryCount = 0.obs;

  var dataUpdate = 0.obs;

  final EasyRefreshController _refreshController = EasyRefreshController(
      controlFinishRefresh: true, controlFinishLoad: true);

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer<User>(builder: (context, user, child) {
      return Obx(() {
        WanLog.i("retry count: ${retryCount.value}");
        return _build(context);
      });
    });
  }

  Widget _build(BuildContext context) {
    return FutureBuilder(
        future: _refreshRequest(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == false) {
              return RetryWidget(onTapRetry: () => retryCount.value++);
            }
            return Obx(() {
              WanLog.i("data update: ${dataUpdate.value}");
              return Scaffold(
                body: EasyRefresh.builder(
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoad: _loadRequest,
                  childBuilder: (context, physics) {
                    return CustomScrollView(
                      physics: physics,
                      slivers: [
                        if (bannerData != null && bannerData!.isNotEmpty)
                          SliverToBoxAdapter(
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 16, 0, 0),
                                  child: CarouselSlider(
                                    options: CarouselOptions(
                                        enableInfiniteScroll: true,
                                        autoPlay: true,
                                        aspectRatio: 2.0,
                                        enlargeCenterPage: true,
                                        enlargeStrategy:
                                            CenterPageEnlargeStrategy.height),
                                    items: _bannerList(),
                                  ))),
                        SliverList(
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                          return GestureDetector(
                              onTap: () {
                                Routes.detailPage(_articleList[index].link,
                                    _articleList[index].title);
                                // Get.to(() => DetailPage(
                                //     _articleList[index].link,
                                //     _articleList[index].title));
                              },
                              child: ArticleItemLayout(
                                  itemEntity: _articleList[index],
                                  onCollectTap: () {
                                    _onCollectClick(_articleList[index]);
                                  }));
                        }, childCount: _articleList.length))
                      ],
                    );
                  },
                ),
              );
            });
          } else {
            return const Center(
              widthFactor: 1,
              heightFactor: 1,
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  List<Widget> _bannerList() => bannerData!
      .map((e) => GestureDetector(
            onTap: () => Routes.detailPage(e.url, e.title),
            child: Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 0.5),
                    borderRadius: const BorderRadius.all(Radius.circular(6))),
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    child: Image.network(
                      e.imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ))),
          ))
      .toList();

  _onCollectClick(ArticleItemEntity itemEntity) async {
    bool collected = itemEntity.collect;
    AppResponse<dynamic> res = await (collected
        ? HttpGo.instance.post("${Api.uncollectArticel}${itemEntity.id}/json")
        : HttpGo.instance.post("${Api.collectArticle}${itemEntity.id}/json"));

    if (res.isSuccessful) {
      Fluttertoast.showToast(msg: collected ? "取消收藏！" : "收藏成功！");
      itemEntity.collect = !itemEntity.collect;
    } else {
      Fluttertoast.showToast(
          msg: (collected ? "取消失败 -- " : "收藏失败 -- ") +
              (res.errorMsg ?? res.errorCode.toString()));
    }
  }

  void _onRefresh() async {
    await _refreshRequest();
    _refreshController.finishRefresh();
    dataUpdate.refresh();
  }

  Future<bool> _refreshRequest() async {
    _pageIndex = 0;

    bool resultStatus = true;

    List<ArticleItemEntity> result = [];

    AppResponse<List<BannerEntity>> bannerRes =
        await HttpGo.instance.get(Api.banner);
    bannerData = bannerRes.data;
    resultStatus &= bannerRes.isSuccessful;

    AppResponse<List<ArticleItemEntity>> topRes =
        await HttpGo.instance.get(Api.topArticle);
    if (topRes.isSuccessful) {
      result.addAll(topRes.data ?? List.empty());
    }
    resultStatus &= topRes.isSuccessful;

    AppResponse<ArticleDataEntity> res = await HttpGo.instance
        .get<ArticleDataEntity>("${Api.homePageArticle}$_pageIndex/json");
    resultStatus &= res.isSuccessful;

    if (res.isSuccessful) {
      result.addAll(res.data?.datas ?? List.empty());
    }
    _articleList = result;
    return resultStatus;
  }

  void _loadRequest() async {
    _pageIndex++;

    AppResponse<ArticleDataEntity> res =
        await Api().fetchHomePageArticle(_pageIndex);
    if (res.isSuccessful) {
      _articleList.addAll(res.data?.datas ?? List.empty());
    }
    _refreshController.finishLoad();
    dataUpdate.refresh();
  }

  @override
  bool get wantKeepAlive => true;
}
