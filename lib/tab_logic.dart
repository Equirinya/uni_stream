import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:uni_stream/pages/dashboard_page.dart';
import 'package:uni_stream/pages/home_page.dart';
import 'package:uni_stream/pages/library_page.dart';
import 'package:uni_stream/pages/course_page.dart';
import 'package:uni_stream/pages/page_page.dart';
import 'package:uni_stream/pages/search_page.dart';
import 'package:uni_stream/pages/settings_page.dart';

import 'package:uni_stream/utils.dart';

import 'content_api.dart';

enum TabItem {
  home(tabName: "Home"),
  explore(tabName: "Explore"),
  settings(tabName: "Settings");

  const TabItem({
    required this.tabName,
  });

  final String tabName;

  @override
  String toString() => tabName;
}

//TODO dass beim laden der app alte navigationtrees wieder geladen werden

class TabNavigatorRoutes {
  static const String root = '/';
  static const String course = '/course';
  static const String settings = '/settings';
  static const String page = '/page';
  static const String search = '/search';
}

class TabNavigator extends StatelessWidget {
  const TabNavigator({super.key, required this.navigatorKey, required this.tabItem, required this.isar, required this.apis, required this.showAddUniversityScreen, required this.navigatorObserver, required this.securePrefs});
  final GlobalKey<NavigatorState>? navigatorKey;
  final TabItem tabItem;
  final MyNavigatorObserver navigatorObserver;
  final FlutterSecureStorage securePrefs;

  final Isar isar;
  final List<ContentHandler> apis;
  final void Function() showAddUniversityScreen;


  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      observers: [navigatorObserver],
      initialRoute: TabNavigatorRoutes.root,

      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (context) {
            String route = routeSettings.name ?? TabNavigatorRoutes.root;

            switch (route) {
              case TabNavigatorRoutes.course:
                // return LibraryPage();
                final (ContentHandler api, int courseId, int? section) = routeSettings.arguments! as (ContentHandler, int, int?);
                return CoursePage(
                  isar: isar,
                  api: api,
                  courseId: courseId,
                  openSection: section,
                );

              // case TabNavigatorRoutes.settings:
              //   return SettingsPage(
              //     isar: isar,
              //     apis: apis,);

              case TabNavigatorRoutes.page:
                final (ContentHandler api, int moduleId, int courseId) = routeSettings.arguments! as (ContentHandler, int, int);
                return PagePage(
                  isar: isar,
                  api: api,
                  moduleId: moduleId,
                );

              case TabNavigatorRoutes.search:
                final searchType = routeSettings.arguments! as SearchType;
                return SearchPage(
                  isar: isar,
                  apis: apis,
                  searchType: searchType,
                );

              default: //only TabNavigatorRoutes.root hopefully //maybe add 404 Page

                switch (tabItem) {
                  case TabItem.home:
                    return HomePage(
                      isar: isar,
                      apis: apis,);
                  case TabItem.explore:
                    return DashboardPage(
                      isar: isar,
                      apis: apis,
                      showAddUniversityScreen: showAddUniversityScreen,
                    );
                  case TabItem.settings:
                    return SettingsPage(
                      isar: isar,
                      apis: apis,
                    );
                }
            }
          },
        );
      },
    );
  }
}

class MyNavigatorObserver extends NavigatorObserver {
  List<Route> routeStack = List.empty(growable: true);

  bool logNavigations = false;
  final TabItem tabItem;
  final void Function(Key key) setCurrentSite;

  MyNavigatorObserver(this.tabItem, this.setCurrentSite);

  Map<String,dynamic> routeToMap(Route route){
    return {
      "name": route.settings.name //TODO add information to course
    };
  }

  void navigationStackChanged() async {
    // if(routeStack.isEmpty) routeStack.add(MaterialPageRoute(builder: (_){return Placeholder();}, settings: RouteSettings(name: "/")));
    if(kDebugMode && logNavigations) print("Navigation stack ${routeStack.indexed.map((e) {return "${e.$1.toString()}: ${e.$2.settings.name}";})}");

    final prefs = await SharedPreferences.getInstance();
    prefs.setString("${tabItem.toString()}NavigatorStack", jsonEncode(routeStack.map((r) => routeToMap(r)).toList())); //TODO retrieve on startup

    RouteSettings? routeSettings = routeStack.last.settings;
    Key key = getKeyFromRouteSettings(routeSettings: routeSettings, tabItem: tabItem);
    setCurrentSite.call(key);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // if(routeStack.isEmpty && route.settings.name != "/") routeStack.add(MaterialPageRoute(builder: (_){return Placeholder();}, settings: RouteSettings(name: "/")));
    if(kDebugMode && logNavigations) print("Navigator didPush ${route.settings.name} $previousRoute");
    routeStack.add(route);
    navigationStackChanged();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if(kDebugMode && logNavigations) print("Navigator didPop $route $previousRoute");
    // if(kDebugMode) print("Navigation stack ${routeStack.indexed.map((e) {return "${e.$1.toString()}: ${e.$2.settings.name}";})}");
    if(routeStack.isNotEmpty) routeStack.removeLast();
    navigationStackChanged();
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    if(kDebugMode && logNavigations) print("Navigator didRemove $route $previousRoute");
    routeStack.removeLast(); //TODO any route inside stack could have been removed
    navigationStackChanged();
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    if(kDebugMode && logNavigations) print("Navigator didReplace $newRoute $oldRoute");
    routeStack.removeLast();
    if(newRoute!=null) routeStack.add(newRoute);
    navigationStackChanged();
  }
}