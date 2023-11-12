import 'dart:async';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:isar/isar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'content_api.dart';
import 'database.dart';
import 'overlays.dart';
import 'tab_logic.dart';
import 'utils.dart';

class ModuleTile extends StatefulWidget {
  const ModuleTile({Key? key, required this.moduleId, required this.isar, required this.api, this.detailed = false, this.outOfCourse = false, this.titleHighlights, this.transcriptHighlights})
      : super(key: key);
  final int moduleId;
  final Isar isar;
  final ContentHandler api;
  final bool detailed;
  final bool outOfCourse;
  final String? titleHighlights;
  final TextSpan? transcriptHighlights;

  @override
  State<ModuleTile> createState() => _ModuleTileState();
}

class _ModuleTileState extends State<ModuleTile> {
  late String title;
  TextStyle? titleStyle;
  bool isHtmlTitle = false;
  bool isTitlePrimaryColor = false;
  String? description;
  late String courseName;
  int? courseId;
  int? section;
  String? preview;
  IconData? icon;
  ModuleType type = ModuleType.unsupported;

  bool downloadable = false;
  bool playable = false;
  bool hasFavoriteButton = false;
  bool expandable = false;
  List<Module> submodules = List.empty(growable: true);
  void Function()? onTap;

  bool favorite = false;
  double? progress; //for video and maybe pdf?
  double? download; //null when not downloaded
  StreamSubscription? watcher;

  bool searchExpanded = false;

  //TODO add file size for pdf and video
  void showOptions() async {
    double previewWidth = 0;
    double previewHeight = 0;
    if (preview != null) {
      File imageFile = File(preview!);
      var decodedImage = await decodeImageFromList(imageFile.readAsBytesSync());
      double aspectRatio = decodedImage.width / decodedImage.height;
      //aspectRatio has to be between 9/16 and 16/9
      if (aspectRatio < 9 / 16) {
        aspectRatio = 9 / 16;
      } else if (aspectRatio > 16 / 9) {
        aspectRatio = 16 / 9;
      }
      if (aspectRatio > 1) {
        previewWidth = MediaQuery.of(context).size.width / 5;
        previewHeight = previewWidth / aspectRatio;
      } else {
        previewHeight = 100;
        previewWidth = previewHeight * aspectRatio;
      }
    }

    // ignore: use_build_context_synchronously
    showModalBottomSheet(
      routeSettings: const RouteSettings(name: "/bottomModal"),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            widget.isar.modules.watchObjectLazy(widget.moduleId, fireImmediately: false).first.then((module) {
              if (context.mounted) {
                setState(() {});
              }
            });
            double fileSize = -1;
            Module? module = widget.isar.modules.getSync(widget.moduleId);
            if (module != null) {
              if (module.filepath != null) {
                File file = File(module.filepath!);
                if (file.existsSync()) {
                  fileSize = file.statSync().size / 1024 / 1024;
                }
              }
            }

            String downloadString = "";
            if (download != null) {
              if (download == 1.0) {
                downloadString = "Heruntergeladen";
              } else if(download == 0.0)
              {
                downloadString = "In der Warteschlange";
              }
              else {
                downloadString = "Download: ${(download! * 100).toStringAsFixed(0)}%";
              }
            }
            String description = "$downloadString${fileSize != -1 ? "Dateigröße: ${fileSize.toStringAsFixed(2)}MB" : ""}";

            return SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: preview != null
                        ? SizedBox(
                            width: previewWidth,
                            height: previewHeight,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Stack(
                                  children: [
                                    Image.file(File(preview!), fit: BoxFit.cover, width: previewWidth, height: previewHeight),
                                    if (progress != null)
                                      Align(
                                          alignment: Alignment.bottomCenter,
                                          child: LinearProgressIndicator(
                                            value: progress,
                                            minHeight: 2,
                                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                                            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                          )),
                                  ],
                                )),
                          )
                        : Icon(icon),
                    title: Text(
                      title,
                      style: titleStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: description.isNotEmpty ? Text(description): null,
                  ),
                  const Divider(
                    height: 1,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          VerticalIconTextButton(
                              onPressed: () {
                                widget.isar.modules.get(widget.moduleId).then((module) => widget.isar.writeTxn(() async {
                                      if (module != null) {
                                        widget.isar.modules.put(module
                                          ..favoritedSince = (module.favoritedSince != null ? null : DateTime.now())
                                          ..lastUsed = DateTime.now());
                                      }
                                    }));
                                setState(() {
                                  favorite = !favorite;
                                });
                              },
                              text: "Favorite",
                              iconSize: 38,
                              icon: favorite ? Icons.star_rounded : Icons.star_border_rounded),
                          if(downloadable) VerticalIconTextButton(
                              onPressed: () {
                                if (download == null) {
                                  widget.api.downloadModule(widget.moduleId);
                                } else if (download != 1.0) {
                                  widget.api.cancelDownloadModule(widget.moduleId);
                                  deleteDownload();
                                }
                                else{
                                  deleteButAskDownload(context);
                                }
                              },
                              text: "Download",
                              icon: download == null ? Ionicons.download_outline : download != 1.0 ? Ionicons.stop_circle_outline : Icons.download_done_rounded),
                          //share TODO add more filetypes
                          if ([ModuleType.pdf, ModuleType.file].contains(type))
                            VerticalIconTextButton(
                              icon: Ionicons.share_outline,
                              text: "Share",
                              onPressed: () async {
                                switch (type) {
                                  case ModuleType.file:
                                  case ModuleType.pdf:
                                    Module? module = widget.isar.modules.getSync(widget.moduleId);

                                    if (module != null) {
                                      if (download == null) {
                                        widget.api.downloadModule(widget.moduleId);
                                      }
                                      if (download != 1.0) {
                                        showLongToast("Datei wird geteilt, sobald sie fertig heruntergeladen ist.");
                                        bool downloadStarted = false;
                                        await Future.doWhile(() => Future.delayed(const Duration(milliseconds: 100)).then((_) {
                                          // print("waiting for download to finish${download != 1.0 && (!downloadStarted || download != null)}");
                                          if(download != null) downloadStarted = true;
                                              return download != 1.0 && (!downloadStarted || download != null);
                                            }));
                                      }
                                      module = widget.isar.modules.getSync(widget.moduleId);
                                      if(download == 1.0) {
                                        if (module != null && module.filepath != null) {
                                          String? filepath = await getExternalFilePath(module);
                                          if (filepath != null) {
                                            if(File(filepath).existsSync()) await Share.shareXFiles([XFile(filepath)]);
                                            else showLongToast("Couldnt load file after download");
                                            Navigator.pop(context);
                                          }
                                        } else {
                                          showLongToast("Couldnt load file from memory");
                                          //deleteDownload();
                                        }
                                      }
                                      else{
                                        showLongToast("Download was interrupted.");
                                      }
                                    }
                                    break;
                                  default:
                                    break;
                                }
                              },
                            ),
                          if (widget.outOfCourse && courseId != null)
                            VerticalIconTextButton(
                              icon: Ionicons.open_outline,
                              text: "Open in course",
                              onPressed: () async {
                                Navigator.of(context).pushNamed(TabNavigatorRoutes.course, arguments: (widget.api, courseId, section));
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
    //open Externally
    //favourite
    //delete download
    //share
  }

  void deleteDownload() {
    updateLastUsed();
    widget.isar.writeTxn(() async {
      Module? module = await widget.isar.modules.get(widget.moduleId);
      if (module != null) {
        if (module.filepath != null) {
          File file = File(module.filepath!);
          if (file.existsSync()) {
            file.deleteSync();
          }
        }
        widget.isar.modules.put(module
          ..download = null
          ..filepath = null);
        await module.searchable.load();
        if(module.searchable.value != null) await widget.isar.searchables.delete(module.searchable.value!.id);
      }
    });
  }

  Future<void> updateLastUsed() async {
    await widget.isar.writeTxn(() async {
      Module? module = await widget.isar.modules.get(widget.moduleId);
      if (module != null) {
        widget.isar.modules.put(module..lastUsed = DateTime.now());
      }
    });
    return;
  }

  Future<String?> getExternalFilePath(Module module) async {
    String? filepath = module.filepath;
    if (module.filepath!.startsWith("/data/user/0/eu.jayjay.uni_stream/app_flutter")) {
      String? newFilepath = await FileDownloader().moveFileToSharedStorage(module.filepath!, SharedStorage.downloads);
      widget.isar.writeTxn(() async {
        Module? module = await widget.isar.modules.get(widget.moduleId);
        if (module != null) {
          widget.isar.modules.put(module..filepath = newFilepath);
        }
      });
      filepath = newFilepath;
    }
    return filepath;
  }

  @override
  void initState() {
    Module? module = widget.isar.modules.getSync(widget.moduleId);
    type = module?.type ?? ModuleType.unsupported;
    if (module == null) {
      title = "Module could not be loaded";
      titleStyle = const TextStyle(
        fontStyle: FontStyle.italic,
        color: Colors.red,
      );
    } else {
      title = module.title;
      module.course.loadSync();
      courseName = getTitleFromCourse(module.course.value);
      courseId = module.course.value?.id;
      section = module.section;
      description = module.description;
      preview = module.previewFilepath;

      switch (module.type) {
        case ModuleType.file:
          icon = Ionicons.document;
          continue pdf;

        pdf:
        case ModuleType.pdf:
          if (module.url == null) continue text;
          downloadable = true;
          hasFavoriteButton = true;
          icon ??= Ionicons.document_text;
          onTap = () async {
            Module? module = widget.isar.modules.getSync(widget.moduleId);
            //TODO use pdfx as internal variant (only for pdf)
            if (download != null && module != null) {
              if (module.filepath != null) {
                String? filepath = await getExternalFilePath(module);
                if (filepath != null) {
                  bool success = await FileDownloader().openFile(filePath: filepath);
                  if (!success) showLongToast("Failed to open file. Do you have an app installed to open ${filepath.split('.').length > 1 ? "a .${filepath.split('.').last} file" : "it"}?");
                }
              } else {
                showLongToast("Couldnt load file from memory");
                deleteDownload();
              }
            } else {
              widget.api.downloadModule(widget.moduleId);
            }
          };

          break;

        // case ModuleType.image:
        //   // TODO: Handle this case.
        //   break;
        case ModuleType.video:
          hasFavoriteButton = true;
          downloadable = true;
          playable = true;
          onTap = () {
            Module? updatedModule = widget.isar.modules.getSync(module.id);
            if (updatedModule != null) MediaNotification(module: updatedModule).dispatch(context);
          };
          break;

        case ModuleType.page:
        case ModuleType.folder:
          hasFavoriteButton = true;
          expandable = true;
          downloadable = false; //TODO change to true and then download all submodules
          onTap = () {
            Navigator.of(context).pushNamed(TabNavigatorRoutes.page, arguments: (widget.api, widget.moduleId, module.course.value?.id));
          };
          break;

        // case ModuleType.html:
        //   // TODO: Handle this case.
        //   break;

        text:
        case ModuleType.text:
          if (module.url != null && module.url!.isNotEmpty) {
            isTitlePrimaryColor = true;
            titleStyle = const TextStyle(
              decoration: TextDecoration.underline,
            );
            onTap = () => launchUrl(
                  Uri.parse(module.url!),
                  mode: LaunchMode.externalApplication,
                );
          }
          break;

        case ModuleType.html:
          isHtmlTitle = true;
// TODO          Html(
//   data: api.addTokenToImageUrls(section["summary"]),
//   onLinkTap: (url, context, attributes, element) async {
//   launchInBrowser(Uri.parse(url!));
// },
// ),
          break;

        default:
          title = "Unsupported: ${module.title}";
          titleStyle = const TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.grey,
          );
      }

      if (module.type != ModuleType.unsupported) {
        favorite = module.favoritedSince != null;
        progress = module.progress;
        download = module.download;
        module.submodules.loadSync();
        submodules = module.submodules.toList();
        watcher = widget.isar.modules.watchObject(widget.moduleId, fireImmediately: false).listen((newModule) {
          if (newModule != null) {
            setState(() {
              progress = newModule.progress;
              download = newModule.download;
              favorite = newModule.favoritedSince != null;
              newModule.submodules.loadSync();
              submodules = newModule.submodules.toList();
            });
          } else {
            setState(() {
              title = "Module could not be loaded";
              titleStyle = const TextStyle(fontStyle: FontStyle.italic, color: Colors.red);
              downloadable = false;
              hasFavoriteButton = false;
              expandable = false;
            });
          }
        });
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    if (watcher != null) watcher!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color mainColour = Theme.of(context).colorScheme.onBackground;

    Widget titleW;
    if (isHtmlTitle) {
      print("title print");
      print(title);
      titleW = Html(
        data: title,
        onLinkTap: (url, attributes, element) {
          launchUrl(
            Uri.parse(url!),
            mode: LaunchMode.externalApplication,
          );
        },
        shrinkWrap: true,
        extensions: const [
          TableHtmlExtension(),
        ],
        style: {
          "html": Style(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          "a": Style(
            color: Theme.of(context).colorScheme.primary,
            textDecorationColor: Theme.of(context).colorScheme.primary,
          ),
        },
      );
    } else {
      if (isTitlePrimaryColor) titleStyle = titleStyle?.copyWith(color: Theme.of(context).colorScheme.primary, decorationColor: Theme.of(context).colorScheme.primary);
      titleW = Text(
        title,
        style: titleStyle,
        overflow: TextOverflow.ellipsis,
        maxLines: widget.detailed ? 2: widget.outOfCourse ? 1 : 100,
      );
    }

    bool subtitleEmpty = !(widget.outOfCourse) && !(!widget.detailed && description != null && description!.isNotEmpty);
    Widget? subtitleW = Column(
      children: [
        if (widget.outOfCourse)
          Text(
            courseName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        if (!widget.detailed && description != null && description!.isNotEmpty)
          Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Html(
                data: description!,
                onLinkTap: (url, attributes, element) {
                  launchUrl(
                    Uri.parse(url!),
                    mode: LaunchMode.externalApplication,
                  );
                },
                doNotRenderTheseTags: const {"br"},
                extensions: const [
                  TableHtmlExtension(),
                ],
                style: {
                  "html": Style(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                },
              )),
      ],
    );

    Widget? progressW = (progress != null && progress! > 0)
        ? LinearProgressIndicator(
            value: progress,
            minHeight: 2,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          )
        : null;

    Widget leadingW = Row(mainAxisSize: MainAxisSize.min, children: [
      if (icon != null)
        SizedBox(
          height: 48,
          width: 24,
          child: Center(
            child: Icon(icon, color: mainColour, size: 24),
          ),
        ),
      if (playable)
        SizedBox(
          height: 48,
          width: 24,
          child: Center(
              child: Icon(
            Ionicons.play,
            color: mainColour,
            size: 24,
          )),
        ),
    ]);

    Widget trailingW = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (expandable)
          SizedBox(
            height: 48,
            width: 48,
            child: Center(
                child: IconButton(
              icon: const Icon(Ionicons.open_outline),
              onPressed: onTap,
            )),
          ),
        if (downloadable && download == null)
          SizedBox(
            height: 48,
            width: 48,
            child: Center(
                child: IconButton(
                    icon: const Icon(Ionicons.download_outline),
                    onPressed: () async {
                      widget.api.downloadModule(widget.moduleId);
                      await updateLastUsed();
                      await Future.delayed(const Duration(milliseconds: 100));
                      setState(() {
                        download = 0.0;
                      });
                    })),
          )
        else if (downloadable && download != 1.0)
          SizedBox(
            height: 48,
            width: 48,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: download),
                      duration: const Duration(milliseconds: 500),
                      builder: (BuildContext context, double progress, Widget? child) {
                        return CircularProgressIndicator(
                          value: progress == 0.0 ? null : progress,
                          color: mainColour,
                        );
                      }),
                  IconButton(
                      icon: Icon(
                        Ionicons.stop,
                        size: 16,
                        color: mainColour,
                      ),
                      onPressed: () {
                        widget.api.cancelDownloadModule(widget.moduleId);
                        deleteDownload();
                      }),
                ],
              ),
            ),
          )
        else if (downloadable && download == 1.0)
          SizedBox(
            height: 48,
            width: 48,
            child: IconButton(
                icon: const Icon(Icons.download_done_rounded),
                onPressed: () async {
                  await deleteButAskDownload(context);
                }),
          ),
        if (hasFavoriteButton)
          IconButton(
              onPressed: () {
                widget.isar.modules.get(widget.moduleId).then((module) => widget.isar.writeTxn(() async {
                      if (module != null) {
                        widget.isar.modules.put(module
                          ..favoritedSince = (module.favoritedSince != null ? null : DateTime.now())
                          ..lastUsed = DateTime.now());
                      }
                    }));
              },
              icon: Icon(favorite ? Icons.star_rounded : Icons.star_border_rounded),
              iconSize: 28),
      ],
    );

    if (expandable) {
      return GestureDetector(
        onLongPress: showOptions,
        child: ExpansionTile(
          key: PageStorageKey(widget.moduleId.toString()),
          title: titleW,
          subtitle: subtitleW,
          //TODO to get more space: tilePadding: EdgeInsets.zero,
          shape: const Border(),
          trailing: trailingW,
          initiallyExpanded: false,
          maintainState: false,
          controlAffinity: ListTileControlAffinity.leading,
          iconColor: Theme.of(context).colorScheme.onSurface,
          children: [
            for (Module submodule in (submodules..sort((a, b) => a.index - b.index)))
              ModuleTile(
                key: Key(submodule.id.toString()),
                moduleId: submodule.id,
                isar: widget.isar,
                api: widget.api,
              ),
          ],
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          updateLastUsed();
          onTap?.call();
        },
        onLongPress: showOptions,
        child: SizedBox(
          width: widget.detailed ? MediaQuery.of(context).size.width / 2.4 : null,
          child: Column(
            children: [
              if (widget.detailed)
                ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Stack(
                        children: [
                          Material(
                            child: Ink(
                                color: Colors.black,
                                child: const Center(
                                    child: Icon(
                                  Ionicons.play,
                                  color: Colors.white,
                                  size: 48,
                                ))),
                          ),
                          if (preview != null) AspectRatio(aspectRatio: 16 / 9, child: Image.file(File(preview!), fit: BoxFit.cover)),
                          if (progressW != null) Align(alignment: Alignment.bottomCenter, child: progressW),
                        ],
                      ),
                    )),
              ListTile(
                title: titleW,
                subtitle: subtitleEmpty ? null : subtitleW,
                contentPadding: widget.detailed ? const EdgeInsets.all(0) : null,
                leading: widget.detailed ? null : leadingW,
                trailing: widget.detailed ? null : trailingW,
                titleTextStyle: widget.detailed ? Theme.of(context).textTheme.titleSmall : null,
                // subtitleTextStyle: widget.detailed ? Theme.of(context).textTheme.titleSmall : null,
              ),
              if (widget.transcriptHighlights != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        searchExpanded = !searchExpanded;
                      });
                    },
                    child: SizedBox(
                      width: double.infinity,
                      child: Card(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(text: widget.transcriptHighlights!, maxLines: searchExpanded ? 100 : 4),
                      )),
                    ),
                  ),
                ),
              if (!widget.detailed)
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: progressW ??
                        const Divider(
                          height: 1,
                        )),
            ],
          ),
        ),
      );
    }
  }

  Future<void> deleteButAskDownload(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    bool aksBeforeDeleteDownload = prefs.getBool("aksBeforeDeleteDownload${type.name}") ?? true;
    if (aksBeforeDeleteDownload) {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              icon: const Icon(Icons.delete_outline_rounded),
              title: const Text("Download löschen?"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Der Download wird gelöscht und muss erneut heruntergeladen werden."),
                  GestureDetector(
                    child: Text(
                      "Bei diesem Dateityp nicht erneut nachfragen",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onTap: () {
                      deleteDownload();
                      Navigator.of(context).pop();
                      prefs.setBool("aksBeforeDeleteDownload${type.name}", false);
                    },
                  )
                ],
              ),
              actions: [
                TextButton(
                    style: TextButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primaryContainer),
                    onPressed: () {
                      deleteDownload();
                      Navigator.of(context).pop();
                    },
                    child: const Text("Löschen")),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Abbrechen"))
              ],
            );
          });
    } else {
      deleteDownload();
    }
  }
}
