import 'dart:convert';

import 'package:better_player/better_player.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isar/isar.dart';
import 'package:uni_stream/utils.dart';

import 'content_api.dart';
import 'database.dart';

abstract class VideoApi {
  Future<void> init(Map<String, String> credentials);
  Future<(String name, BetterPlayerDataSource dataSource)> getVideoInformation(String url, int courseId);
}

class VideoHandler {
  final Isar isar;
  final UniversityAccount? universityAccount;
  final VideoApiAccount apiAccount;
  late final VideoApi videoApi;

  bool _initialized = false;

  VideoHandler(this.isar, this.universityAccount, this.apiAccount, FlutterSecureStorage securePrefs) {
    videoApi = apiAccount.type.videoApiFactory();
    String videoApiKey = getVideoApiKey(universityAccount, apiAccount);
    securePrefs.read(key: videoApiKey).then((value) {
      _asyncInit((jsonDecode(value ?? "{}") as Map<String, dynamic>).map((key, value) => MapEntry(key, value.toString())));
    }, onError: (_) {
      showLongToast("Error while connecting to VideoProvider ${apiAccount.type.name}");
      logException("Couldnt read credentials from securePrefs for videoApi $videoApiKey", universityAccount);
    });
  }

  void _asyncInit(Map<String, String> credentials) async {
    //TODO retry
    await _waitForConnection();
    try {
      await videoApi.init(credentials);
      _initialized = true;
    } on ApiException catch (e, st) {
      handleContentApiException(cAE: e, st: st, uAcc: universityAccount);
    } on Exception catch (e, st) {
      handleContentApiException(cAE: ApiException(msgToUser: "Couldn't connect to ${apiAccount.type.name}", toBeLogged: e.toString()), st: st, uAcc: universityAccount);
    }
  }

  Future<(String name, BetterPlayerDataSource dataSource)?> getVideoInformation(Module module, {Course? moduleCourse, required UniversityAccount moduleUniversityAccount}) async {
    if(moduleCourse == null){
      module.course.loadSync();
      moduleCourse = module.course.value;
    }
    if (module.url != null && moduleCourse != null && (universityAccount == null || moduleUniversityAccount.id == universityAccount?.id)) {
      await _waitForInit();
      await _waitForConnection();
      return videoApi.getVideoInformation(module.url!, moduleCourse.universityId);
    } else {
      showLongToast("Error while connecting to VideoProvider ${apiAccount.type.name}");
      logException("Couldnt load Datasource for videoApi ${apiAccount.type.name}${apiAccount.id} for url ${module.url}", universityAccount);
      return null;
    }
  }

  Future<void> _waitForInit() async {
    //wait for init to finish
    if (!_initialized) {
      await Future.doWhile(() => Future.delayed(const Duration(milliseconds: 100)).then((_) => !_initialized));
    }
    return;
  }

  Future<void> _waitForConnection() async {
    //wait for connection
    ConnectivityResult connectivity = await Connectivity().checkConnectivity();
    if (connectivity != ConnectivityResult.mobile && connectivity != ConnectivityResult.wifi) {
      await Future.doWhile(() async {
        ConnectivityResult connectivity = await Connectivity().onConnectivityChanged.first;
        return connectivity != ConnectivityResult.mobile && connectivity != ConnectivityResult.wifi;
      });
    }
    return;
  }
}

class VideoDistributor {
  final Isar isar;
  final FlutterSecureStorage securePrefs;
  final List<VideoHandler> videoHandlers = List.empty(growable: true);
  final List<ContentHandler> contentHandlers = List.empty(growable: true);

  final Key key = UniqueKey();

  VideoDistributor(this.isar, this.securePrefs);

  void init() {
    videoHandlers.clear();
    for (VideoApiAccount apiAccount in isar.videoApiAccounts.where().findAllSync()) {
      apiAccount.universityAccount.loadSync();
      videoHandlers.add(VideoHandler(isar, apiAccount.universityAccount.value, apiAccount, securePrefs));
    }
  }

  updateApis(List<ContentHandler> contentHandlers){
    init();
    this.contentHandlers.clear();
    this.contentHandlers.addAll(contentHandlers);
  }

  Future<BetterPlayerDataSource?> getDataSource(Module module, {bool ignoreDownload = false, bool sortResolutions = true}) async {
    module.course.loadSync();
    module.course.value?.universityAccount.loadSync();
    if (module.download == 1.0 && !ignoreDownload) {
      return BetterPlayerDataSource.file(module.filepath!); //, subtitles: module.videoSource != null ? module.videoSource!.subtitles : null);
    }
    // else if(module.videoSources != null) return module.videoSource; TODO add way to store subtitles and urls
    else if (module.url != null && module.course.value != null && module.course.value?.universityAccount.value != null) {
      if(Uri.parse(module.url!).pathSegments.last.endsWith(".mp4")){
        UniversityAccount universityAccount = module.course.value!.universityAccount.value!;
        try {
          ContentHandler contentHandler = contentHandlers.firstWhere((element) => element.universityAccount.id == universityAccount.id);
          final (headers, queryParameters) = await contentHandler.getHeadersAndQueryParametersForUrl(module.url!);
          Uri uri = Uri.parse(module.url!);
          uri = uri.replace(queryParameters: <String, String>{}..addAll(queryParameters!)..addAll(uri.queryParameters));
          return BetterPlayerDataSource.network(uri.toString(), headers: headers);
        }
        catch(e, st){
          logException("Couldn't find ContentHandler for video ${module.url}: $e, $st", universityAccount);
        }
      }
      List<VideoHandler> allVideoHandlers = getVideoHandlersForUrl(module, module.course.value!.universityAccount.value!);
      for (VideoHandler videoHandler in allVideoHandlers) {
        BetterPlayerDataSource? dataSource = (await videoHandler.getVideoInformation(module, moduleUniversityAccount: module.course.value!.universityAccount.value!))?.$2;
        if (dataSource != null) {
          // isar.writeTxnSync((){
          //   Module? newModule = isar.modules.getSync(module.id);
          //   if(newModule != null) {
          //     newModule.videoSources = jsonEncode(dataSource?.resolutions);
          //     isar.modules.putSync(newModule);
          //   }
          // });
          if (sortResolutions) dataSource = sortDataSourceResolutions(dataSource);
          return dataSource;
        }
      }
    }
    handleContentApiException(
        cAE: ApiException(msgToUser: 'No VideoProvider found to play video', toBeLogged: 'No VideoProvider found to play video ofr url ${module.url}'),
        uAcc: module.course.value?.universityAccount.value);
    return null;
  }

  Future<String?> getVideoName(Module module, {Course? moduleCourse, UniversityAccount? universityAccount}) async {
    if (universityAccount == null) {
      module.course.loadSync();
      module.course.value?.universityAccount.loadSync();
      universityAccount = module.course.value?.universityAccount.value;
    }
    if (module.url != null && universityAccount != null) {
      List<VideoHandler> allVideoHandlers = getVideoHandlersForUrl(module, universityAccount);
      for (VideoHandler videoHandler in allVideoHandlers) {
        String? videoName = (await videoHandler.getVideoInformation(module, moduleCourse: moduleCourse, moduleUniversityAccount: universityAccount))?.$1;
        if (videoName != null) return videoName.trim();
      }
    }
    logException("No VideoProvider found to get Name for module ${module.id} with url ${module.url}", universityAccount);
    return null;
  }

  List<VideoHandler> getVideoHandlersForUrl(Module module, UniversityAccount universityAccount) {
    List<VideoHandler> universityVideoHandler = List.empty(growable: true);
    List<VideoHandler> nonUniversityVideoHandler = List.empty(growable: true);
    for (VideoHandler videoHandler in videoHandlers.where((videoHandler) => videoHandler.apiAccount.type.urls.any((url) => module.url!.startsWith(url)))) {
      int moduleUniId = universityAccount.id;
      if (videoHandler.universityAccount?.id == moduleUniId) {
        universityVideoHandler.add(videoHandler);
      } else if (videoHandler.universityAccount == null) {
        nonUniversityVideoHandler.add(videoHandler);
      }
    }
    if (universityVideoHandler.isEmpty && nonUniversityVideoHandler.isEmpty) logException("no videohandlers found for url ${module.url}", universityAccount);
    List<VideoHandler> allVideoHandlers = universityVideoHandler..addAll(nonUniversityVideoHandler);
    return allVideoHandlers;
  }

  BetterPlayerDataSource sortDataSourceResolutions(BetterPlayerDataSource dataSource) {
    Map<String, String>? resolutions = dataSource.resolutions;
    if (resolutions == null || resolutions.isEmpty) return dataSource;

    if (resolutions["HLS"] != null && resolutions["HLS"]!.isNotEmpty) {
      return BetterPlayerDataSource(BetterPlayerDataSourceType.network, resolutions["HLS"]!);
    } else {
      String? highestResolutionUrl = resolutions[sortResolutions(resolutions).last];
      if (highestResolutionUrl == null) return dataSource;
      return BetterPlayerDataSource(BetterPlayerDataSourceType.network, highestResolutionUrl, resolutions: resolutions);
    }
  }

  List<String> sortResolutions(Map<String, String> resolutions) {
    return resolutions.keys.toList()
      ..sort((a, b) {
        int? aInt = int.tryParse(a.substring(0, a.length - 1));
        int? bInt = int.tryParse(b.substring(0, b.length - 1));
        return bInt != null ? aInt?.compareTo(bInt) ?? -1 : 1;
      });
  }

  Future<String?> getVideoDownloadUrl(Module module) async {
    if (module.type != ModuleType.video) return null;
    BetterPlayerDataSource? dataSource = await getDataSource(module, ignoreDownload: true, sortResolutions: false);
    if (dataSource != null) {
      if (dataSource.resolutions != null && dataSource.resolutions!.isNotEmpty) {
        String? highestResolutionUrl = dataSource.resolutions![sortResolutions(dataSource.resolutions!).last];
        if (highestResolutionUrl != null) {
          return highestResolutionUrl;
        } else {
          handleContentApiException(
              cAE: ApiException(msgToUser: "Video konnte nicht heruntergeladen werden", toBeLogged: "highestResolution null or invalid, no resolution with p seemingly ${dataSource.resolutions}"),
              st: StackTrace.current);
        }
      } else {
        if (Uri.parse(dataSource.url).pathSegments.last.endsWith(".mp4")) {
          log(msg: "No resolutions found for video ${module.title} ${module.id}", lvl: ExceptionLevel.warn);
          return dataSource.url;
        } else {
          handleContentApiException(
              cAE: ApiException(
                  msgToUser: "Video konnte nicht heruntergeladen werden", toBeLogged: "No resolutions found and url is non mp4 but ${dataSource.url} for video ${module.title} ${module.id}"),
              st: StackTrace.current);
        }
      }
    } else {
      handleContentApiException(cAE: const ApiException(msgToUser: "Video konnte nicht heruntergeladen werden", toBeLogged: "dataSource == null"), st: StackTrace.current);
    }
    return null;
  }
}
