import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:monday/pages/tasks_page.dart';
import 'package:uni_links/uni_links.dart';
import 'pages/weather_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<Uri?>? _sub;

  @override
  void initState() {
    super.initState();
    _handleInitialUri();
    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null) _processUri(uri);
    });
  }

  Future<void> _handleInitialUri() async {
    try {
      final initialUri = await getInitialLink();

      if (initialUri != null) _processUri(initialUri as Uri);
    } on FormatException {
      print("URI Format error, somthing is wrong oops");
    } catch (e) {
      print(e);
    }
  }

  void _processUri(Uri uriString) {
    final uri = Uri.parse(uriString as String);
    if (uri.host == 'weather' && uri.queryParameters['city'] != null) {
      final city = uri.queryParameters['city']!;
      print('🔔 Siri wants weather for: $city');
      // TODO: wire into WeatherPage via maybe  a provider or setState(?)
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: true,
      title: 'M.O.N.D.A.Y.',
      routes: {
        '/': (ctx) => const TasksPage(),
        '/tasks': (ctx) => const WeatherPage(),
      },
    );
  }
}
