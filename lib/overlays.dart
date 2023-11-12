import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:better_player/better_player.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:export_video_frame/export_video_frame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:isar/isar.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uni_stream/utils.dart';
import 'package:uni_stream/video_api.dart';

import 'database.dart';


//Media
class MediaNotification extends Notification {
  final Module module;

  const MediaNotification({
    required this.module,
  });
}

//TODO notification, pip, custom controls
class MiniPlayerContainer extends StatefulWidget {
  const MiniPlayerContainer({Key? key, required this.child, required this.videoDistributor, required this.isar}) : super(key: key);

  final Widget child;
  final VideoDistributor videoDistributor;
  final Isar isar;

  @override
  State<MiniPlayerContainer> createState() => _MiniPlayerContainerState();
}

class _MiniPlayerContainerState extends State<MiniPlayerContainer> {

  late ValueNotifier<double> valueNotifier = ValueNotifier(minHeight);
  late double bottomPadding = maxBottomPadding;
  double maxBottomPadding = 50;
  double minHeight = 60;

  late final BetterPlayerController _controller;
  bool showControls = false;

  String title = "";
  String course = "";

  bool initialized = false;
  bool visible = false;
  bool bottomModal = false;
  bool isDataSourceLoading = false;

  int currentModule = 0;

  @override
  void initState() {
    super.initState();
    valueNotifier.addListener(onHeightChanged);

    _controller = BetterPlayerController(getConfiguration());
    _controller.setControlsEnabled(false);
    _controller.addEventsListener((event) {
      if(event.betterPlayerEventType == BetterPlayerEventType.progress) {
        if(event.parameters?['progress'] != null && event.parameters?['duration'] != null) {
          widget.isar.writeTxn(() async {
          Module? module = await widget.isar.modules.get(currentModule);
          if (module != null) {
            Duration progress = event.parameters!['progress'];
            Duration duration = event.parameters!['duration'];
            module.progress = progress.inMilliseconds / duration.inMilliseconds;
            widget.isar.modules.put(module);
          }
        });
        }
      }
      else if(event.betterPlayerEventType == BetterPlayerEventType.pause) {
        saveThumbnail();
      }
    });
    initialized = true;

    //test
    // visible = true;
    // _controller.setupDataSource(BetterPlayerDataSource(BetterPlayerDataSourceType.network, "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4"));
  }

  @override
  void dispose() {
    super.dispose();
    valueNotifier.removeListener(onHeightChanged);
    _controller.pause();
    _controller.dispose();
  }

  //TODO wrap video in custom controls in interactive viewer
  BetterPlayerConfiguration getConfiguration() => BetterPlayerConfiguration(
      fit: BoxFit.contain,
      autoDispose: false,
      playerVisibilityChangedBehavior: (visibilityFraction) {},
      controlsConfiguration: const BetterPlayerControlsConfiguration(
        // playerTheme: BetterPlayerTheme.material, //set to custom to use custom controls
        enablePlayPause: false,
        // customControlsBuilder: (controller, onPlayerVisibilityChanged) {
        //   return Center(
        //     child: IconButton(
        //       icon: Icon(Icons.play_arrow, size: 50, color: Colors.white),
        //       onPressed: () {
        //         bool isPlaying = (_controller.betterPlayerDataSource != null) && (_controller.isPlaying() ?? false);
        //         if (isPlaying)
        //           _controller.pause();
        //         else
        //           _controller.play();
        //       },
        //     ),
        //   );
        // },
      ));

  void onHeightChanged() {
    double height = valueNotifier.value;
    double extraHeight = height - minHeight;
    double bottomExpansion = extraHeight * 0.15;
    setState(() {
      bottomPadding = bottomExpansion > maxBottomPadding ? 0 : maxBottomPadding - (bottomExpansion);
    });

    bool shouldShowControls = height > 0.9 * MediaQuery.of(context).size.height;
    if (showControls != shouldShowControls) {
      showControls = shouldShowControls;
      _controller.setControlsEnabled(showControls);
    }
  }

  Future<void> updateDataSource(Module module) async {
    if(currentModule == module.id && visible) return;
    setState(() {
      visible = true;
      isDataSourceLoading = true;
      if(_controller.betterPlayerDataSource != null) _controller.pause();
      currentModule = module.id;
      title = module.title;
      module.course.loadSync();
      course = module.course.value?.nameVariations[0] ?? "";
    });
    BetterPlayerDataSource? betterPlayerDataSource = await widget.videoDistributor.getDataSource(module);
    if(currentModule != module.id) return;
    if (betterPlayerDataSource != null) {
      await _controller.setupDataSource(betterPlayerDataSource);
      await _controller.seekTo(Duration(milliseconds: ((module.progress ?? 0) * (_controller.videoPlayerController?.value.duration?.inMilliseconds ?? 0)).toInt()));
      if(visible) _controller.play();
      isDataSourceLoading = false;
    } else {
      visible = false;
      isDataSourceLoading = false;
      module.course.loadSync();
      module.course.value?.universityAccount.loadSync();
      handleContentApiException(
          cAE: ApiException(msgToUser: "Couldn't load Video", toBeLogged: "datasource is null in updateDataSource for url ${module.url}"),
          st: StackTrace.current,
          uAcc: module.course.value?.universityAccount.value);
    }
    setState(() {});
  }

  //TODO rewrite to use video thumbnail when it works again and then also store preview for network videos
  Future<void> saveThumbnail() async {
    BetterPlayerDataSource? betterPlayerDataSource = _controller.betterPlayerDataSource;
    int position = _controller.videoPlayerController?.value.position.inMilliseconds ?? 0;
    Duration positioninS = _controller.videoPlayerController?.value.position ?? const Duration(seconds:  0);
    if(betterPlayerDataSource == null) return;
    String basePath = "${(await getApplicationSupportDirectory()).path}/thumbnails/";

    if(betterPlayerDataSource.type != BetterPlayerDataSourceType.file) return;

      File image = await ExportVideoFrame.exportImageBySeconds(File(betterPlayerDataSource.url), positioninS, 0);
      String path = image.path;


    // final String? fileName = await VideoThumbnail.thumbnailFile(
    //   video: betterPlayerDataSource.url,
    //   thumbnailPath: basePath,
    //   imageFormat: ImageFormat.JPEG,
    //   maxHeight: 256,
    //   quality: 25,
    //   headers: betterPlayerDataSource.headers,
    //   //timeMs: position,
    // );
    // if(fileName == null) return;
    await widget.isar.writeTxn(() async {
      Module? module = await widget.isar.modules.get(currentModule);
      if (module != null) {
        module.previewFilepath = path;
        widget.isar.modules.put(module);
      }
    });
    return;


    //Future<void> saveThumbnail() async {
    //     BetterPlayerDataSource? betterPlayerDataSource = _controller.betterPlayerDataSource;
    //     int position = _controller.videoPlayerController?.value.position.inMilliseconds ?? 0;
    //     if(betterPlayerDataSource == null) return;
    //     String path = "${(await getApplicationSupportDirectory()).path}/thumbnails/${betterPlayerDataSource.url.hashCode}/";
    //     print("path: $path");
    //     final Uint8List? thumbnailData = await VideoThumbnail.thumbnailData(
    //       video: betterPlayerDataSource.url,
    //       imageFormat: ImageFormat.JPEG,
    //       maxHeight: 256,
    //       quality: 25,
    //       headers: betterPlayerDataSource.headers,
    //       timeMs: position,
    //     );
    //     if(thumbnailData == null) return;
    //     File file = File(path);
    //     await file.writeAsBytes(thumbnailData);
    //     await widget.isar.writeTxn(() async {
    //       Module? module = await widget.isar.modules.get(currentModule);
    //       if (module != null) {
    //         module.previewFilepath = path;
    //         widget.isar.modules.put(module);
    //       }
    //     });
    //     return;
    //   }
  }


  @override
  Widget build(BuildContext context) {
    if (!initialized) return const CircularProgressIndicator();
    return Stack(
      children: [
        NotificationListener<LoadingNotification>(
          onNotification: (notification) {
            if (notification.setCurrentSite) {
              if(notification.site.toString() == "[<'bottomModal'>]") {
                bottomModal = true;
              } else {
                bottomModal = false;
              }
              setState(() {});
            }
            return true;
          },
          child: NotificationListener<MediaNotification>(
            child: widget.child,
            onNotification: (notification) {
              updateDataSource(notification.module);
              return true;
            },
          ),
        ),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: (visible && !bottomModal) ? 1 : 0,
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 300),
            offset: Offset(0, ((visible && !bottomModal)) ? 0 : 0.2),
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomPadding),
              child: ClipRect(
                clipper: SameSizeClip(),
                child: Miniplayer(
                  minHeight: minHeight,
                  maxHeight: MediaQuery.of(context).size.height,
                  builder: (height, percentage) {
                    double aspectRatio = max((_controller.videoPlayerController?.value.aspectRatio ?? 16 / 9), 16/9);

                    MediaQueryData mediaquery = MediaQuery.of(context);
                    Size size = mediaquery.size;
                    EdgeInsets viewInsets = mediaquery.viewInsets;
                    EdgeInsets viewPadding = mediaquery.viewPadding;
                    double topSafe = viewInsets.top + viewPadding.top;
                    double bottomSafe = viewInsets.bottom + viewPadding.bottom;

                    double currentMaxPlayerWidth = height * aspectRatio;
                    double maxPlayerHeight = size.width / aspectRatio;

                    bool isPlaying = (_controller.betterPlayerDataSource != null) && (_controller.isPlaying() ?? false);
                    return Padding(
                      padding: EdgeInsets.only(top: topSafe * (max(percentage - 0.9, 0) * 10), bottom: bottomSafe * (max(percentage - 0.9, 0) * 10)),
                      child: Container(
                        height: height,
                        color: Theme.of(context).colorScheme.surface,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              constraints: BoxConstraints(maxHeight: maxPlayerHeight),
                              color: Theme.of(context).colorScheme.surfaceVariant,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  ConstrainedBox(
                                    constraints: BoxConstraints(maxHeight: height, maxWidth: min(currentMaxPlayerWidth, size.width)),
                                    child: isDataSourceLoading
                                        ? AspectRatio(
                                        aspectRatio: aspectRatio,
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                              alignment: Alignment.center,
                                              color: Colors.black,
                                              child: const SizedBox(
                                                height: 30,
                                                width: 30,
                                                child: CircularProgressIndicator(
                                                  color: Colors.white,
                                                ),
                                              )),
                                        ))
                                        : BetterPlayer(
                                      controller: _controller,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 12.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            title,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: const TextStyle(fontSize: 15),
                                          ),
                                          //TODO add page name
                                          Text(
                                            course,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      width: max(0, min(48, (size.width - currentMaxPlayerWidth))),
                                      child: IconButton(
                                          onPressed: () {
                                            if(_controller.betterPlayerDataSource != null) {
                                              if (isPlaying)
                                                _controller.pause();
                                              else
                                                _controller.play();
                                            }
                                            setState(() {});
                                          },
                                          icon: Icon(isPlaying ? Ionicons.pause : Ionicons.play))),
                                  SizedBox(
                                      width: max(0, min(48, (size.width - currentMaxPlayerWidth - 48))),
                                      child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (_controller.betterPlayerDataSource != null && isPlaying) {
                                              _controller.pause();
                                              }
                                              visible = false;
                                            });
                                          },
                                          icon: const Icon(Ionicons.close))),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: SizedBox(
                                height: max(0, height - maxPlayerHeight - topSafe - bottomSafe),
                                width: size.width,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 12.0),
                                          child: Text(
                                            title,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: const TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        Text(
                                          course,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  valueNotifier: valueNotifier,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SameSizeClip extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width, size.height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return false;
  }
}

//Loading

enum Loading { done, failed, loading }

class LoadingNotification extends Notification {
  final Loading? loading;
  final Key site;
  final bool setCurrentSite;

  const LoadingNotification({
    required this.site,
    this.setCurrentSite = false,
    this.loading,
  });
}

class LoadingStatus extends StatefulWidget {
  const LoadingStatus({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  State<LoadingStatus> createState() => _LoadingStatusState();
}

class _LoadingStatusState extends State<LoadingStatus> {
  late StreamSubscription subscription;
  Map<Key, Map<String, dynamic>> statusPerSite = <Key, Map<String, dynamic>>{};

  ConnectivityResult connectivity = ConnectivityResult.none;
  //bool _longLoading = false;
  //Timer? _longLoader;
  Key? _currentSite;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
        setState(() {
          connectivity = result;
        });
      });
    });
  }

  @override
  dispose() {
    super.dispose();
    subscription.cancel();
  }

  void update(Key key, Loading loading) {
    statusPerSite.update(key, (value) => {"loading": loading, "lastUpdated": DateTime.now()}, ifAbsent: () => {"loading": loading, "lastUpdated": DateTime.now()});
    // if (key == _currentSite) {
    //   _longLoader?.cancel();
    //   _longLoading = false;
    //   if (loading) {
    //     _longLoader = Timer(const Duration(seconds: 5), () {
    //       _longLoading = true;
    //     });
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    Loading loading = statusPerSite[_currentSite]?["loading"] ?? Loading.done;
    bool connected = (connectivity == ConnectivityResult.mobile || connectivity == ConnectivityResult.wifi);
    return Stack(
      children: [
        NotificationListener<LoadingNotification>(
          child: widget.child,
          onNotification: (notification) {
            if (kDebugMode) print("${notification.site}: ${notification.loading}");
            setState(() {
              if (notification.setCurrentSite) _currentSite = notification.site;
              if (notification.loading != null) update(notification.site, notification.loading!);
            });
            return false;
          },
        ),
        if(!["[<'Home'>]", "[<'Settings'>]", "[<'bottomModal'>]", "[<'search'>]"].contains(_currentSite.toString())) SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8),
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: const BorderRadius.all(Radius.circular(32.0)), boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 2.0,
                    spreadRadius: 0.0,
                    offset: Offset(2.0, 2.0), // shadow direction: bottom right
                  )
                ]),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: connected
                            ? [
                          // if (_longLoading) Icon(Icons.alarm),
                          if (loading == Loading.loading) const CupertinoActivityIndicator(),
                          if (loading == Loading.done) const Icon(Icons.check),
                          if (loading == Loading.failed) const Icon(Icons.close)
                        ]
                            : [const Icon(Ionicons.cloud_offline_outline)],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        // if(false) SafeArea(child: Align(alignment:Alignment.topCenter,child: Material(child: Text(_currentSite.toString())))),
      ],
    );
  }
}