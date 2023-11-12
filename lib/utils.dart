import 'dart:convert';
import 'dart:io';

import 'package:docx_to_text/docx_to_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_text/pdf_text.dart';
import 'package:uni_stream/tab_logic.dart';

import 'content_api.dart';
import 'database.dart';

class Headline extends StatelessWidget {
  const Headline(this.text, {Key? key, this.fontSize = 30.0}) : super(key: key);

  final String text;
  final double fontSize;

  final bool clean = false;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
      ),
    );
  }
}

class VerticalIconTextButton extends StatelessWidget {
  const VerticalIconTextButton({super.key, required this.icon, required this.text, this.onPressed, this.iconSize = 32});

  final IconData icon;
  final String text;
  final void Function()? onPressed;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: 64,
          height: 112,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                  height: 32,
                  child: ClipRect(
                      child: Icon(
                    icon,
                    size: iconSize,
                    color: color,
                  ))),
              const SizedBox(
                height: 8,
              ),
              Text(
                text,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(color: color),
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showLongToast(String message) {
  Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 2); //TODO add second toast library for desktop
}

// logging: ^1.1.1
void logException(String msg, UniversityAccount? universityAccount) {
  log(lvl: ExceptionLevel.error, msg: "${universityAccount?.university.name ?? ""}: $msg");
}

void handleContentApiException({required ApiException cAE, StackTrace? st, UniversityAccount? uAcc}) {
  if (cAE.msgToUser.isNotEmpty) showLongToast(cAE.msgToUser);
  logException(("${cAE.toBeLogged}:\n${st ?? ""}"), uAcc);
}

class ApiException implements Exception {
  final String msgToUser;
  final String toBeLogged;
  const ApiException({required this.msgToUser, required this.toBeLogged});
  @override
  String toString() => msgToUser;
}

enum ExceptionLevel { error, warn, info, debug }

void log({ExceptionLevel lvl = ExceptionLevel.info, required String msg}) {
  if (kDebugMode) print("${lvl.name.toUpperCase()} $msg");
}

String getTitleFromCourse(Course? isarCourse) => isarCourse?.name ?? (isarCourse?.nameVariations.isNotEmpty ?? false ? isarCourse!.nameVariations.first : "Unnamed Course");

Key getCourseKey(ContentHandler api, int courseId) => Key("${api.universityAccount.university.name}:${api.universityAccount.userIdentifier}:course$courseId");

Key getPageKey(ContentHandler api, int moduleId) => Key("${api.universityAccount.university.name}:${api.universityAccount.userIdentifier}:page$moduleId");

String getContentApiKey(UniversityAccount universityAccount) => "${universityAccount.university.name}:${universityAccount.userIdentifier}";

String getVideoApiKey(UniversityAccount? universityAccount, VideoApiAccount apiAccount) => "videoapi${universityAccount?.university.name}:${universityAccount?.userIdentifier}:${apiAccount.id}";

Key getKeyFromRouteSettings({required RouteSettings routeSettings, TabItem? tabItem}) {
  switch (routeSettings.name) {
    case "/page":
      final (ContentHandler api, int moduleId, int courseId) = routeSettings.arguments! as (ContentHandler, int, int);
      return getCourseKey(api, courseId);

    case "/course":
      final (ContentHandler api, int courseId, int? _) = routeSettings.arguments! as (ContentHandler, int, int?);
      return getCourseKey(api, courseId);

    case "/search":
      return const Key("search");

    case "/bottomModal":
      return const Key("bottomModal");

    default:
      return Key(tabItem.toString());
  }
}

Future<void> transcribeModuleSync(dynamic arguments) async {
  final (int moduleId, RootIsolateToken rootIsolateToken) = arguments as (int, RootIsolateToken);

  BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
  final dir = await getApplicationDocumentsDirectory();

  final Isar isar = await Isar.open(
    [UniversityAccountSchema, CourseSchema, ModuleSchema, VideoApiAccountSchema, SearchableSchema],
    directory: dir.path,
  );

  Module? module = isar.modules.getSync(moduleId);
  String transcript = "";
  if (module != null) {
    if (module.type case ModuleType.pdf) {
      PDFDoc doc = await PDFDoc.fromPath(module.filepath!);
      transcript = await doc.text;
    } else if (module.type case ModuleType.file) {
      switch (module.filepath!.split(".").last) {
        case "txt":
          transcript = await File(module.filepath!).readAsString();
          break;

        case "docx":
          final bytes = await File(module.filepath!).readAsBytes();
          transcript = docxToText(bytes);
          transcript = utf8.decode(transcript.runes.toList());
          break;
      }
    }
    isar.writeTxnSync(() {
      Module? module = isar.modules.getSync(moduleId);
      if (module != null) {
        module.searchable.loadSync();
        if (module.searchable.value == null) {
          Searchable searchable = Searchable()
            ..transcript = transcript
            ..module.value = module;
          isar.searchables.putSync(searchable);
          searchable.module.saveSync();
        } else {
          isar.searchables.putSync(module.searchable.value!..transcript = transcript);
        }
      }
    });
  }
}
