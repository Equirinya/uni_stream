import 'dart:async';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:uni_stream/content_api.dart';

import 'package:uni_stream/database.dart';

import '../overlays.dart';
import '../utils.dart';
import '../moduleTile.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({Key? key, required this.isar, required this.api, required this.courseId, this.openSection}) : super(key: key);

  final Isar isar;
  final ContentHandler api;
  final int courseId;
  final int? openSection;

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  TabController? tabController;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoadingNotification(
        site: getCourseKey(widget.api, widget.courseId),
        loading: Loading.loading,
        setCurrentSite: false,
      ).dispatch(context);

      Course? originalCourse = widget.isar.courses.getSync(widget.courseId);
      Stream<Course?> courseChanged = widget.isar.courses.watchObject(widget.courseId);
      StreamSubscription<Course?>? subscription;
      subscription = courseChanged.listen((course) async {
        try {
          if (course != null && context.mounted && course.sections != originalCourse?.sections) {
            LoadingNotification(
              site: getCourseKey(widget.api, widget.courseId),
              loading: Loading.done,
            ).dispatch(context);
            subscription?.cancel();

            if ((tabController?.offset ?? 0) != 0.0) {
              await Future.doWhile(() => Future.delayed(const Duration(milliseconds: 500)).then((_) => (tabController?.offset ?? 0) != 0.0));
            }
            setState(() {});
          }
        } catch (e) {
          subscription?.cancel();
        }
      });

      widget.api.updateCourseModules(widget.courseId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Course? isarCourse = widget.isar.courses.getSync(widget.courseId);
    if(widget.openSection != null && isarCourse != null) {
      isarCourse.lastOpenedSection = widget.openSection!;
    }

    if (isarCourse == null) {
      Navigator.of(context).pop();
      handleContentApiException(cAE: const ApiException(msgToUser: "Course couldn't be found in the database.", toBeLogged: "isarCourse is null in coursePage"));
      return const CircularProgressIndicator();
    }
    widget.isar.writeTxn(() async {
      widget.isar.courses.put(isarCourse..lastAccess = DateTime.now());
    });

    if(isarCourse.lastOpenedSection >= isarCourse.sections.length) {
      isarCourse.lastOpenedSection = 0;
    }
    tabController = TabController(length: isarCourse.sections.length, vsync: Scaffold.of(context), initialIndex: isarCourse.lastOpenedSection);
    tabController?.addListener(() {
      widget.isar.writeTxn(() async {
        final course = await widget.isar.courses.get(widget.courseId);

        if (course != null) {
          course.lastOpenedSection = tabController!.index;
          widget.isar.courses.put(course);
        }
      });
    });

    String title = getTitleFromCourse(isarCourse);

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 32.0),
          child: Text(title, overflow: TextOverflow.ellipsis),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: tabController,
          // indicator: BoxDecoration(
          //   borderRadius: BorderRadius.circular(50), // Creates border
          //   color: Theme.of(context).colorScheme.primaryContainer,
          // ),
          isScrollable: true,
          tabs: [
            for (String name in isarCourse.sections)
              Tab(
                text: name.length < 35 ? name : "${name.substring(0, 35)}...",
              )
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          for (final (int i, String sectionName) in isarCourse.sections.indexed)
            ListView(
              key: PageStorageKey("section${isarCourse.id}:$i"), //TODO disable when performance option is on
              padding: const EdgeInsets.only(bottom: 128, top: 16),
              children: [
                //Test navigation stack
                // OutlinedButton(
                //     onPressed: () {
                //       Navigator.of(context).pushNamed(TabNavigatorRoutes.course, arguments: (widget.api, widget.courseId + 1));
                //     },
                //     child: Text("new course")),

                // Headline(
                //   sectionName,
                //   fontSize: 20,
                // ),
                for (int moduleId in widget.isar.modules.filter().course((q) => q.idEqualTo(isarCourse.id)).sectionEqualTo(i).universityIdIsNotNull().sortByIndex().idProperty().findAllSync())
                  ModuleTile(
                    key: Key(moduleId.toString()),
                    moduleId: moduleId,
                    isar: widget.isar,
                    api: widget.api,
                  ),
              ],
            )
        ],
      ),
    );
  }
}