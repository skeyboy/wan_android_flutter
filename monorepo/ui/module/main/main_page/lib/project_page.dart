import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:base/base/base_page.dart';
import 'package:network/api.dart';
import 'package:network/bean/AppResponse.dart';
import 'package:network/bean/project_category_entity.dart';
import 'package:network/bean/project_list_data_entity.dart';
import 'package:network/request_util.dart';
import 'package:base/routes/routes.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key});

  @override
  State<StatefulWidget> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage>
    with
        BasePage<ProjectPage>,
        AutomaticKeepAliveClientMixin,
        SingleTickerProviderStateMixin {
  List<ProjectCategoryEntity> _tabs = [];

  TabController? tabController;

  @override
  void initState() {
    super.initState();
    HttpGo.instance
        .get<List<ProjectCategoryEntity>>(Api.projectCategory)
        .then((res) {
      if (res.isSuccessful) {
        _tabs = res.data!;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_tabs.isEmpty) {
      return const Center(
          widthFactor: 1, heightFactor: 1, child: CircularProgressIndicator());
    }

    tabController ??= TabController(length: _tabs.length, vsync: this);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        bottom: TabBar(
          isScrollable: true,
          tabs: _tabs.map((e) {
            return Tab(text: e.name);
          }).toList(),
          controller: tabController,
        ),
      ),
      body: TabBarView(
          controller: tabController,
          children: _tabs.map((e) {
            return ProjectListPage(e.id);
          }).toList()),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ProjectListPage extends StatefulWidget {
  const ProjectListPage(this.cid, {super.key});

  final int cid;

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _ProjectListPageState(cid);
}

class _ProjectListPageState extends State<ProjectListPage>
    with BasePage<ProjectListPage> {
  _ProjectListPageState(this.cid);

  final int cid;

  int _currentPageIndex = 1;

  List<ProjectListDataItemEntity> data = [];

  final EasyRefreshController _refreshController = EasyRefreshController(
      controlFinishRefresh: true, controlFinishLoad: true);

  @override
  void initState() {
    super.initState();
    _getProjectListData();
  }

  _getProjectListData() async {
    AppResponse<ProjectListDataEntity> res = await HttpGo.instance.get(
        "${Api.projectList}$_currentPageIndex/json",
        queryParams: {"cid": cid});

    if (_currentPageIndex == 1) {
      data.clear();
      _refreshController.finishRefresh();
    } else {
      _refreshController.finishLoad();
    }
    if (res.isSuccessful) {
      setState(() {
        data.addAll(res.data!.datas);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh.builder(
      controller: _refreshController,
      onRefresh: () {
        _currentPageIndex = 1;
        _getProjectListData();
      },
      onLoad: () {
        _currentPageIndex++;
        _getProjectListData();
      },
      childBuilder: (context, physics) {
        return Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: GridView.builder(
              clipBehavior: Clip.none,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {
                      Routes.detailPage(data[index].link, data[index].title);
                    },
                    child: _generateItem(context, index));
              },
              physics: physics,
              itemCount: data.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                crossAxisCount: 2,
                childAspectRatio: 0.45,
              ),
            ));
      },
    );
  }

  Widget _generateItem(BuildContext context, int index) {
    var entity = data[index];
    return SizedBox(
        width: double.infinity,
        child: Card(
            surfaceTintColor: Colors.white,
            color: Colors.white,
            elevation: 4,
            clipBehavior: Clip.hardEdge,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Expanded(
                      child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          child: SizedBox.expand(
                            child: Image.network(
                              entity.envelopePic,
                              fit: BoxFit.cover,
                            ),
                          ))),
                  Container(
                      padding: const EdgeInsets.only(top: 8),
                      height: 46,
                      child:
                          Html(data: entity.title, shrinkWrap: false, style: {
                        "html": Style(
                            margin: Margins.zero,
                            maxLines: 2,
                            textOverflow: TextOverflow.ellipsis,
                            fontSize: FontSize(12),
                            padding: HtmlPaddings.zero,
                            alignment: Alignment.topLeft),
                        "body": Style(
                            margin: Margins.zero,
                            maxLines: 2,
                            textOverflow: TextOverflow.ellipsis,
                            fontSize: FontSize(12),
                            padding: HtmlPaddings.zero,
                            alignment: Alignment.topLeft)
                      }))
                ],
              ),
            )));
  }
}
