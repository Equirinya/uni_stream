import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:isar/isar.dart';
import 'package:uni_stream/pages/dashboard_page.dart';
import 'package:uni_stream/pages/search_page.dart';
import 'package:uni_stream/tab_logic.dart';

import '../content_api.dart';
import '../database.dart';
import '../moduleTile.dart';

//TODO https://pub.dev/packages/video_thumbnail

//TODO  AlwaysScrollableScrollPhysics instead of weird extension to be able to register scroll

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.isar, required this.apis}) : super(key: key);

  final Isar isar;
  final List<ContentHandler> apis;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool recommended = true;
  bool downloaded = false;
  bool favorited = false;
  List<ModuleType> types = List.empty(growable: true);
  ScrollController scrollController = ScrollController();
  bool overscrollDragStarted = false;
  double scrollStartPosition = 0;
  GlobalKey columnKey = GlobalKey();
  bool firstRender = true;

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.offset > 0 && overscrollDragStarted) {
        overscrollDragStarted = false;
      }
    });
    super.initState();
  }

  @override
  dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double contentHeight;
    if(firstRender) {
      contentHeight = 0;
      Future.delayed(const Duration(milliseconds: 300)).then((value) {
        setState(() {firstRender = false;});
      });
    } else {
      contentHeight = (columnKey.currentContext?.findRenderObject() as RenderBox?)?.size.height??1;
      firstRender = true;
    }


    bool enoughRecentAccessedCourses = widget.isar.courses.filter().lastAccessGreaterThan(DateTime.now().subtract(const Duration(days: 1))).countSync() > 3;
    TextStyle? titleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary);
    return Scaffold(
      appBar: AppBar(
        title: const Padding(padding: EdgeInsets.only(right: 32.0, top: 12), child: Text("Willkommen zurück!", overflow: TextOverflow.ellipsis)),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(32),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 16),
                  FilterChip(
                      label: const Text("recommended"),
                      onSelected: (selected) => setState(() {
                            recommended = selected;
                            if (selected) {
                              downloaded = false;
                              favorited = false;
                              types = List.empty(growable: true);
                            } else {
                              downloaded = true;
                              favorited = true;
                            }
                          }),
                      selected: recommended),
                  const SizedBox(
                    height: 24,
                    child: VerticalDivider(),
                  ),
                  FilterChip(
                      label: const Text("downloaded"),
                      onSelected: (selected) => setState(() {
                            downloaded = selected;
                            if (selected) recommended = false;
                          }),
                      selected: downloaded),
                  const SizedBox(width: 8),
                  FilterChip(
                      label: const Text("favorite"),
                      onSelected: (selected) => setState(() {
                            favorited = selected;
                            if (selected) recommended = false;
                          }),
                      selected: favorited),
                  const SizedBox(width: 8),
                  FilterChip(
                      label: const Text("Videos"),
                      onSelected: (selected) => setState(() {
                            if (selected) {
                              recommended = false;
                              types.add(ModuleType.video);
                            } else {
                              types.remove(ModuleType.video);
                            }
                          }),
                      selected: types.contains(ModuleType.video)),
                  const SizedBox(width: 8),
                  FilterChip(
                      label: const Text("PDFs"),
                      onSelected: (selected) => setState(() {
                            if (selected) {
                              recommended = false;
                              types.add(ModuleType.pdf);
                            } else {
                              types.remove(ModuleType.pdf);
                            }
                          }),
                      selected: types.contains(ModuleType.pdf)),
                  const SizedBox(width: 32),
                ],
              ),
            ),
          ),
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollStartNotification && notification.dragDetails != null) {
            if (notification.metrics.axisDirection == AxisDirection.down && notification.metrics.extentBefore == 0.0) {
              overscrollDragStarted = true;
              scrollStartPosition = notification.dragDetails!.globalPosition.dy;
            } else {
              overscrollDragStarted = false;
            }
          }
          if (notification is ScrollEndNotification) {
            overscrollDragStarted = false;
          }
          if (notification is OverscrollNotification && overscrollDragStarted && (notification.dragDetails!.globalPosition.dy - scrollStartPosition) > 100) {
            overscrollDragStarted = false;
            HapticFeedback.lightImpact();
            Navigator.of(context).pushNamed(TabNavigatorRoutes.search, arguments: SearchType.all);
          }
          return true;
        },
        child: ListView(
          controller: scrollController,
          padding: const EdgeInsets.only(bottom: 128, top: 16),
          children: [
            Column(
              key: columnKey,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: recommended
                  ? [
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text("Deine zuletzt besuchten Kurse:", style: titleStyle)),
                      Column(
                        children: [
                          for (Course course in widget.isar.courses
                              .filter()
                              .optional(enoughRecentAccessedCourses, (q) => q.lastAccessGreaterThan(DateTime.now().subtract(const Duration(days: 1))))
                              .sortByLastAccessDesc()
                              .limit(enoughRecentAccessedCourses ? 5 : 3)
                              .findAllSync()) //TODO setting?
                            CourseTile(
                              course: course,
                              api: widget.apis.where((element) {
                                course.universityAccount.loadSync();
                                return element.universityAccount.id == course.universityAccount.value?.id;
                              }).firstOrNull,
                              stateChanged: () => setState(() {}),
                              showVisibilitySlider: false,
                            )
                        ],
                      ),
                      const Divider(
                        indent: 16,
                        endIndent: 16,
                      ),
                      if (widget.isar.modules.filter().typeEqualTo(ModuleType.video).lastUsedIsNotNull().progressLessThan(1.0).sortByLastUsedDesc().countSync() > 0) ...[
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Text("Deine zuletzt gesehenen Videos:", style: titleStyle)),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(width: 8),
                              for (Module module in widget.isar.modules.filter().typeEqualTo(ModuleType.video).lastUsedIsNotNull().progressLessThan(1.0).sortByLastUsedDesc().limit(10).findAllSync())
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: ModuleTile(
                                    key: Key(module.id.toString()),
                                    moduleId: module.id,
                                    isar: widget.isar,
                                    detailed: true,
                                    outOfCourse: true,
                                    api: widget.apis.firstWhere((element) {
                                      module.course.loadSync();
                                      module.course.value?.universityAccount.loadSync();
                                      return element.universityAccount.id == module.course.value?.universityAccount.value?.id;
                                    }),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const Divider(
                          indent: 16,
                          endIndent: 16,
                        ),
                      ],
                      if (widget.isar.modules.filter().typeEqualTo(ModuleType.pdf).lastUsedIsNotNull().sortByLastUsedDesc().countSync() > 0)
                        ExpansionTile(
                          title: const Text("Deine zuletzt genutzten PDFs"),
                          controlAffinity: ListTileControlAffinity.leading,
                          shape: const Border(),
                          maintainState: true,
                          initiallyExpanded: true,
                          onExpansionChanged: (_){
                            setState((){});
                          },
                          children: [
                            for (Module module in widget.isar.modules.filter().typeEqualTo(ModuleType.pdf).lastUsedIsNotNull().sortByLastUsedDesc().limit(10).findAllSync())
                              ModuleTile(
                                key: Key(module.id.toString()),
                                moduleId: module.id,
                                isar: widget.isar,
                                outOfCourse: true,
                                api: widget.apis.firstWhere((element) {
                                  module.course.loadSync();
                                  module.course.value?.universityAccount.loadSync();
                                  return element.universityAccount.id == module.course.value?.universityAccount.value?.id;
                                }),
                              ),
                          ],
                        ),
                    ]
                  : [
                      for (Module module in widget.isar.modules
                          .filter()
                          .optional(types.isNotEmpty, (q) => q.anyOf(types, (q, element) => q.typeEqualTo(element)))
                          .and()
                          .group((q) => q.optional(downloaded, (q) => q.downloadGreaterThan(0)).or().optional(favorited, (q) => q.favoritedSinceIsNotNull()))
                          .sortByLastUsedDesc()
                          .limit(100)
                          .findAllSync())
                        ModuleTile(
                          key: Key(module.id.toString()),
                          moduleId: module.id,
                          isar: widget.isar,
                          api: widget.apis.firstWhere((element) {
                            module.course.loadSync();
                            module.course.value?.universityAccount.loadSync();
                            return element.universityAccount.id == module.course.value?.universityAccount.value?.id;
                          }),
                          outOfCourse: true,
                        ),
                    ],
            ),
            SizedBox(height: (1.1 * MediaQuery.of(context).size.height) - min(MediaQuery.of(context).size.height * 0.9, contentHeight)),
          ],
        ),
      ),
    );
  }
}
