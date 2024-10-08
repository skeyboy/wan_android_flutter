import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  _DetailPageState();

  Key progressKey = GlobalKey();

  Key contentKey = GlobalKey();

  late WebViewController _controller = WebViewController();

  bool finish = false;

  Map<String, String?> get parameters => Get.parameters;

  String? get title => parameters["title"] ?? "";

  @override
  void initState() {
    super.initState();
    final parameters = Get.parameters;

    final url = parameters["link"] ?? "";
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(NavigationDelegate(
              onPageStarted: (url) {},
              onProgress: (progress) {},
              onPageFinished: (content) {
                if (mounted) {
                  setState(() {
                    finish = true;
                  });
                }
              }))
          ..loadRequest(Uri.parse(url));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Html(
          data: title,
          style: {
            "html": Style(
                color: Colors.white,
                margin: Margins.zero,
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
                fontSize: FontSize(18),
                padding: HtmlPaddings.zero,
                alignment: Alignment.topLeft),
            "body": Style(
                color: Colors.white,
                margin: Margins.zero,
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
                fontSize: FontSize(18),
                padding: HtmlPaddings.zero,
                alignment: Alignment.topLeft)
          },
        ),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: !finish
          ? Container(
              key: progressKey,
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              child: const CircularProgressIndicator())
          : WebViewWidget(key: contentKey, controller: _controller),
    );
  }
}
