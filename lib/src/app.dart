import 'dart:async';
import 'package:cupertino_sidebar/cupertino_sidebar.dart';
import 'package:flutter/cupertino.dart';
import 'package:uni_links/uni_links.dart';

import 'features/tasks/presentation/tasks_page.dart';
import 'features/weather/presentation/weather_page.dart';
import 'features/health/presentation/health_page.dart';
import 'features/blocker/presentation/blocker_page.dart';
import 'features/settings/presentation/settings_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<Uri?>? _sub;
  int _selectedIndex = 0;
  bool _isSideBarExpanded = false;
  double kSidebarWidth = 250.0;

  final List<Widget> _pages = [
    const WeatherPage(),
    const TasksPage(),
    const HealthPage(),
    const BlockerPage(),
    const SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _initDeepLinkHandling();
  }

  void _initDeepLinkHandling() {
    // 1) handle when app cold-started by a link
    getInitialUri()
        .then((uri) {
          if (uri != null) _processUri(uri);
        })
        .catchError((e) {
          print('Error getting initial uri: $e');
        });

    // 2) handle when app already running and receives a link
    _sub = uriLinkStream.listen(
      (uri) {
        if (uri != null) _processUri(uri);
      },
      onError: (err) {
        print('URI Stream error: $err');
      },
    );
  }

  // this must also handle ALL possible types of deep linking based on how we are going to configure siri
  void _processUri(Uri uri) {
    print('🔗 Deep link received: $uri');
    setState(() {
      switch (uri.host) {
        case 'weather':
          _selectedIndex = 0;

        // TODO: pull out city param and pass to weather service
        // can use, final city = uri.queryParameters['city'];
        case 'tasks':
          _selectedIndex = 1;
        case 'health':
          _selectedIndex = 2;
        default:
          break;
      }
      // optionally collapse sidebar
      _isSideBarExpanded = false;
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'M.O.N.D.A.Y.',
      home: CupertinoPageScaffold(
        child: Stack(
          children: [
            // 1) Full-width page always underneath
            Center(
              child: CupertinoTabTransitionBuilder(
                child: _pages.elementAt(_selectedIndex),
              ),
            ),

            // 2) Sidebar overlay
            AnimatedPositioned(
              duration: Duration(milliseconds: 200),
              top: 0,
              bottom: 0,
              left: 0,
              // pick your collapsed/expanded widths
              width: _isSideBarExpanded ? 250 : 80,
              child: CupertinoSidebarCollapsible(
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
                    SidebarDestination(
                      icon: Icon(CupertinoIcons.lock),
                      label: Text('App Blocker'),
                    ),
                    SidebarDestination(
                      icon: Icon(CupertinoIcons.settings),
                      label: Text('Settings'),
                    ),
                  ],
                ),
              ),
            ),

            // 3) Your toggle button, still on top
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
