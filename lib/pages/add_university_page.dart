import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isar/isar.dart';
import 'package:uni_stream/content_api.dart';
import 'package:uni_stream/database.dart';
import 'package:uni_stream/utils.dart';

class AddUniversityPage extends StatefulWidget {
  const AddUniversityPage({Key? key, required this.isar, this.welcome = false, required this.securePrefs}) : super(key: key);
  final Isar isar;
  final bool welcome;
  final FlutterSecureStorage securePrefs;

  @override
  State<AddUniversityPage> createState() => _AddUniversityPageState();
}

class _AddUniversityPageState extends State<AddUniversityPage> {
  int pageIndex = 0;
  bool lastPage = false;
  late int pageCount;

  @override
  void initState() {
    pageCount = widget.welcome ? 3 : 2;
    super.initState();
  }

  CarouselController carouselController = CarouselController();
  University? selectedUniversity;
  Map<String, String> loginCredentials = {};

  Future<bool> processCredentials(ContentApi contentApi) async {
    try {
      Map<String, String> transformedCredential = await contentApi.transformCredentials(loginCredentials);

      await contentApi.init(transformedCredential);

      String userIdentifier = await contentApi.getUserIdentifier();

      UniversityAccount universityAccount = UniversityAccount()
        ..university = selectedUniversity!
        ..index = ((await widget.isar.universityAccounts.where().sortByIndexDesc().findFirst())?.index ?? 0) + 1
        ..userIdentifier = userIdentifier
        ..lastDashboardUpdate = DateTime.utc(1900);

      widget.isar.writeTxnSync(() {
        widget.isar.universityAccounts.putSync(universityAccount);

        for (final (videoApiType, tokens) in contentApi.connectedVideoApis) {
          VideoApiAccount videoApiAccount = VideoApiAccount()
            ..type = videoApiType
            ..universityAccount.value = universityAccount;
          widget.isar.videoApiAccounts.putSync(videoApiAccount);
          videoApiAccount.universityAccount.saveSync();
          widget.securePrefs.write(key: getVideoApiKey(universityAccount, videoApiAccount), value: jsonEncode(Map.of(transformedCredential)..removeWhere((key, value) => !tokens.contains(key))));
          transformedCredential.removeWhere((key, value) => tokens.contains(key));
        }
      });

      widget.securePrefs.write(key: getContentApiKey(universityAccount), value: jsonEncode(transformedCredential));

      print("videoapiaccounts"+widget.isar.videoApiAccounts.where().findAllSync().map((e) => e.type.name).toString());

      return true;
    } on ApiException catch (e, st) {
      handleContentApiException(cAE: e, st: st);
      return false;
    } on Exception catch (e, st) {
      handleContentApiException(cAE: ApiException(msgToUser: "Error while adding university", toBeLogged: (selectedUniversity?.name ?? "") + e.toString()), st: st);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          CarouselSlider(
              items: [
                if (widget.welcome)
                  SafeArea(
                    child: Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Image.asset("assets/icon/icon.png"),
                          ),
                          const Headline("Welcome to UniStream"),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: const Text("The universal university content access app"),
                          ),
                        ],
                      ),
                    ),
                  ),
                SafeArea(
                  child: ListView(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
                        child: Headline("Select your university:"),
                      ),
                      for (University university in University.values)
                        GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(const Radius.circular(12)),
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [university.color.harmonizeWith(Theme.of(context).colorScheme.primary), Colors.transparent],
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [Text(university.name), Icon(Icons.chevron_right)],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              this.selectedUniversity = university;
                            });
                            carouselController.nextPage();
                          },
                        ),
                    ],
                  ),
                ),
                if (selectedUniversity != null)
                  SafeArea(
                    child: selectedUniversity!.contentApiFactory.call().buildLoginPage((key, value) {
                      loginCredentials.update(key, (value) => value, ifAbsent: () => value);
                    }),
                  ),
              ],
              carouselController: carouselController,
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom,
                initialPage: 0,
                enableInfiniteScroll: false,
                viewportFraction: 1,
                onPageChanged: (index, reason) {
                  setState(() {
                    pageIndex = index;
                    lastPage = pageIndex == pageCount - 1;
                    if (index == (1 - (widget.welcome ? 0 : 1))) {
                      selectedUniversity = null;
                    }
                  });
                },
                scrollDirection: Axis.horizontal,
              )),
          //TODO add page indicator
        ],
      ),
      floatingActionButton: AnimatedScale(
        scale: pageIndex != (1 - (widget.welcome ? 0 : 1)) ? 1 : 0,
        duration: const Duration(milliseconds: 100),
        child: FloatingActionButton(
          onPressed: () {
            if (lastPage && selectedUniversity != null) {
              ContentApi contentApi = selectedUniversity!.contentApiFactory.call();

              //TODO show loading Indicator
              processCredentials(contentApi).then((success) {
                if (success) {
                  Navigator.of(context).pop();
                  //TODO loading indicator off
                } else {
                  //TODO
                }
              });
            } else {
              carouselController.nextPage();
            }
          },
          child: Icon(lastPage ? Icons.check : Icons.arrow_forward),
        ),
      ),
    );
  }
}

Widget buildTokenLoginPage({required Function(String, String) setValue}) {
  return buildMultiFieldLoginPage(setValue: setValue, names: ["Token"]);
}

Widget buildUsernamePasswordLoginPage({required Function(String, String) setValue}) {
  return buildMultiFieldLoginPage(setValue: setValue, names: ["Username", "Password"]);
}

Widget buildMultiFieldLoginPage({required void Function(String, String) setValue, required List<String> names}) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        for (String name in names)
          TextField(
            onChanged: (value) => setValue(name.toLowerCase(), value),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(0.0),
              border: const UnderlineInputBorder(),
              labelText: name,
            ),
          ),
      ],
    ),
  );
}
