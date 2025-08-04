import 'dart:async';
import 'package:cupertino_sidebar/cupertino_sidebar.dart';
import 'package:flutter/cupertino.dart';
import 'package:uni_links/uni_links.dart';

import 'features/tasks/presentation/tasks_page.dart';
import 'features/weather/presentation/weather_page.dart';
import 'features/health/presentation/health_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<Uri?>? _sub;
  int _selectedIndex = 0;
  bool _isSideBarExpanded = false;

  final List<Widget> _pages = [
    const WeatherPage(),
    const TasksPage(),
    const HealthPage(),
  ];

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
      print("URI Format error, something is wrong oops");
    } catch (e) {
      print(e);
    }
  }

  void _processUri(Uri uriString) {
    final uri = Uri.parse(uriString as String);
    if (uri.host == 'weather' && uri.queryParameters['city'] != null) {
      final city = uri.queryParameters['city']!;
      setState(() {
        _selectedIndex = 1;
      });
      print('🔔 Siri wants weather for: $city');

      // TODO: wire into WeatherPage via maybe a provider or setState(?)
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
      home: CupertinoPageScaffold(
        child: Stack(
          children: [
            Row(
              children: [
                CupertinoSidebarCollapsible(
                  isExpanded: _isSideBarExpanded,
                  child: CupertinoSidebar(
                    selectedIndex: _selectedIndex,
                    onDestinationSelected: (value) => setState(() {
                      _selectedIndex = value;
                      _isSideBarExpanded = !_isSideBarExpanded;
                    }),
                    navigationBar: const SidebarNavigationBar(
                      title: Text('M.O.N.D.A.Y.'),
                    ),
                    children: const [
                      SidebarDestination(
                        icon: Icon(CupertinoIcons.cloud),
                        label: Text('Weather'),
                      ),
                      SidebarDestination(
                        icon: Icon(CupertinoIcons.list_bullet),
                        label: Text('Tasks'),
                      ),
                      SidebarDestination(
                        icon: Icon(CupertinoIcons.heart),
                        label: Text('Health'),
                      ),
                    ],
                  ),
                ),

                // ─── Page content ───
                Expanded(
                  child: Center(
                    child: CupertinoTabTransitionBuilder(
                      child: _pages.elementAt(_selectedIndex),
                    ),
                  ),
                ),
              ],
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    setState(() {
                      _isSideBarExpanded = !_isSideBarExpanded;
                    });
                  },
                  child: const Icon(CupertinoIcons.sidebar_left),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
