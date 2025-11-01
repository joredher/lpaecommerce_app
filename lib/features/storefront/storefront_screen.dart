import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StorefrontScreen extends StatefulWidget {
  const StorefrontScreen({super.key});

  @override
  State<StorefrontScreen> createState() => _StorefrontScreenState();
}

class _StorefrontScreenState extends State<StorefrontScreen> {
  static const _homeUrl = 'https://example.com/home';
  static const _productsUrl = 'https://example.com/products';
  static const _cartUrl = 'https://example.com/cart';
  static const _loginUrl = 'https://example.com/login';
  static const _cookieStorageKey = 'storefrontSessionCookies';

  late final WebViewController _controller;
  final CookieManager _cookieManager = CookieManager();
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  double _loadingProgress = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            setState(() {
              _loadingProgress = progress.clamp(0, 100) / 100;
            });
          },
          onPageStarted: (_) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (url) async {
            setState(() {
              _isLoading = false;
            });
            await _persistSessionCookies(Uri.parse(url));
          },
        ),
      );

    unawaited(_restoreSessionCookies().then((_) {
      return _controller.loadRequest(Uri.parse(_homeUrl));
    }));
  }

  Future<void> _persistSessionCookies(Uri uri) async {
    final cookies = await _cookieManager.getCookies(uri);
    final sessionCookies = cookies.where(
      (cookie) => cookie.name.toUpperCase().contains('PHPSESSID'),
    );

    final encoded = sessionCookies
        .map(
          (cookie) => jsonEncode(<String, Object?>{
            'name': cookie.name,
            'value': cookie.value,
            'domain': cookie.domain ?? uri.host,
            'path': cookie.path ?? '/',
            'isSecure': cookie.isSecure ?? false,
            'expiresDate': cookie.expiresDate?.millisecondsSinceEpoch,
          }),
        )
        .toList(growable: false);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_cookieStorageKey, encoded);
  }

  Future<void> _restoreSessionCookies() async {
    final prefs = await SharedPreferences.getInstance();
    final storedCookies = prefs.getStringList(_cookieStorageKey);
    if (storedCookies == null || storedCookies.isEmpty) {
      return;
    }

    for (final cookieData in storedCookies) {
      final Map<String, dynamic> json =
          jsonDecode(cookieData) as Map<String, dynamic>;
      await _cookieManager.setCookie(
        WebViewCookie(
          name: json['name'] as String,
          value: json['value'] as String,
          domain: json['domain'] as String,
          path: json['path'] as String? ?? '/',
          isSecure: json['isSecure'] as bool? ?? false,
          expiresDate: json['expiresDate'] == null
              ? null
              : DateTime.fromMillisecondsSinceEpoch(
                  json['expiresDate'] as int,
                ),
        ),
      );
    }
  }

  Future<void> _reload() async {
    final uri = await _controller.currentUrl();
    if (!mounted) return;
    if (uri == null) {
      await _controller.loadRequest(Uri.parse(_homeUrl));
    } else {
      await _controller.reload();
    }
  }

  void _navigateTo(Uri uri) {
    unawaited(_controller.loadRequest(uri));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Storefront'),
      ),
      body: Column(
        children: [
          if (_isLoading)
            LinearProgressIndicator(
                value: _loadingProgress == 1 ? null : _loadingProgress),
          Expanded(
            child: RefreshIndicator(
              key: _refreshKey,
              onRefresh: _reload,
              child: WebViewWidget(
                controller: _controller,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 0:
              _navigateTo(Uri.parse(_homeUrl));
              break;
            case 1:
              _navigateTo(Uri.parse(_productsUrl));
              break;
            case 2:
              _navigateTo(Uri.parse(_cartUrl));
              break;
            case 3:
              _navigateTo(Uri.parse(_loginUrl));
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Login',
          ),
        ],
      ),
    );
  }
}
