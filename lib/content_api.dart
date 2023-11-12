import 'dart:convert';

import 'package:background_downloader/background_downloader.dart';
import 'package:better_player/better_player.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_stream/utils.dart';
import 'package:uni_stream/video_api.dart';

import 'database.dart';

class ApiCourse {
  ApiCourse({required this.id, required this.nameVariations, this.hidden, this.lastAccess});

  final int id;

  List<String> nameVariations; //first one will be default
  bool? hidden; //null if no information
  DateTime? lastAccess; //null if no information
  //int category;
}

class ApiModule {
  ApiModule({
    this.id,
    required this.section,
    required this.index,
    required this.type,
    required this.title,
    this.description,
    this.url,
    this.submodules,
  });

  //id should be non null when not submodules
  final int? id;
  final int section;
  final int index;

  ModuleType type;
  final String title;
  String? description;

  String? url;

  //Should be null or empty when already submodule
  List<ApiModule>? submodules;
}

abstract class ContentApi {
  abstract List<(VideoApiType, List<String> credentialKeys)> connectedVideoApis;
  Future<void> init(Map<String, String> credentials);
  Widget buildLoginPage(void Function(String, String) setCredentialValue);
  Future<Map<String, String>> transformCredentials(Map<String, String> inputtedCredentials);
  Future<String> getUserIdentifier();
  Future<List<ApiCourse>> getCourses();
  Future<bool> setCourseVisibility(int courseId, bool hidden);
  Future<(List<String>, List<ApiModule>)> getSectionNamesAndCourseModules(int courseId);
  Future<(Map<String, String>?, Map<String, String>?)> getHeadersAndQueryParametersForUrl(String url);
}

class ContentHandler {
  final Isar isar;
  final UniversityAccount universityAccount;
  final ContentApi contentApi;
  final VideoDistributor videoDistributor;

  bool _initialized = false;

  ContentHandler(this.isar, this.universityAccount, this.contentApi, FlutterSecureStorage securePrefs, this.videoDistributor) {
    securePrefs.read(key: getContentApiKey(universityAccount)).then((value) {
      _asyncInit((jsonDecode(value ?? "{}") as Map<String, dynamic>).map((key, value) => MapEntry(key, value.toString())));
    }, onError: (_) {
      showLongToast("Error with ${universityAccount.university.name}: ${universityAccount.userIdentifier}, please remove account and log in again");
      logException("Couldnt read credentials from securePrefs", universityAccount);
    });
  }

  // ContentHandler.fromCredentials(this.isar, this.universityAccount, this.contentApi, Map<String, String> credentials) {
  //   _asyncInit(credentials);
  // }

  void _asyncInit(Map<String, String> credentials) async {
    //TODO retry
    await _waitForConnection();
    try {
      await contentApi.init(credentials);
      _initialized = true;
    } on ApiException catch (e, st) {
      handleContentApiException(cAE: e, st: st, uAcc: universityAccount);
    } on Exception catch (e, st) {
      handleContentApiException(
          cAE: ApiException(msgToUser: "Couldn't connect to ${universityAccount.university.name}: ${universityAccount.userIdentifier}", toBeLogged: e.toString()), st: st, uAcc: universityAccount);
    }
  }

  Future<void> updateCourses() async {
    await _waitForInit();
    await _waitForConnection();


    try {
      //call download TODO  retry after fail - what to to after any fails -> send failed loading notification and give option to retry
      List<ApiCourse> courses = await contentApi.getCourses();

      //update isar
      List<Course> existingCourses = await isar.courses.filter().universityAccount((q) => q.idEqualTo(universityAccount.id)).findAll();
      List<int> newCourseUniversityIDs = courses.map((e) => e.id).toList();
      List<int> existingCourseUniversityIDs = existingCourses.map((e) => e.universityId).toList();

      List<int> toDelete = existingCourseUniversityIDs.toSet().difference(newCourseUniversityIDs.toSet()).toList();
      List<int> toAdd = newCourseUniversityIDs.toSet().difference(existingCourseUniversityIDs.toSet()).toList();

      await isar.writeTxn(() async {
        for (int id in toDelete) {
          await isar.courses.filter().universityIdEqualTo(id).deleteAll();
        }
        for (ApiCourse course in courses) {
          if (toAdd.contains(course.id)) {
            Course isarCourse = Course.fromApiCourse(course, universityAccount);
            await isar.courses.put(isarCourse);
            await isarCourse.universityAccount.save();
          } else {
            Iterable<Course> matchingCourses = existingCourses.where((element) => element.universityId == course.id);
            if (matchingCourses.isEmpty) {
              throw ApiException(msgToUser: "Unexpexted error while processing one of the downloaded courses from ${universityAccount.university.name}", toBeLogged: "matchingCourses is Empty");
            } else if (matchingCourses.length > 1) {
              throw ApiException(msgToUser: "Unexpexted error while processing one of the downloaded courses from ${universityAccount.university.name}", toBeLogged: "matchingCourses.length > 1");
            } else {
              Course existingCourse = matchingCourses.first;

              existingCourse.hidden = course.hidden ?? existingCourse.hidden;
              existingCourse.nameVariations = course.nameVariations.toSet().toList();
              existingCourse.lastUpdate = DateTime.now();
              existingCourse.lastAccess = existingCourse.lastAccess.isAfter(course.lastAccess ?? DateTime(0)) ? existingCourse.lastAccess : (course.lastAccess ?? DateTime(0));

              await isar.courses.put(existingCourse);
            }
          }
        }
      });
    } on ApiException catch (e, st) {
      handleContentApiException(cAE: e, st: st, uAcc: universityAccount);
    } on Exception catch (e, st) {
      handleContentApiException(
          cAE: ApiException(msgToUser: "Couldn't retrieve courses for ${universityAccount.university.name}: ${universityAccount.userIdentifier}", toBeLogged: e.toString()),
          st: st,
          uAcc: universityAccount);
    }
  }

  Future<void> updateCourseModules(int courseId) async {
    await _waitForInit();
    await _waitForConnection();

    Course? course = await isar.courses.get(courseId);

    if (course == null) {
      handleContentApiException(
          cAE: ApiException(
              msgToUser: "Couldn't retrieve course data for non exisiting course in ${universityAccount.university.name}:${universityAccount.userIdentifier}",
              toBeLogged: "course == null in updateCourse in ${universityAccount.university.name}:${universityAccount.userIdentifier}"),
          uAcc: universityAccount);
      return;
    }

    try {
      //TODO retry after fail - what to to after any fails?
      final (sectionNames, modules) = await contentApi.getSectionNamesAndCourseModules(course.universityId);
      modules.forEach((element) {if(element.submodules?.length == 1){
        ApiModule submodule = element.submodules!.first;
        element.submodules = null;
        element.type = submodule.type;
        element.url = submodule.url;
        element.description = (element.description ?? "") +  (submodule.description ?? "");
      }
      });

      //update isar
      List<Module> existingModules = await isar.modules.filter().course((q) => q.idEqualTo(course.id)).universityIdIsNotNull().findAll();
      List<int> newModuleUniversityIDs = List.empty(growable: true);
      for (var element in modules) {
        if (element.id == null) {
          logException("newModule id is null", universityAccount);
          modules.remove(element);
        } else {
          newModuleUniversityIDs.add(element.id!);
        }
      }
      List<int> existingModuleUniversityIDs = existingModules.map((e) => e.universityId!).toList();

      List<int> toDelete = existingModuleUniversityIDs.toSet().difference(newModuleUniversityIDs.toSet()).toList();
      List<int> toAdd = newModuleUniversityIDs.toSet().difference(existingModuleUniversityIDs.toSet()).toList();

      //test that modules are the same if they have the same id
      modules.where((module) => !toAdd.contains(module.id)).forEach((module) {
        Module existingModule = existingModules.firstWhere((element) => element.universityId == module.id);
        if (!(module.section == existingModule.section && module.title == existingModule.title && module.type == existingModule.type)) {
          toDelete.add(module.id!);
          toAdd.add(module.id!);
        }
      });

      await isar.writeTxn(() async {
        Course course = (await isar.courses.get(courseId))!;
        isar.courses.put(course..sections = sectionNames);
        for (int id in toDelete) {
          for (var element in (await isar.modules.filter().universityIdEqualTo(id).findAll())) {
            await element.submodules.load();
            isar.modules.deleteAll(element.submodules.map((e) => e.id).toList());
            await element.searchable.load();
            if(element.searchable.value != null) await isar.searchables.delete(element.searchable.value!.id);
          }
          await isar.modules.filter().universityIdEqualTo(id).deleteAll();
        }
        for (ApiModule module in modules) {
          if (toAdd.contains(module.id)) {
            Module isarModule = Module.fromApiModule(module, course);
            await isar.modules.put(isarModule);
            if (module.submodules != null) {
              for (ApiModule submodule in module.submodules!) {
                Module isarSubModule = Module.fromApiModule(submodule, course);
                await isar.modules.put(isarSubModule);
                await isarSubModule.course.save();
                isarModule.submodules.add(isarSubModule);
              }
            }
            await isarModule.course.save();
            await isarModule.submodules.save();
          } else {
            Iterable<Module> matchingModules = existingModules.where((element) => element.universityId == module.id);
            if (matchingModules.isEmpty) {
              throw ApiException(
                  msgToUser: "Unexpexted error while processing one of the downloaded modules from ${universityAccount.university.name}:${course.name}", toBeLogged: "matchingModules is Empty");
            } else if (matchingModules.length > 1) {
              throw ApiException(
                  msgToUser: "Unexpexted error while processing one of the downloaded modules from ${universityAccount.university.name}:${course.name}", toBeLogged: "matchingModules.length > 1");
            } else {
              Module existingModule = matchingModules.first;
              existingModule.index = module.index;
              existingModule.description = module.description;
              if (existingModule.url != module.url) {
                existingModule.url = module.url;
                existingModule.download = null;
                //TODO delete old file
              }
              await existingModule.submodules.load();
              if (existingModule.submodules.isNotEmpty || (module.submodules != null && module.submodules!.isNotEmpty)) {
                List<Module> newSubModules = module.submodules?.map((m) => Module.fromApiModule(m, course)).toList() ?? <Module>[];
                for(Module newSubModule in newSubModules){
                  if(newSubModule.type == ModuleType.video && newSubModule.title.trim().isEmpty){
                    newSubModule.title = (await videoDistributor.getVideoName(newSubModule, moduleCourse: course,universityAccount: universityAccount))!;
                  }
                }
                List<Module> submodulesToBeDeleted = List.empty(growable: true);
                for (Module existingSubModule in existingModule.submodules) {
                  List<Module> matchingNewModules = List.empty(growable: true);
                  await existingSubModule.course.load();
                  for (Module newSubModule in newSubModules) {
                    if (newSubModule.title == existingSubModule.title &&
                        newSubModule.type == existingSubModule.type &&
                        newSubModule.section == existingSubModule.section &&
                        newSubModule.course.value?.id == existingSubModule.course.value?.id) {
                      matchingNewModules.add(newSubModule);
                    }
                  }
                  if (matchingNewModules.isEmpty) {
                    if (kDebugMode) print("deleting submodule ${existingSubModule.title}");
                    submodulesToBeDeleted.add(existingSubModule);
                    await isar.modules.delete(existingSubModule.id);
                  } else {
                    if (matchingNewModules.length > 1) {
                      logException(
                          "While parsing submodules for module ${existingModule.title} found more than one matching submodules\n${matchingNewModules.first.title}${matchingNewModules.first.type}${matchingNewModules.first.index}",
                          universityAccount);
                    }
                    Module matchingNewModule = matchingNewModules.first;
                    matchingNewModules.forEach((matchingModule) => newSubModules.remove(matchingModule));

                    existingSubModule.index = matchingNewModule.index;
                    existingSubModule.description = matchingNewModule.description;
                    if (existingSubModule.url != matchingNewModule.url) {
                      existingSubModule.url = matchingNewModule.url;
                      existingSubModule.download = null;
                      //TODO delete old file
                    }
                    await isar.modules.put(existingSubModule);
                  }
                }
                existingModule.submodules.removeAll(submodulesToBeDeleted);
                await isar.modules.putAll(newSubModules);
                for (var element in newSubModules) {
                  await element.course.save();
                }
                existingModule.submodules.addAll(newSubModules);
              }
              await isar.modules.put(existingModule);
              await existingModule.submodules.save();
            }
          }
        }
      });
    } on ApiException catch (e, st) {
      handleContentApiException(cAE: e, st: st, uAcc: universityAccount);
    } on Exception catch (e, st) {
      handleContentApiException(
          cAE: ApiException(
              msgToUser: "Couldn't retrieve course data for ${universityAccount.university.name}:${universityAccount.userIdentifier}:${course.name ?? "Unnamed Course"}", toBeLogged: e.toString()),
          st: st,
          uAcc: universityAccount);
    }
  }

  Future<(Map<String, String>?, Map<String, String>?)> getHeadersAndQueryParametersForUrl(String url) async {
    await _waitForInit();
    await _waitForConnection();

    return await contentApi.getHeadersAndQueryParametersForUrl(url);
  }

  Map<int, DateTime> lastMobileDataTry = {};
  void downloadModule(int moduleId) async {
    await _waitForInit();
    await _waitForConnection();

    final prefs = await SharedPreferences.getInstance();
    int downloadRetries = prefs.getInt("downloadRetries") ?? 1;

    //0 no download over mobile data, 1: not videos, 2: download everything
    int downloadOverMobileData = prefs.getInt("downloadOverMobileData") ?? 1;

    Module? module = await isar.modules.get(moduleId);

    if (module != null && module.url != null) {
      final (headers, queryParameters) = module.type == ModuleType.video ? (null, null) : await contentApi.getHeadersAndQueryParametersForUrl(module.url!);
      bool requiresWifi = (downloadOverMobileData == 0 || (downloadOverMobileData == 1 && !<ModuleType>[ModuleType.pdf, ModuleType.file].contains(module.type)));
      String url = module.url!;

      if (module.type == ModuleType.video) {
        String? videoUrl = await videoDistributor.getVideoDownloadUrl(module);
        if(videoUrl != null) {
          url = videoUrl;
        } else {
          return;
        }
      }

      final task = await DownloadTask(
        taskId: "module$moduleId",
        updates: Updates.statusAndProgress,
        url: url,
        headers: headers ?? {},
        urlQueryParameters: queryParameters ?? {},
        metaData: moduleId.toString(),
        retries: downloadRetries,
        group: "module",
        requiresWiFi: requiresWifi,
      ).withSuggestedFilename(unique: true);

      FileDownloader().enqueue(task);
      if (requiresWifi && await Connectivity().checkConnectivity() == ConnectivityResult.mobile) {
        String errorMessage = "Download über mobile Daten ist deaktiviert. Siehe Einstellungen.";
        if (prefs.getBool("firstTimeMobileDataDownload") ?? true) {
          prefs.setBool("firstTimeMobileDataDownload", false);
          showLongToast(errorMessage);
        } else if (lastMobileDataTry[moduleId]?.isAfter(DateTime.now().subtract(const Duration(minutes: 5))) ?? false) {
          showLongToast(errorMessage);
        }
        lastMobileDataTry[moduleId] = DateTime.now();
      }

    }
  }

  void cancelDownloadModule(int moduleId) {
    FileDownloader().cancelTaskWithId("module$moduleId");
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

  Future<bool> setCourseVisibility(Course course, bool hidden) async {
    bool success = await contentApi.setCourseVisibility(course.universityId, hidden);
    if (success) {
      await isar.writeTxn(() async {
        await isar.courses.put((await isar.courses.get(course.id))!..hidden = hidden);
      });
    }
    return success;
  }
}
