import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:isar/isar.dart';

import '../content_api.dart';
import '../database.dart';
import '../moduleTile.dart';
import 'dashboard_page.dart';

enum SearchType {
  all(searchName: "everywhere");

  const SearchType({
    required this.searchName,
  });

  final String searchName;
}

class MatchedText {
  List<(int start, int end)> matches = List<(int start, int end)>.empty(growable: true);
  late String textPart;
  int get length => matches.fold(0, (previousValue, element) => previousValue + element.$2 - element.$1);
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.isar, required this.apis, this.searchType = SearchType.all});

  final Isar isar;
  final List<ContentHandler> apis;
  final SearchType searchType;
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  double _offset = -1;
  bool tooLittleCharacters = true;
  FocusNode searchBarFocusNode = FocusNode();

  @override
  initState() {
    Future.delayed(const Duration(milliseconds: 10), () {
      setState(() {
        _offset = 0;
      });
      searchBarFocusNode.requestFocus();
    });

    super.initState();
  }

  List<Course> courses = List<Course>.empty(growable: true);
  List<(Module, TextSpan?)> modules = List<(Module, TextSpan?)>.empty(growable: true);

  //TODO add these to settings + max values and midpoints for transcriptSearch rating + color of search highlight
  void searchTermChanged(String value, {final int defaultContextRadius = 45, final int transcriptLimit = 100}) {
    // alphanumeric
    final alphanumeric = RegExp("^[a-zA-Z0-9]");

    if (value.length < 3) {
      courses = List<Course>.empty(growable: true);
      modules = List<(Module, TextSpan?)>.empty(growable: true);
      setState(() {
        tooLittleCharacters = true;
      });
      return;
    }
    tooLittleCharacters = false;

    courses = widget.isar.courses.filter().nameVariationsElementContains(value, caseSensitive: false).sortByLastAccessDesc().findAllSync();
    List<Module> titleModules = widget.isar.modules
        .filter()
        .not()
        .typeEqualTo(ModuleType.text)
        .and()
        .not()
        .typeEqualTo(ModuleType.html)
        .and()
        .not()
        .typeEqualTo(ModuleType.image)
        .and()
        .not()
        .typeEqualTo(ModuleType.unsupported)
        .and()
        .titleContains(value, caseSensitive: false)
        .sortByLastUsedDesc()
        .findAllSync();

    List<Searchable> textModules =
        widget.isar.searchables.filter().anyOf(Isar.splitWords(value), (q, element) => q.transcriptWordsElementStartsWith(element, caseSensitive: false)).limit(transcriptLimit).findAllSync();
    for (var textModule in textModules) {
      textModule.module.loadSync();
    }

    Set<Module> allModules = (titleModules + textModules.map((e) => e.module.value!).toList()).toSet();
    Map<int, (double, TextSpan?)> weightedModules = {for (var module in allModules) module.id: (computeTimeWeight(module.lastUsed), null)};
    for (var titleModule in titleModules) {
      weightedModules[titleModule.id] = ((weightedModules[titleModule.id]?.$1 ?? 0) + 20, null);
    }
    for (var textModule in textModules) {
      String pdfString = textModule.transcript ?? "";
      pdfString = pdfString.replaceAll("\n", " ");

      double occurences = 0;
      //find all matches
      List<Match> matches = RegExp("(?:${Isar.splitWords(value).join("|")})", caseSensitive: false).allMatches(pdfString).toList();

      int lastEnd = 0;
      List<MatchedText> matchedTexts = List<MatchedText>.empty(growable: true);
      for (var i = 0; i < matches.length; i++) {
        //create highlighted text with surroundings of matches
        int start = matches[i].start;
        int contextRadius = start < defaultContextRadius ? start : defaultContextRadius;
        String before = pdfString.substring(start - contextRadius, start);
        List<Match> sentenceBreaks = RegExp("(?:\\n|\\.)").allMatches(before).toList();
        if (sentenceBreaks.isNotEmpty) {
          start = start - contextRadius + sentenceBreaks.last.end;
          if (sentenceBreaks.last.end < before.length && before[sentenceBreaks.last.end] == " ") {
            start++;
          }
        } else {
          //shorten search radius for this match?
          int spaceIndex = before.indexOf(" ");
          if (spaceIndex != -1) {
            start = start - contextRadius + spaceIndex;
          } else {
            start = start - (contextRadius);
          }
        }
        while(!alphanumeric.hasMatch(pdfString[start]) && start < matches[i].start) {
          start++;
        }

        int end = matches[i].end;
        contextRadius = pdfString.length - end < defaultContextRadius ? pdfString.length - end : defaultContextRadius;
        String after = pdfString.substring(end, end + contextRadius);
        sentenceBreaks = RegExp("(?:\\n|\\.)").allMatches(after).toList();
        if (sentenceBreaks.isNotEmpty) {
          end = end + sentenceBreaks.first.end;
        } else {
          //shorten search radius for this match?
          int spaceIndex = after.lastIndexOf(" ");
          if (spaceIndex != -1) {
            end = end + spaceIndex;
          } else {
            end = end + (contextRadius);
          }
        }
        while(!alphanumeric.hasMatch(pdfString[end-1]) && end > matches[i].end) {
          end--;
        }

        //join partnering matches
        if (i != 0 && start - lastEnd < defaultContextRadius) {
          MatchedText matchedText = matchedTexts.last;
          matchedText.matches.add((matches[i].start - (lastEnd - matchedText.textPart.length), matches[i].end - (lastEnd - matchedText.textPart.length)));
          matchedText.textPart += pdfString.substring(lastEnd, end);
        } else {
          MatchedText matchedText = MatchedText();
          matchedText.textPart = pdfString.substring(start, end);
          matchedText.matches.add((matches[i].start - start, matches[i].end - start));
          matchedTexts.add(matchedText);
        }
        lastEnd = end;
      }
      //compute occurences
      occurences = matches.fold(0, (previousValue, element) => previousValue + element.end - element.start) / value.length;

      TextSpan textSpan = TextSpan(
        children: matchedTexts.map((e) {
          List<TextSpan> textSpans = List<TextSpan>.empty(growable: true);
          textSpans.add(const TextSpan(
              text: "..."
          ));
          int lastEnd = 0;
          for (final (start, end) in e.matches) {
            textSpans.add(TextSpan(
              text: e.textPart.substring(lastEnd, start)
            ));
            textSpans.add(TextSpan(
              text: e.textPart.substring(start, end),
              style: TextStyle(
                backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
              ),
            ));
            lastEnd = end;
          }
          textSpans.add(TextSpan(
            text: e.textPart.substring(lastEnd),
          ));

          return textSpans;
        }).expand((element) => element).toList(growable: true)..add(const TextSpan(text: "...")),
      );

      //add weights
      weightedModules[textModule.module.value!.id] = ((weightedModules[textModule.module.value!.id]?.$1 ?? 0) + computeOccurenceWeight(occurences), textSpan);
      //create highlighted text with surroundings of matches
    }

    modules = (weightedModules.entries.toList()..sort((a, b) => b.value.$1.compareTo(a.value.$1))).map((e) {
      Module? module = widget.isar.modules.getSync(e.key);
      if(module == null) return null;
      return (module, e.value.$2);
    }).nonNulls.toList();
    setState(() {});
  }

  double computeTimeWeight(DateTime? lastUse, {int max = 30, midpointInDay = 2}) {
    if (lastUse == null) return 0;
    final now = DateTime.now();
    final diff = now.difference(lastUse);
    final hours = diff.inHours;
    return pow(2, -hours / (midpointInDay * 24)).toDouble();
  }

  double computeOccurenceWeight(double occurences, {int max = 15, midpoint = 2}) {
    if (occurences < 0) return 0;
    return max - max * pow(2, -occurences / midpoint).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 8),
        child: AnimatedSlide(
            offset: Offset(0, _offset),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: SearchBar(
                  focusNode: searchBarFocusNode,
                  leading: const Icon(Ionicons.search),
                  hintText: "Search ${widget.searchType.searchName}",
                  onChanged: searchTermChanged,
                ),
              ),
            )),
      ),
      body: ListView(
        children: [
          if(tooLittleCharacters)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text("Please enter at least 3 characters"),
              ))
          else if(modules.isEmpty && courses.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text("No results found"),
              )),
          for (final course in courses)
            CourseTile(
              course: course,
              api: widget.apis.firstWhere((element) {
                course.universityAccount.loadSync();
                return element.universityAccount.id == course.universityAccount.value?.id;
              }),
              stateChanged: () => setState(() {}),
              showVisibilitySlider: false,
            ),
          for (final (module, textSpan) in modules)
            ModuleTile(
              key: Key(module.id.toString()),
              outOfCourse: true,
              moduleId: module.id,
              isar: widget.isar,
              transcriptHighlights: textSpan,
              api: widget.apis.firstWhere((element) {
                module.course.loadSync();
                module.course.value?.universityAccount.loadSync();
                return element.universityAccount.id == module.course.value?.universityAccount.value?.id;
              }),
            ),
        ],
      ),
    );
  }
}
