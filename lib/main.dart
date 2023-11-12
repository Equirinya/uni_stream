import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:background_downloader/background_downloader.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_stream/content_api.dart';
import 'package:uni_stream/database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uni_stream/pages/add_university_page.dart';

import 'package:uni_stream/tab_logic.dart';
import 'package:uni_stream/video_api.dart';

import 'overlays.dart';
import 'utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final Isar isar = await Isar.open(
    [UniversityAccountSchema, CourseSchema, ModuleSchema, VideoApiAccountSchema, SearchableSchema],
    directory: (await getApplicationSupportDirectory()).path,
  );

  if (kDebugMode) {
    timeDilation = 1.0;
  }

  //TODO: check for all downloaded files if still in download folder -> if not change isar to not downlaoded
  //TODO and also delete not used files

  final prefs = await SharedPreferences.getInstance();
  final int lastUsedVersion = prefs.getInt('lastUsedVersion') ?? 0;
  const int currentVersion = 1;

  if (lastUsedVersion < 2) {
    prefs.setInt("downloadRetries", 0);
    prefs.setInt("downloadOverMobileData", 1);
  }
  prefs.setInt('lastUsedVersion', currentVersion);

  final FlutterSecureStorage securePrefs;
  AndroidOptions getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  securePrefs = FlutterSecureStorage(aOptions: getAndroidOptions());

  VideoDistributor videoDistributor = VideoDistributor(isar, securePrefs);
  videoDistributor.init();

  runApp(MyApp(
    isar: isar,
    videoDistributor: videoDistributor,
    securePrefs: securePrefs,
  ));
}

class MyApp extends StatelessWidget {
  final Isar isar;
  final VideoDistributor videoDistributor;
  final FlutterSecureStorage securePrefs;
  const MyApp({Key? key, required this.isar, required this.videoDistributor, required this.securePrefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("the evil init");

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

        if (lightDynamic != null && darkDynamic != null) {
          // On Android S+ devices, use the provided dynamic color scheme.
          // (Recommended) Harmonize the dynamic color scheme' built-in semantic colors.
          lightColorScheme = lightDynamic.harmonized();
          // (Optional) Customize the scheme as desired. For example, one might
          // want to use a brand color to override the dynamic [ColorScheme.secondary].
          // lightColorScheme = lightColorScheme.copyWith(secondary: _brandBlue);
          // (Optional) If applicable, harmonize custom colors.
          // lightCustomColors = lightCustomColors.harmonized(lightColorScheme);

          // Repeat for the dark color scheme.
          darkColorScheme = darkDynamic.harmonized();
          // darkColorScheme = darkColorScheme.copyWith(secondary: _brandBlue);
          // darkCustomColors = darkCustomColors.harmonized(darkColorScheme);
        } else {
          // Otherwise, use fallback schemes.
          lightColorScheme = ColorScheme.fromSeed(
            seedColor: Colors.teal,
          );
          darkColorScheme = ColorScheme.fromSeed(
            seedColor: Colors.teal,
            brightness: Brightness.dark,
          );
        }

        return MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightColorScheme,
            // extensions: [lightCustomColors],
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkColorScheme,
            // extensions: [darkCustomColors],
          ),
          themeMode: ThemeMode.dark,
          //TODO localisations
          home: MiniPlayerContainer(
            isar: isar,
            videoDistributor: videoDistributor,
            child: LoadingStatus(
              child: OuterPage(
                isar: isar,
                securePrefs: securePrefs,
                videoDistributor: videoDistributor,
                updateApis: (List<ContentHandler> apis) {
                  videoDistributor.updateApis(apis);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class OuterPage extends StatefulWidget {
  const OuterPage({Key? key, required this.isar, required this.securePrefs, required this.videoDistributor, required this.updateApis}) : super(key: key);

  final Isar isar;
  final FlutterSecureStorage securePrefs;
  final VideoDistributor videoDistributor;
  final Function(List<ContentHandler>) updateApis;

  @override
  State<OuterPage> createState() => _OuterPageState();
}

class _OuterPageState extends State<OuterPage> {
  List<ContentHandler> apis = List.empty(growable: true);
  late StreamSubscription dwonloaderSubscription;

  @override
  void initState() {
    dwonloaderSubscription = FileDownloader().updates.listen((update) {
      if (update is TaskStatusUpdate) {
        switch (update.task.group) {
          case "module":
            int? moduleId = int.tryParse(update.task.metaData);
            if (moduleId != null) {
              widget.isar.writeTxn(() async {
                Module? module = await widget.isar.modules.get(moduleId);
                if (module != null) {
                  if (update.status == TaskStatus.enqueued) {
                    module.download = 0;
                  }
                  widget.isar.modules.put(module);
                }
              });
            } else {
              log(msg: "Error: could not parse module id from task metadata ${update.task.metaData}", lvl: ExceptionLevel.error);
            }
            break;

          default:
            print('Status update for ${update.task} with status ${update.status}');
        }
      } else if (update is TaskProgressUpdate) {
        switch (update.task.group) {
          case "module":
            int? moduleId = int.tryParse(update.task.metaData);
            if (moduleId != null) {
              widget.isar.writeTxn(() async {
                Module? module = await widget.isar.modules.get(moduleId);
                if (module != null) {
                  module.download = update.progress;
                  if (update.progress < 0 || update.progress > 1) {
                    module.download = null;
                  } else {
                    if (update.progress == 1.0) {
                      module.filepath = await update.task.filePath();
                    } else {
                      module.filepath = null;
                    }
                  }
                  widget.isar.modules.put(module);
                }
              });
              if(update.progress == 1.0){
                Future.delayed(const Duration(seconds: 1), () {
                  // transcribeModule(moduleId, widget.isar);

                  RootIsolateToken rootToken = RootIsolateToken.instance!;
                  compute<(int, RootIsolateToken), void>(transcribeModuleSync, (moduleId, rootToken)).then((value) {
                    print("computeFinished");
                  },);
                });
              }
            } else {
              log(msg: "Error: could not parse module id from task metadata ${update.task.metaData}", lvl: ExceptionLevel.error);
            }
            break;

          default:
            print('Progress update for ${update.task} with progress ${update.progress}');
        }
      }
    });
    FileDownloader().resumeFromBackground();

    createApis();
    _navigatorObservers = {
      TabItem.home: MyNavigatorObserver(TabItem.home, (key) => LoadingNotification(site: key, setCurrentSite: true).dispatch(context)),
      TabItem.explore: MyNavigatorObserver(TabItem.explore, (key) => LoadingNotification(site: key, setCurrentSite: true).dispatch(context)),
      TabItem.settings: MyNavigatorObserver(TabItem.settings, (key) => LoadingNotification(site: key, setCurrentSite: true).dispatch(context)),
    };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isar.universityAccounts.countSync() == 0) {
        showAddUniversityScreen(true);
      }
      Future.delayed(const Duration(seconds: 1), () {
        LoadingNotification(site: Key(_currentTab.toString()), setCurrentSite: true).dispatch(context);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    dwonloaderSubscription.cancel();
    super.dispose();
  }

  void showAddUniversityScreen(bool welcome) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => AddUniversityPage(
                  isar: widget.isar,
                  welcome: welcome,
                  securePrefs: widget.securePrefs,
                )))
        .then((value) {
      createApis(reset: true);
    });
  }

  void createApis({bool reset = false}) {
    apis = List.empty(growable: true);

    for (UniversityAccount universityAccount in widget.isar.universityAccounts.where().findAllSync()) {
      apis.add(ContentHandler(widget.isar, universityAccount, universityAccount.university.contentApiFactory.call(), widget.securePrefs, widget.videoDistributor));
    }
    widget.updateApis(apis);
    setState(() {});
    if (reset) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigatorKeys[TabItem.explore]!.currentState?.popUntil((route) => route.isFirst);
        _navigatorKeys[TabItem.explore]!.currentState?.pushReplacementNamed(TabNavigatorRoutes.root);

        _navigatorKeys[TabItem.home]!.currentState?.popUntil((route) => route.isFirst);
        _navigatorKeys[TabItem.home]!.currentState?.pushReplacementNamed(TabNavigatorRoutes.root);

        _selectTab(TabItem.explore);
      });
    }
  }

  //Tab logic
  var _currentTab = TabItem.home;

  final _navigatorKeys = {
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.explore: GlobalKey<NavigatorState>(),
    TabItem.settings: GlobalKey<NavigatorState>(),
  };

  late final Map<TabItem, MyNavigatorObserver> _navigatorObservers;

  Widget _buildOffstageNavigator(TabItem tabItem) {
    return Offstage(
      offstage: _currentTab != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem],
        tabItem: tabItem,
        isar: widget.isar,
        apis: apis,
        securePrefs: widget.securePrefs,
        showAddUniversityScreen: () => showAddUniversityScreen(false),
        navigatorObserver: _navigatorObservers[tabItem]!,
      ),
    );
  }

  void _selectTab(TabItem tabItem) {
    if (tabItem == _currentTab) {
      // pop to first route
      _navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
      //TODO scroll up
    } else {
      setState(() => _currentTab = tabItem);
    }
    RouteSettings? routeSettings;
    _navigatorKeys[tabItem]?.currentState?.popUntil((route) {
      routeSettings = route.settings;
      return true;
    });
    //this is to be called when tab changes because navigationobservers will not be notified because individual navigation trees stay the same
    if (routeSettings != null) {
      Key key = getKeyFromRouteSettings(routeSettings: routeSettings!, tabItem: tabItem);
      LoadingNotification(site: key, setCurrentSite: true).dispatch(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab = !(await _navigatorKeys[_currentTab]!.currentState!.maybePop(context));

        if (isFirstRouteInCurrentTab) {
          if (_currentTab != TabItem.home) {
            if (context.mounted) _selectTab(TabItem.home);
            // back button handled by app
            return false;
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: Stack(children: <Widget>[
          _buildOffstageNavigator(TabItem.home),
          _buildOffstageNavigator(TabItem.explore),
          _buildOffstageNavigator(TabItem.settings),
        ]),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(colorScheme: Theme.of(context).colorScheme.copyWith(secondaryContainer: Colors.transparent)),
          child: SizedBox(
            height: kBottomNavigationBarHeight,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 60,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black, Colors.black12, Colors.transparent], stops: [0.2, 0.8, 1]),
                      // CurvedGradient(
                      //     begin: Alignment.bottomCenter,
                      //     end: Alignment.topCenter,
                      //     colors: [Colors.transparent, Colors.black],
                      //     granularity: 50,
                      //     curveGenerator: (x) => pow(x, 2).toDouble(),
                      //     stops: [0, 0.95],
                      //     ),
                    ),
                  ),
                ),
                NavigationBar(
                  selectedIndex: _currentTab.index,
                  onDestinationSelected: (index) => _selectTab(TabItem.values[index]),
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Ionicons.home_outline),
                      selectedIcon: Icon(Ionicons.home),
                      label: "Home",
                    ),
                    NavigationDestination(
                      icon: Icon(Ionicons.compass_outline),
                      selectedIcon: Icon(Ionicons.compass),
                      label: "Explore",
                    ),
                    NavigationDestination(
                      icon: Icon(Ionicons.settings_outline),
                      selectedIcon: Icon(Ionicons.settings),
                      label: "Settings",
                    ),
                  ],
                  backgroundColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
                  height: 48,
                ),
              ],
            ),
          ),
        ),
        extendBody: true,
      ),
    );
  }
}
