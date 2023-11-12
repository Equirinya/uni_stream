import 'package:flutter/material.dart';
import 'package:uni_stream/pages/add_university_page.dart';
import '../content_api.dart';
import '../database.dart';

class TemplateUniversityApi extends ContentApi {

  //please do not throw exceptions in buildLoginPage
  //every exception is logged, please make sure no user specific information is included
  //throw ContentApiException to give the user feedback
  //tobeLogged should never include any specific user information


  @override
  List<(VideoApiType, List<String>)> connectedVideoApis = [];

  @override
  Future<void> init(Map<String, String> credentials) {
    // TODO: implement init
    throw UnimplementedError();
  }

  @override
  Widget buildLoginPage(void Function(String p1, String p2) setCredentialValue) {
    //can use build methods from add_university.dart

    // TODO: implement buildLoginPage
    throw UnimplementedError();
  }

  @override
  Future<Map<String, String>> transformCredentials(Map<String, String> inputtedCredentials) {
    // TODO: implement transformCredentials
    throw UnimplementedError();
  }

  @override
  Future<String> getUserIdentifier() {
    // TODO: implement getUserIdentifier
    throw UnimplementedError();
  }

  @override
  Future<List<ApiCourse>> getCourses() {
    // TODO: implement getCourses
    throw UnimplementedError();
  }

  //if not able to be implemented, dont retrieve course visibility in get Courses
  @override
  Future<bool> setCourseVisibility(int courseID, bool hidden) {
    // TODO: implement setCourseVisibility
    throw UnimplementedError();
  }

  @override
  Future<(List<String>, List<ApiModule>)> getSectionNamesAndCourseModules(int courseId) {
    // TODO: implement getSectionNamesAndCourseModules
    throw UnimplementedError();
  }

  @override
  Future<(Map<String, String>?, Map<String, String>?)> getHeadersAndQueryParametersForUrl(String url) {
    // TODO: implement getHeadersForUrl
    throw UnimplementedError();
  }
}
