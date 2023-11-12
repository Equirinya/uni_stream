//dart run build_runner build
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:uni_stream/content_api.dart';
import 'package:uni_stream/video_api.dart';
import 'package:uni_stream/video_providers/rwth_opencast.dart';

import 'Universities/rwth.dart';
part 'database.g.dart';

@Collection()
class VideoApiAccount {
  late Id id = Isar.autoIncrement;

  @Enumerated(EnumType.name)
  late VideoApiType type;

  final universityAccount = IsarLink<UniversityAccount>();
}

enum VideoApiType {
  opencast(name: "Opencast RWTH Aachen", videoApiFactory: RWTHOpenCast.new, urls: ["https://engage.streaming.rwth-aachen.de/play/"]);

  const VideoApiType({
    required this.name,
    required this.videoApiFactory,
    required this.urls,
  });

  final String name;
  final VideoApi Function() videoApiFactory;
  final List<String> urls;
}

@Collection()
class UniversityAccount {
  late Id id = Isar.autoIncrement;
  late int index;

  @Enumerated(EnumType.name)
  late University university;

  late String userIdentifier;
  late DateTime lastDashboardUpdate;
  @Backlink(to: 'universityAccount')
  final courses = IsarLinks<Course>();

  @Backlink(to: 'universityAccount')
  final videoApis = IsarLinks<VideoApiAccount>();
}

enum University {
  rwth(name: "RWTH Aachen", color: Colors.blue, contentApiFactory: RWTHMoodleApi.new);

  const University({
    required this.name,
    required this.color,
    required this.contentApiFactory,
  });

  final String name;
  final Color color;
  final ContentApi Function() contentApiFactory;
}

@Collection()
class Course {
  //TODO: löschen wenn man kurs verlässt
  late Id id = Isar.autoIncrement;
  late int universityId;

  final universityAccount = IsarLink<UniversityAccount>();
  String? name;
  List<String> nameVariations = List.empty(growable: true);
  late bool hidden;
  //late int category;
  late DateTime lastAccess;

  late DateTime lastUpdate;
  late int lastOpenedSection;
  late List<String> sections; //empty when course not downloaded yet

  Course();

  Course.fromApiCourse(ApiCourse apiCourse, UniversityAccount universityAccount)
      : universityId = apiCourse.id,
        nameVariations = apiCourse.nameVariations.toSet().toList(),
        hidden = apiCourse.hidden ?? false,
        lastAccess = apiCourse.lastAccess ?? DateTime.fromMillisecondsSinceEpoch(0),
        lastUpdate = DateTime.now(),
        lastOpenedSection = 0,
        sections = List.empty(growable: true) {
    this.universityAccount.value = universityAccount;
  }
}

//TODO create Section class with name, index, and scrollposition

@Collection()
class Module {
  late Id id = Isar.autoIncrement;
  int? universityId;
  late int index;
  int? section;
  final course = IsarLink<Course>();

  @Enumerated(EnumType.name)
  late ModuleType type;
  late String title;
  String? description;

  @Backlink(to: 'module')
  final searchable = IsarLink<Searchable>();

  final submodules = IsarLinks<Module>();

  String? url;
  String? filepath;
  String? previewFilepath;

  DateTime? lastUsed;
  DateTime? favoritedSince; //null wenn not favorite
  double? progress; //for video and maybe pdf?
  double? download; //null when not downloaded

  Module();

  Module.fromApiModule(ApiModule apiModule, Course course)
      : universityId = apiModule.id,
        section = apiModule.section,
        index = apiModule.index,
        type = apiModule.type,
        title = apiModule.title.trim(),
        description = apiModule.description,
        url = apiModule.url {
    this.course.value = course;
  }
}

@Collection()
class Searchable{
  late Id id = Isar.autoIncrement;
  final module = IsarLink<Module>();

  String? transcript;

  @Index(type: IndexType.value, caseSensitive: false)
  List<String> get transcriptWords {
    return Isar.splitWords(transcript ?? "");
  }
}

enum ModuleType {
  text,
  html,
  image,
  video,
  file,
  pdf,
  folder,
  page,
  unsupported,
}


//page design: oben drei knöpfe um zwischen designs zu wechseln:
// bibliothek (nur auswählbar wenn erkannt) : videos und pdfs
// zusammengefasst - videos mit titeln und links darunter zu einem zusammengefasst - alles was schöner
// reine html darstellung
