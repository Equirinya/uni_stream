import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uni_stream/database.dart';

import 'package:uni_stream/pages/add_university_page.dart';
import 'package:uni_stream/utils.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart' as DOM;
import 'package:universal_html/html.dart';

import '../content_api.dart';

class RWTHMoodleApi extends ContentApi {
  String _token = "";
  late String _userId;
  late String _name;
  static const String opencastTokenKey = "opencast_token";

  @override
  List<(VideoApiType, List<String>)> connectedVideoApis = [
    (VideoApiType.opencast, [opencastTokenKey])
  ];

  @override
  Future<void> init(Map<String, String> credentials) async {
    String? token = credentials["token"];

    if (token == null) {
      throw const ApiException(msgToUser: "Internal error while connecting to RWTH Moodle: Try removing that account and logging in again", toBeLogged: "RWTH Moodle init token == null");
    }

    _token = token;
    try {
      Map<String, dynamic> webServiceInfo = await _getWebServiceInfo();

      _userId = webServiceInfo["userid"].toString();
      _name = webServiceInfo["firstname"] + " " + webServiceInfo["lastname"];
    } on Exception catch (e) {
      throw ApiException(msgToUser: "Could not login at RWTH Moodle", toBeLogged: "Error on calling getWebServiceInfo: ${e.toString()}");
    }
  }

  @override
  Widget buildLoginPage(void Function(String, String) setCredentialValue) {
    // return buildUsernamePasswordLoginPage(setValue: setCredentialValue);
    return buildMultiFieldLoginPage(setValue: setCredentialValue, names: ["token", opencastTokenKey]);
  }

  @override
  Future<String> getUserIdentifier() async {
    try {
      Map<String, dynamic> userInfo = await getUserInformation();

      String matrikelnummer = userInfo["idnumber"];
      return "$_name - $matrikelnummer";
    } on Exception catch (e) {
      throw ApiException(msgToUser: "Couldn't retrieve name and matrikelnummer from the user, are the credentials correct?", toBeLogged: "Error on getUserIdentifier: ${e.toString()}");
    }
  }

  @override
  Future<Map<String, String>> transformCredentials(Map<String, String> inputtedCredentials) async {
    //TODO to be changed when switch to username password
    //TODO add opencast token
    return inputtedCredentials;
  }

  @override
  Future<List<ApiCourse>> getCourses() async {
    List<Map<String, dynamic>> moodleCourses = List<Map<String, dynamic>>.from(await getUserCourses());

    //TODO wichtig checken ob preference value for hidden course has changed with new moodle version
    Map<String, dynamic> userPreferences = await getUserPreferences();

    List<int> hiddenCourseIds = <int>[];
    for (Map<String, dynamic> preference in userPreferences["preferences"]) {
      // if (preference["name"]!.startsWith("block_course_overview_campus-hidecourse-") && preference["value"] == "1") hiddenCourseIds.add(int.parse(preference["name"]!.substring(40)));
      if (preference["name"]!.startsWith("block_myoverview_hidden_course_") && preference["value"] == "1") hiddenCourseIds.add(int.parse(preference["name"]!.substring(31)));
    }

    List<ApiCourse> courses = List.empty(growable: true);

    for (Map<String, dynamic> moodleCourse in moodleCourses) {
      int id = moodleCourse["id"];

      List<String> nameVariations = List.empty(growable: true);
      nameVariations.add(moodleCourse["fullname"]);
      nameVariations.add(moodleCourse["shortname"]);
      nameVariations.add(moodleCourse["displayname"]);
      nameVariations.addAll((moodleCourse["fullname"] as String).split(']').map((e) => "$e]"));
      nameVariations.addAll((moodleCourse["displayname"] as String).split(']').map((e) => "$e]"));
      //TODO remove single ] and add shortname split

      DateTime? lastAccess = moodleCourse["lastaccess"] == null ? null : DateTime.fromMillisecondsSinceEpoch(moodleCourse["lastaccess"] * 1000);

      courses.add(ApiCourse(
        id: id,
        nameVariations: nameVariations,
        hidden: hiddenCourseIds.contains(id),
        lastAccess: lastAccess,
      ));
    }

    return courses;
  }

  @override
  Future<bool> setCourseVisibility(int courseId, bool hidden) async {
    await updateUserPreference("block_myoverview_hidden_course_$courseId", hidden ? "1" : null);
    return true;
  }

  @override
  Future<(List<String>, List<ApiModule>)> getSectionNamesAndCourseModules(int courseId) async {
    List<String> sectionNames = List.empty(growable: true);
    List<ApiModule> modules = List.empty(growable: true);
    List courseContents = List<Map<String, dynamic>>.from(await getCourseContents(courseId.toString()));
    List folders = List<Map<String, dynamic>>.from((await getCourseFolders(courseId.toString()))["folders"]);

    courseContents.removeWhere((section) {
      return (section["summary"] == "" && (section["modules"] as List).isEmpty);
    });

    //TODO run in parralel to avoid lag by too many pages loading
    for (final (int sectionIndex, Map<String, dynamic> section) in courseContents.indexed) {
      sectionNames.add(section["name"]);
      if (section["summary"] != "") {
        modules.add(ApiModule(
          id: section["id"].hashCode,
          section: sectionIndex,
          index: 0,
          type: ModuleType.html,
          title: section["summary"],
        ));
      }
      for (final (int index, Map<String, dynamic> module) in List<Map<String, dynamic>>.from(section["modules"]).indexed) {
        ModuleType type;
        String? url;
        String title = module["name"];
        String? description = module["description"];
        List<ApiModule> submodules = List.empty(growable: true);

        switch (module["modname"] as String) {
          case "pdfannotator": //TODO implement better
          case "resource":
            List<Map<String, dynamic>> contents = List<Map<String, dynamic>>.from(module["contents"] ?? []);
            if (contents.isEmpty) {
              if (module["availabilityinfo"] != null && module["availabilityinfo"] is String) {
                if (description == null) {
                  description = module["availabilityinfo"];
                } else {
                  description += "\n${module["availabilityinfo"]}";
                }
                type = ModuleType.file;
              } else {
                type = ModuleType.unsupported;
              }
            } else {
              Map<String, dynamic> content;
              if (contents.length > 1) {
                log(msg: "RWTHMoodle: contents of resource model more than one", lvl: ExceptionLevel.warn);
              }
              content = contents.first;
              if (content["type"] == null || content["type"] != "file") {
                log(msg: "RWTHMoodle: type of content of resource is ${content["type"]}", lvl: ExceptionLevel.error);
                type = ModuleType.unsupported;
              } else {
                if (content["fileurl"] == null || content["fileurl"] is! String || (content["fileurl"] as String).isEmpty) {
                  log(msg: "RWTHMoodle: url of resource not found: ${content["fileurl"]}", lvl: ExceptionLevel.warn);
                  type = ModuleType.unsupported;
                } else {
                  url = content["fileurl"];
                  if (content["mimetype"] == null || content["mimetype"] is! String || (content["mimetype"] as String).isEmpty) {
                    type = ModuleType.file;
                    log(msg: "RWTHMoodle: mimetype of resource not found: ${content["mimetype"]}", lvl: ExceptionLevel.warn);
                  } else {
                    type = moduleTypeFromMime(content["mimetype"]);
                  }
                }
              }
            }
            break;

          case "page":
            type = ModuleType.unsupported;
            url = module["url"];

            List<Map<String, dynamic>> contents = List<Map<String, dynamic>>.from(module["contents"] ?? []);
            if (contents.isEmpty) {
              if (module["availabilityinfo"] != null && module["availabilityinfo"] is String) {
                if (description == null || description.isEmpty) {
                  description = module["availabilityinfo"];
                } else {
                  description += "\n${module["availabilityinfo"]}";
                }
              }
            } else {
              String? pageHtml;
              Map<String, (String url, String? mime)> files = {};
              for (Map<String, dynamic> content in contents) {
                if (content["type"] == null || content["type"] != "file") {
                  log(msg: "RWTHMoodle: type of content of page is ${content["type"]}", lvl: ExceptionLevel.error);
                } else {
                  if (content["fileurl"] == null || content["fileurl"] is! String || (content["fileurl"] as String).isEmpty) {
                    log(msg: "RWTHMoodle: url of content of page not found: ${content["fileurl"]}", lvl: ExceptionLevel.warn);
                  } else if (content["filename"] == null || content["filename"] is! String || (content["filename"] as String).isEmpty) {
                    log(msg: "RWTHMoodle: name of content of page not found: ${content["fileurl"]}", lvl: ExceptionLevel.warn);
                  } else {
                    String contentUrl = content["fileurl"];
                    String contentName = content["filename"];

                    if (contentName == "index.html") {
                      Map<String, String> bodyMap = <String, String>{
                        'token': _token,
                      };

                      //TODO catch connection timed out error
                      final response = await http.post(Uri.parse(contentUrl), headers: <String, String>{}, body: bodyMap);
                      if (response.statusCode == 200) {
                        //200 OK
                        if (response.body.startsWith('{"error')) {
                          log(msg: "Failed to download page content for ${module["id"]}", lvl: ExceptionLevel.error);
                        } else {
                          pageHtml = response.body;
                        }
                      } else {
                        log(msg: "Failed to download page content for ${module["id"]}", lvl: ExceptionLevel.error);
                      }
                    } else if (content["mimetype"] == null || content["mimetype"] is String) {
                      files[contentName] = (contentUrl, content["mimetype"]);
                    }
                  }
                }
              }
              if (pageHtml != null) {
                try {
                  var document = parse(pageHtml);
                  List<DOM.Element> elements = document.body!.children;
                  for (DOM.Element element in elements) {
                    buildSubmodule(element, "", "", List<String>.empty(growable: true), files, submodules, sectionIndex, module);
                  }
                  type = ModuleType.page;
                } on Exception catch (e) {
                  log(msg: "Error while parsing html for page:", lvl: ExceptionLevel.error);
                }
              }
            }
            break;

          case "folder":
            type = ModuleType.folder;
            url = module["url"];
            Map<String, dynamic> folder = folders.firstWhere((element) => element["coursemodule"] == module["id"], orElse: () => <String,dynamic>{});
            String intro = folder["intro"] ?? "";
            if(intro.trim().isNotEmpty) {
              if(description != null && parse(description).text != parse(intro).text) submodules.add(ApiModule(section: sectionIndex, index: submodules.length, type: ModuleType.html, title: intro.trim()));
            }

            List<Map<String, dynamic>> contents = List<Map<String, dynamic>>.from(module["contents"] ?? []);
            if (contents.isEmpty) {
              if (module["availabilityinfo"] != null && module["availabilityinfo"] is String) {
                if (description == null || description.isEmpty) {
                  description = module["availabilityinfo"];
                } else {
                  description += "\n${module["availabilityinfo"]}";
                }
              }
            } else {
              for (Map<String, dynamic> content in contents) {
                if (content["type"] == null || content["type"] != "file") {
                  log(msg: "RWTHMoodle: type of content of page is ${content["type"]}", lvl: ExceptionLevel.error);
                } else {
                  if (content["fileurl"] == null || content["fileurl"] is! String || (content["fileurl"] as String).isEmpty) {
                    log(msg: "RWTHMoodle: url of content of page not found: ${content["fileurl"]}", lvl: ExceptionLevel.warn);
                  } else if (content["filename"] == null || content["filename"] is! String || (content["filename"] as String).isEmpty) {
                    log(msg: "RWTHMoodle: name of content of page not found: ${content["fileurl"]}", lvl: ExceptionLevel.warn);
                  } else {
                    String contentUrl = content["fileurl"];
                    String contentName = content["filename"];
                    if (content["mimetype"] == null || content["mimetype"] is String) {
                      ModuleType fileType = moduleTypeFromMime(content["mimetype"]);
                      submodules.add(ApiModule(section: sectionIndex, index: submodules.length, type: fileType, title: contentName, url: contentUrl));
                    }
                  }
                }
              }
            }
            break;

          case "lti":
            Map<String, dynamic> lti = await getCourseLti(module["instance"].toString());
            if(lti.keys.isEmpty){
              type = ModuleType.text;
              if (module["availabilityinfo"] != null && module["availabilityinfo"] is String) {
                if (description == null || description.isEmpty) {
                  description = module["availabilityinfo"];
                } else {
                  description += "\n${module["availabilityinfo"]}";
                }
              }
            }
            if(lti["endpoint"] != null && lti["endpoint"] is String && lti["endpoint"]  == "https:\/\/engage.streaming.rwth-aachen.de\/lti"){
              type = ModuleType.video;
              List<Map<String, dynamic>> parameters = List<Map<String, dynamic>>.from(lti["parameters"] ?? []);
              if (parameters.isEmpty) {
                type = ModuleType.unsupported;
                log(msg: "Failed to load lti because parameters are empty $lti", lvl: ExceptionLevel.error);
              } else {
                String? videoId = parameters.firstWhere((element) => element["name"] == "custom_id", orElse: () => <String,String>{})["value"];
                if (videoId == null || videoId.isEmpty) {
                  type = ModuleType.unsupported;
                  log(msg: "Failed to load lti because parameters are empty $lti", lvl: ExceptionLevel.error);
                } else {
                  url = "https://engage.streaming.rwth-aachen.de/play/$videoId";
                }
              }
            }
            else{
              type = ModuleType.unsupported;
              log(msg: "Failed to load lti $lti", lvl: ExceptionLevel.error);
            }
            break;

          case "label":
            type = ModuleType.html;
            title = module["description"];
            description = null;
            break;

          default:
            type = ModuleType.unsupported;
        }
        ApiModule apiModule = ApiModule(id: module["id"], section: sectionIndex, index: index + 1, title: title, type: type, description: description?.trim(), url: url, submodules: submodules);
        modules.add(apiModule);
      }
    }

    return (sectionNames, modules);
  }

  ModuleType moduleTypeFromMime(String mimeType){
    ModuleType type;
    switch (mimeType) {
      case "application/pdf":
        type = ModuleType.pdf;
        break;
      case "video/mp4":
        type = ModuleType.video;
        break;
    //add further types if internal use is made
      default:
        type = ModuleType.file;
    }
    return type;
  }

  void buildSubmodule(DOM.Element element, String titleBeginning, String titleEnd, List<String> ancestors, Map<String, (String, String?)> files, List<ApiModule> submodules, int sectionIndex,
      Map<String, dynamic> module) {
    ancestors.add(element.localName ?? "");
    bool addNumbersToList = false;
    switch (element.localName) {
      case "div":
      case "u": //underlined
      case "b": //strong
      case "li":
      case "span":
      case "strong": //TODO add textStyle to ancestor list
      case "p":
        if (element.children.isNotEmpty) {
          //getting the text of the p element without the text of its children
          // String pText = (element.clone(true)
          //       ..children.forEach((element) {
          //         element.remove();
          //       }))
          //     .text;
          List<(DOM.Element element, String titleStart, String titleEnd)> children = List.empty(growable: true);
          String looseText = "";
          bool brAfterChild = false;
          for (DOM.Node node in element.nodes.toList()) {
            if (node.nodeType == Node.ELEMENT_NODE) {
              DOM.Element child = node as DOM.Element;
              if (child.localName == "span" && child.children.isEmpty) {
                looseText += child.text;
              } else if (child.localName == "br") {
                if (children.isNotEmpty) {
                  if (looseText.endsWith(":")) {
                    brAfterChild = true;
                    looseText += "\n";
                  } else if (!brAfterChild) {
                    brAfterChild = true;
                    // ignore: prefer_interpolation_to_compose_strings
                    children.last = (children.last.$1, children.last.$2, children.last.$3 + looseText + "\n");
                    looseText = "";
                  } else if (looseText.isNotEmpty) {
                    children.add((child, looseText, ""));
                  }
                } else {
                  looseText += "\n";
                }
              } else {
                brAfterChild = false;
                children.add((child, looseText, ""));
                looseText = "";
              }
            } else if (node.nodeType == Node.TEXT_NODE) {
              DOM.Text textElement = node as DOM.Text;
              looseText += textElement.text;
            } else {
              log(msg: "Found unexpected node type ${node.nodeType} while parsing $ancestors in html for page ${module["name"]}", lvl: ExceptionLevel.error);
            }
          }

          if (children.isEmpty) {
            String title = (titleBeginning + looseText + titleEnd).trim();
            if (title.isNotEmpty) {
              submodules.add(ApiModule(section: sectionIndex, index: submodules.length, type: ModuleType.text, title: title));
            }
          } else {
            for (final (index, (DOM.Element element, String titleStartChild, String titleEndChild)) in children.indexed) {
              bool lastChild = index == children.length - 1;
              buildSubmodule(element, (index == 0 ? titleBeginning : "") + titleStartChild, titleEndChild.trim() + (lastChild ? looseText + (brAfterChild ? "" : titleEnd) : ""), ancestors, files,
                  submodules, sectionIndex, module);
              if (lastChild && brAfterChild && titleEnd.trim().isNotEmpty) {
                submodules.add(ApiModule(section: sectionIndex, index: submodules.length, type: ModuleType.text, title: titleEnd));
              }
            }
          }
        } else {
          String title = (titleBeginning + element.text + titleEnd).trim();
          if (title.isNotEmpty) {
            submodules.add(ApiModule(section: sectionIndex, index: submodules.length, type: ModuleType.text, title: title));
          }
        }
        break;

      case "br":
        String title = (titleBeginning + element.text + titleEnd).trim();
        if (title.isNotEmpty) {
          submodules.add(ApiModule(section: sectionIndex, index: submodules.length, type: ModuleType.text, title: title));
        }
        break;

      case "a":
        if (element.attributes["href"] != null) {
          if (files.keys.contains(element.attributes["href"])) {
            final (String url, String? mime) = files[element.attributes["href"]]!;
            ModuleType fileType = moduleTypeFromMime(mime!);
            submodules.add(ApiModule(section: sectionIndex, index: submodules.length, type: fileType, title: titleBeginning + element.text + titleEnd, url: url));
          }
          else {
            String url = element.attributes["href"]!;
            String title = element.innerHtml.isEmpty ? url : element.innerHtml;
            if (url.startsWith("https://engage.streaming.rwth-aachen.de/play/")) {
              submodules.add(ApiModule(section: sectionIndex, index: submodules.length, type: ModuleType.video, title: "$titleBeginning $title $titleEnd", url: url));
            }
            else if (url.endsWith(".mp4")) { //TODO often ends in .mp4?forcedownlaod=1
              submodules.add(ApiModule(section: sectionIndex, index: submodules.length, type: ModuleType.video, title: "$titleBeginning $title $titleEnd", url: url));
            }else{
              ModuleType type = ModuleType.text;
              if(titleBeginning.trim().isNotEmpty) submodules.add(ApiModule(section: sectionIndex, index: submodules.length, type: type, title: titleBeginning));
              submodules.add(ApiModule(section: sectionIndex, index: submodules.length, type: type, title: title, url: url));
              if(titleEnd.trim().isNotEmpty) submodules.add(ApiModule(section: sectionIndex, index: submodules.length, type: type, title: titleEnd));
            }
          }
        } else {
          log(msg: "Found unexpected <a> tag without url in $ancestors in  html for page ${module["name"]}", lvl: ExceptionLevel.error);
        }
        break;

      case "ol":
      addNumbersToList = true;
      continue list;

      list:
      case "ul":
        if (titleBeginning.trim().isNotEmpty) {
          submodules.add(ApiModule(
              section: sectionIndex,
              index: submodules.length,
              type: ModuleType.text,
              title: titleBeginning));
        }
        if (element.hasChildNodes()) {
          for (final (int liIndex, DOM.Element child) in element.children.indexed) {
            if (child.innerHtml.isNotEmpty && child.localName == "li") {
              buildSubmodule(child, "${addNumbersToList ? "${liIndex+1}." : " •"}", "", ancestors + ["ul"], files, submodules, sectionIndex, module);
            } else {
              log(msg: "Found unexpected tag $child while parsing ul in $ancestors in html for page ${module["name"]}", lvl: ExceptionLevel.error);
            }
          }
        }
        if (titleEnd.trim().isNotEmpty) {
          submodules.add(ApiModule(
              section: sectionIndex,
              index: submodules.length,
              type: ModuleType.text,
              title: titleEnd));
        }
        break;

      case "table":
        submodules.add(ApiModule(section: sectionIndex, index: submodules.length, type: ModuleType.html, title: titleBeginning + element.innerHtml + titleEnd));
        break;

      case "h1":
      case "h2":
      case "h3":
      case "h4":
      case "h5":
        //TODO add textSize
        submodules.add(ApiModule(section: sectionIndex, index: submodules.length, type: ModuleType.text, title: titleBeginning + element.innerHtml + titleEnd));
        break;

      case "iframe":
        if (element.className == "ocplayer") {
          if (element.attributes["data-framesrc"] != null && element.attributes["data-framesrc"] is String && element.attributes["data-framesrc"]!.isNotEmpty) {
            String url = element.attributes["data-framesrc"]!;
            String title = (titleBeginning + element.text + titleEnd).trim();
            if (title.endsWith(":")) title = title.substring(0, title.length - 1);
            submodules.add(ApiModule(section: sectionIndex, index: submodules.length, type: ModuleType.video, title: title, url: url));
          } else {
            log(msg: "Found unexpected iframe with data-framesrc ${element.attributes["data-framesrc"]} in $ancestors while parsing html for page ${module["name"]}", lvl: ExceptionLevel.error);
          }
        } else {
          log(msg: "Found unexpected iframe with class ${element.className} in $ancestors while parsing html for page ${module["name"]}", lvl: ExceptionLevel.error);
        }
        break;

      default:
        log(msg: "Found unexpected tag $element in $ancestors while parsing html for page ${module["name"]}", lvl: ExceptionLevel.error);
    }
  }

  @override
  Future<(Map<String, String>?, Map<String, String>?)> getHeadersAndQueryParametersForUrl(String url) async {
    return (null, {"token": _token});
  }

//login and settings
  Future<Map<String, dynamic>> _getWebServiceInfo() async => moodleCallMap(token: _token, function: "core_webservice_get_site_info"); //userID und name, userprivateaccesskey

  Future<Map<String, dynamic>> getUserInformation() async =>
      (await moodleCallList(token: _token, function: "core_user_get_users_by_field", options: <String, String>{"field": "id", "values[0]": _userId}, logBody: false))[0]; //TODO: catch wrong type

  Future<Map<String, dynamic>> getUserPreferences() async => moodleCallMap(token: _token, function: "core_user_get_user_preferences");

  Future<Map<String, dynamic>> setUserPreference(String name, String value) async => moodleCallMap(
      token: _token,
      function: "core_user_set_user_preferences",
      options: <String, String>{
        "preferences[0][name]": name,
        "preferences[0][value]": value,
        "preferences[0][userid]": _userId,
      },
      logBody: false);

  Future<void> updateUserPreference(String name, String? value) async =>
      callMoodleServerApi(token: _token, function: "core_user_update_user_preferences", options: <String, String>{"preferences[0][type]": name, if (value != null) "preferences[0][value]": value});

//dashboard
  Future<List> getUserCourses() async => await moodleCallList(token: _token, function: "core_enrol_get_users_courses", options: <String, String>{"userid": _userId.toString()});

  Future<List> getCourseCategories() async => await moodleCallList(token: _token, function: "core_course_get_categories");

  //course modules
  Future<List> getCourseContents(String courseID) async => await moodleCallList(token: _token, function: "core_course_get_contents", options: <String, String>{"courseid": courseID});

  Future<Map<String, dynamic>> getCourseFolders(String courseID) async => await moodleCallMap(token: _token, function: "mod_folder_get_folders_by_courses", options: <String, String>{"courseids[0]": courseID});

  Future<Map<String, dynamic>> getCourseLti(String ltiID) async => await moodleCallMap(token: _token, function: "mod_lti_get_tool_launch_data", options: <String, String>{"toolid": ltiID});

//pages
  Future<List> getCoursePages(String courseID) async => (await moodleCallMap(token: _token, function: "mod_page_get_pages_by_courses", options: <String, String>{"courseids[0]": courseID}))["pages"];

  String addTokenToImageUrls(String str) {
    //TODO do not add token but remove /webservice subpath from Uri //TODO wrong todo, becuase without webservice you need to log in?
    String returnString = str.replaceAllMapped(RegExp('src=\\"https:\/\/moodle\.rwth-aachen\.de\/webservice[a-zA-Z\/\.0-9\_\-]*\.(png|jpg|jpeg|svg|bmp|tif|tiff)', caseSensitive: false), (match) {
      return 'src="${addTokenToUrl(Uri.parse(match.group(0)!.substring(5)))}';
    });
    return (returnString);
  }

  Uri addTokenToUrl(Uri url) {
    Uri newUrl = Uri.https(url.host, url.path, {'token': _token}..addAll(url.queryParameters));
    return newUrl;
  }

//homepage
  Future<List> getRecentlyAccessedItems(String token) async => await moodleCallList(token: token, function: "block_recentlyaccesseditems_get_recent_items");

// message_popup_get_popup_notifications
}

//general Moodle Api Calls

Future<Map<String, dynamic>> moodleCallMap({required String token, required String function, Map<String, String> options = const {}, bool logBody = false}) async {
  http.Response response = await callMoodleServerApi(token: token, function: function, options: options);
  if (logBody) log(msg: "response of $function: ${response.body}");

  Map<String, dynamic> responseJson = jsonDecode(response.body);
  if (responseJson["exception"] != null) throw Exception("Moodle Api exception ${responseJson["errorcode"]} at function $function: ${responseJson["message"]}");
  return responseJson;
}

Future<List> moodleCallList({required String token, required String function, Map<String, String> options = const {}, bool logBody = false}) async {
  http.Response response = await callMoodleServerApi(token: token, function: function, options: options);
  if (logBody) log(msg: "response of $function: ${response.body}");

  dynamic responseJson = jsonDecode(response.body);
  if (logBody) log(msg: "response type of $function: ${responseJson.runtimeType.toString()}");

  if (responseJson is Map<String, dynamic>) {
    if (responseJson["exception"] != null) {
      throw Exception("Moodle Api exception ${responseJson["errorcode"]} at function $function: ${responseJson["message"]}");
    } else {
      throw Exception("return type of Map at Moodle Api function $function without error");
    }
  } else if (responseJson is List) {
    return responseJson;
  } else {
    throw Exception("Wrong return type at Moodle Api function $function");
  }
}

Future<http.Response> callMoodleServerApi({required String token, required String function, Map<String, String> options = const {}}) async {
  Map<String, String> bodyMap = <String, String>{
    'wstoken': token,
    'wsfunction': function,
    'moodlewsrestformat': 'json',
  };
  bodyMap.addAll(options);

  final response = await http.post(Uri.parse('https://moodle.rwth-aachen.de/webservice/rest/server.php'), headers: <String, String>{}, body: bodyMap);

  if (response.statusCode == 200) {
    //200 OK
    return response;
  } else {
    // If the server did not return a 200 response,
    // then throw an exception.
    throw Exception('Failed to call api function $function, status code ${response.statusCode}');
  }
}
