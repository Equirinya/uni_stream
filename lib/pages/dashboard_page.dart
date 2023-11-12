import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:isar/isar.dart';
import 'package:uni_stream/database.dart';
import 'package:uni_stream/tab_logic.dart';

import 'package:uni_stream/content_api.dart';

import '../overlays.dart';
import '../utils.dart';

//TODO: add select menu for name variations

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key, required this.isar, required this.apis, required this.showAddUniversityScreen}) : super(key: key);

  final Isar isar;
  final List<ContentHandler> apis;
  final void Function() showAddUniversityScreen;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Key key = Key(TabItem.explore.toString());
  List<ContentHandler> currentApis = [];
  List<ExpansionTileController> controller = [];

  @override
  void initState() {
    setState(() {
      currentApis = widget.apis;
      currentApis.forEach((element) {controller.add(ExpansionTileController());}); //TODO key?
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) LoadingNotification(site: key, loading: Loading.loading, setCurrentSite: false).dispatch(context);

      List<bool> finishedLoading = List.empty(growable: true);
      finishedLoading.addAll(List.filled(widget.apis.length, false));
      widget.apis.asMap().forEach((index, api) {
        api.updateCourses().then((_) {
          finishedLoading[index] = true;
          if (finishedLoading.every((element) => element)) {
            try {
              if (context.mounted) {
                LoadingNotification(site: key, loading: Loading.done).dispatch(context);
              }
              setState(() {});
            } catch (e) {}
          }
        });
      });
    });
    super.initState();
  }

  void stateChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // print(currentApis.map((e) => e.universityAccount.userIdentifier));
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 32.0),
          child: Row(
            children: [const Text("Deine Accounts", overflow: TextOverflow.ellipsis), IconButton(onPressed: () => widget.showAddUniversityScreen.call(), icon: const Icon(Icons.add_rounded))],
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: ReorderableListView(
        footer: const Padding(
          padding: EdgeInsets.only(bottom: 128.0),
        ),
        shrinkWrap: true,
        buildDefaultDragHandles: false,
        onReorder: (int oldIndex, int newIndex) {
          widget.isar.writeTxnSync(() {
            if (newIndex < oldIndex) {
              List<UniversityAccount> tobeAdded = [];
              tobeAdded.add(widget.isar.universityAccounts.filter().indexEqualTo(oldIndex).findFirstSync()!..index = newIndex);
              for (int i = newIndex; i < oldIndex; i++) {
                tobeAdded.add(widget.isar.universityAccounts.filter().indexEqualTo(i).findFirstSync()!..index = i + 1);
              }
              widget.isar.universityAccounts.putAllSync(tobeAdded);
            } else if (newIndex > oldIndex) {
              List<UniversityAccount> tobeAdded = [];
              tobeAdded.add(widget.isar.universityAccounts.filter().indexEqualTo(oldIndex).findFirstSync()!..index = newIndex - 1);
              for (int i = oldIndex + 1; i < newIndex; i++) {
                tobeAdded.add(widget.isar.universityAccounts.filter().indexEqualTo(i).findFirstSync()!..index = i - 1);
              }
              widget.isar.universityAccounts.putAllSync(tobeAdded);
            }
          });
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final ContentHandler item = currentApis.removeAt(oldIndex);
          currentApis.insert(newIndex, item);
          print(currentApis.map((e) => e.universityAccount.userIdentifier)); //TODO remove after testing
          setState(() {});
        },
        children: [
          for (final (index, (api, List<Course> courses)) in (currentApis..sort((a, b) => a.universityAccount.index.compareTo(b.universityAccount.index)))
              .map((ContentHandler cH) => (cH, widget.isar.courses.filter().universityAccount((q) => q.idEqualTo(cH.universityAccount.id)).sortByLastAccessDesc().findAllSync()))
              .indexed)
            Theme(
              key: Key(api.universityAccount.userIdentifier), //TODO replace with unique generated upfront for every current api
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: Slidable(
                endActionPane: ActionPane(
                  extentRatio: 0.25,
                  motion: const BehindMotion(),
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height, maxWidth: MediaQuery.of(context).size.width * 0.25),
                        child: Column(
                          children: [
                            SlidableAction(
                              borderRadius: BorderRadius.circular(8),
                              onPressed: (context) => showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      icon: const Icon(Icons.delete_outline_rounded),
                                      title: const Text("Unwiderruflich löschen?"),
                                      content: Text("Beim Löschen des Kurses werden auch alle heruntergeladenen Dateien und Videos gelöscht."), //TODO ist noch fake
                                      actions: [
                                        TextButton(
                                            style: TextButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primaryContainer),
                                            onPressed: () {
                                              widget.isar.writeTxnSync(() {
                                                widget.isar.videoApiAccounts.filter().universityAccount((q) => q.idEqualTo(api.universityAccount.id)).deleteAllSync();
                                                widget.isar.universityAccounts.deleteSync(api.universityAccount.id);
                                              });
                                              setState(() {
                                                currentApis.remove(api);
                                              });
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Löschen")),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Abbrechen"))
                                      ],
                                    );
                                  }),
                              backgroundColor: Theme.of(context).colorScheme.errorContainer,
                              icon: Icons.delete,
                              label: "Remove",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                child: ExpansionTile(
                  title: Row(
                    children: [
                      Expanded(child: Text("${api.universityAccount.university.name} ${api.universityAccount.userIdentifier}")),
                      if(currentApis.length > 1) ReorderableDragStartListener(
                          index: index,
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Icon(
                              Icons.drag_handle_rounded,
                            ),
                          ))
                    ],
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  initiallyExpanded: true,
                  children: [
                    for (Course course in courses.where((course) => !course.hidden))
                      Column(
                        children: [
                          CourseTile(
                            course: course,
                            api: api,
                            stateChanged: () => setState(() {}),
                          ),
                          const Divider(indent: 16, endIndent: 16, height: 1),
                        ],
                      ),
                    if (courses.where((course) => course.hidden).isNotEmpty)
                      ExpansionTile(
                        title: const Text('Versteckte Kurse'),
                        controlAffinity: ListTileControlAffinity.leading,
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          for (Course course in courses.where((course) => course.hidden))
                            Column(
                              children: [
                                CourseTile(
                                  course: course,
                                  api: api,
                                  stateChanged: () => setState(() {}),
                                ),
                                const Divider(indent: 16, endIndent: 16, height: 1),
                              ],
                            )
                        ],
                      )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CourseTile extends StatefulWidget {
  const CourseTile({
    Key? key,
    required this.course,
    required this.api,
    required this.stateChanged, this.showVisibilitySlider = true, this.initiallyExpanded = false,
  }) : super(key: key);

  final Course course;
  final ContentHandler? api;
  final void Function() stateChanged;
  final bool showVisibilitySlider;
  final bool initiallyExpanded;

  @override
  State<CourseTile> createState() => _CourseTileState();
}

class _CourseTileState extends State<CourseTile> {
  bool expanded = false;

  @override
  void initState() {
    expanded = widget.initiallyExpanded;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: widget.showVisibilitySlider && widget.api != null ? ActionPane(
        extentRatio: 0.25,
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            borderRadius: BorderRadius.circular(8),
            onPressed: (context) => widget.api!.setCourseVisibility(widget.course, !widget.course.hidden).then((value) => widget.stateChanged.call()),
            backgroundColor: Theme.of(context).colorScheme.primary,
            icon: widget.course.hidden ? Icons.visibility : Icons.visibility_off,
            label: widget.course.hidden ? "Show" : "Hide",
          )
        ],
      ) : null,
      child: InkWell(
        onTap: widget.api != null ? () {
          Navigator.of(context).pushNamed(TabNavigatorRoutes.course, arguments: (widget.api, widget.course.id, null)).then((value) {
            widget.stateChanged.call();
          });
        } : null,
        onLongPress: () => setState(() => expanded = !expanded),
        child: ListTile(
          title: Text(
            getTitleFromCourse(widget.course),
            maxLines: expanded ? 10 : 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontStyle: widget.api == null ? FontStyle.italic : null,
            ),
          ),
        ),
      ),
    );
  }
}
