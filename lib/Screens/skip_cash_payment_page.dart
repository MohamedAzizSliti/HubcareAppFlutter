import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';

class SkipCashWebView extends StatefulWidget {
  final String paymentUrl;

  const SkipCashWebView({super.key, required this.paymentUrl});

  @override
  State<SkipCashWebView> createState() => _SkipCashWebViewState();
}

class _SkipCashWebViewState extends State<SkipCashWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final url = request.url;
            print("🔗 Navigating to: $url");

            if (url.contains("payment-success")) {
              Get.back();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("✅ Payment successful")),
              );
              return NavigationDecision.prevent;
            } else if (url.contains("payment-cancel")) {
              Get.back();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("❌ Payment cancelled")),
              );
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
          onWebResourceError: (error) {
            print("❌ WebView error: ${error.description}");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("WebView error: ${error.description}")),
            );
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SkipCash Payment')),
      body: WebViewWidget(controller: _controller),
    );
  }
}
