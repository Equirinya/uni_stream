import 'dart:convert';
import 'dart:convert' show utf8;
import 'package:http/http.dart' as http;
import 'package:better_player/better_player.dart';
import 'package:uni_stream/video_api.dart';

import '../utils.dart';


//have map with courses and according cookies

class RWTHOpenCast extends VideoApi{
  late final String _token;

  Map<int, String> courseCookies = {};

  @override
  Future<void> init(Map<String, String> credentials) async {
    String? token = credentials["opencast_token"];

    if (token == null) {
      throw const ApiException(msgToUser: "Internal error while connecting to Opencast: Try removing that moodle account and logging in again", toBeLogged: "Opencast init token == null");
    }

    _token = token;
    return;
  }

  @override
  Future<(String, BetterPlayerDataSource)> getVideoInformation(String url, int courseId) async {
    String cookie;
    if(courseCookies.containsKey(courseId)){
      cookie = courseCookies[courseId]!;
    }
    else{
      cookie = extractCookie(await getOpencastCookies(_token, courseId.toString()));
      courseCookies[courseId] = cookie;
    }
    String episodeId = url.substring(45);
    var (episodeName, resolutions) = getEpisodeInformation(await getEpisode(episodeId, cookie));
    return (episodeName, BetterPlayerDataSource(BetterPlayerDataSourceType.network, resolutions.values.first, resolutions: resolutions));
  }

}

(String name, Map<String, String> resolutions) getEpisodeInformation(Map<String, dynamic> episode){
  Map<String, dynamic>? searchResults = episode["search-results"];
  if(searchResults != null && searchResults["total"] != null && searchResults["total"] is int && searchResults["total"] == 1 && searchResults["result"] != null){
    Map<String, dynamic> result = searchResults["result"];
    Map<String, String> resolutions = {};
    for(Map<String, dynamic> track in result["mediapackage"]["media"]["track"]){
      switch(track["mimetype"]){
        case "application/x-mpegURL":
          resolutions["HLS"] = track["url"];
          break;

        case "video/mp4":
          String res = List<String>.from(track["tags"]["tag"]).firstWhere((element) => element.endsWith("-quality"), orElse: () => "");
          if(res.isNotEmpty){
            resolutions[res.substring(0,res.length-8)] = track["url"];
          }
      }
    }
    return (result["mediapackage"]["title"], resolutions);
  }
  else{
    throw Exception('Failed to find result in returned Episode');
  }
}

Future<Map<String, dynamic>> getEpisode(String episodeId, String JSessionId) async {
  //print(JSessionId);
  final response = await http.get(
    Uri.parse('https://engage.streaming.rwth-aachen.de/search/episode.json?id=$episodeId'),
    headers: <String, String>{
      "cookie": JSessionId,
    },
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> responseJson = jsonDecode(utf8.decode(response.body.runes.toList()));
    if (responseJson["exception"] != null) throw Exception("Moodle Api exception ${responseJson["errorcode"]}: ${responseJson["message"]}");
    return responseJson;
  } else {
    throw Exception('Failed to call api, status coode ${response.statusCode}');
  }
}

//Opencast

Future<Map<String, String>> getOpencastCookies(String openCastToken, String courseid) async {
  Map<String, dynamic> openCastLoginDetails = await getOpencastLoginForm(openCastToken, courseid);
  Map<String, String> openCastLoginStringDetails = openCastLoginDetails.map((key, value) => MapEntry(key, value.toString()));
  openCastLoginStringDetails.remove("url");
  //print(openCastLoginStringDetails);
  //openCastLoginStringDetails.update("lis_person_name_full", (value) => "Jacob+Peters");
  final response = await http.post(
    Uri.parse(openCastLoginDetails["url"]),
    headers: <String, String>{},
    body: openCastLoginStringDetails,
  );

  if (response.statusCode == 200) {
    //200 OK
    response.headers["statusCode"] = response.statusCode.toString();
    print("Unexpected 200 status code before redirect on Opencast cookies:\n" + response.headers.toString());
    return response.headers;
  } else if (response.statusCode == 302) {
    //302 REDIRECT
    //print("first Response Headers: "+response.headers.toString());
    //print(response.headers["location"]);
    if (response.headers["location"] != null && response.headers["set-cookie"] != null) {
      String sessionid = extractCookie(response.headers);

      final secondResponse = await http.get(
        Uri.parse(response.headers["location"]!),
        headers: <String, String>{
          "cookie": sessionid,
        },
      );

      if (secondResponse.statusCode == 200) {
        //200 OK
        //response.headers["statusCode"]=response.statusCode.toString();
        //print("second Response Headers: "+secondResponse.headers.toString());
        return secondResponse.headers;
      } else {
        // If the server did not return a 200 response,
        // then throw an exception.
        throw Exception('Failed to call api, status code on second stage ${secondResponse.statusCode}');
      }
    } else {
      throw Exception('Failed to get Opencast Cookies, missing headers after first response');
    }

    //return response.headers;
  } else {
    // If the server did not return a 200 or 302 response,
    // then throw an exception.
    throw Exception('Failed to call opencast api on first stage, status code ${response.statusCode}');
  }
}

Future<Map<String, dynamic>> getOpencastLoginForm(String openCastToken, String courseid) async {
  final response = await http.post(
    Uri.parse('https://moodle.rwth-aachen.de/webservice/rest/server.php'),
    headers: <String, String>{},
    body: <String, String> {
      'wstoken': openCastToken,
      'wsfunction': 'filter_opencast_get_lti_form',
      'moodlewsrestformat': 'json',
      'courseid': courseid,
    },
  );

  if (response.statusCode == 200) {
    //200 OK
    if (response.body == "") throw Exception("Opencast Login Form answer empty");
    String responseString = response.body;
    responseString = Uri.decodeFull(responseString);
    if(responseString.startsWith('{"exception')) throw Exception("Opencast Login Form answered with exception $responseString");
    responseString = responseString.substring(1, responseString.length - 1);
    responseString = responseString.replaceAll("\\n", "");
    responseString = responseString.replaceAll("\\", "");
    responseString = responseString.replaceAll("<form action=", "{\"url\":");
    int indexEndUrl = responseString.indexOf("\"", 8);
    int indexEndFirstFormBracket = responseString.indexOf(">");
    responseString = responseString.replaceRange(indexEndUrl + 1, indexEndFirstFormBracket, "/");
    responseString = responseString.replaceAll("/><input type=\"hidden\" name=", ",");
    responseString = responseString.replaceAll(" value=", ":");
    responseString = responseString.replaceFirst("/></form>", "}"); //make more reliable
    Map<String, dynamic> responseJson = jsonDecode(responseString);
    return responseJson;
  } else {
    // If the server did not return a 200 response,
    // then throw an exception.
    throw Exception('Failed to call api, status code ${response.statusCode}');
  }
}

String extractCookie(Map<String, dynamic> responseHeaders) {
  String rawCookie = responseHeaders["set-cookie"];
  int index = rawCookie.indexOf(';');
  String sessionid = (index == -1) ? rawCookie : rawCookie.substring(0, index);
  return sessionid;
}
