import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:uni_stream/database.dart';

import '../content_api.dart';
import 'course_page.dart';
import '../moduleTile.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key, required this.isar, required this.apis}) : super(key: key);

  final Isar isar;
  final List<ContentHandler> apis;

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  bool downloaded = true;
  bool favorited = true;
  List<ModuleType> types = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(padding: EdgeInsets.only(right: 32.0, top: 12), child: Text("Deine Bibliothek", overflow: TextOverflow.ellipsis)),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(32),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 16),
                  FilterChip(label: const Text("downloaded"), onSelected: (selected) => setState(() => downloaded = selected), selected: downloaded),
                  const SizedBox(width: 8),
                  FilterChip(label: const Text("favorite"), onSelected: (selected) => setState(() => favorited = selected), selected: favorited),
                  const SizedBox(width: 8),
                  FilterChip(label: const Text("Videos"), onSelected: (selected) => setState(() {
                    if(selected) types.add(ModuleType.video);
                    else types.remove(ModuleType.video);
                  }), selected: types.contains(ModuleType.video)),
                  const SizedBox(width: 8),
                  FilterChip(label: const Text("PDFs"), onSelected: (selected) => setState(() {
                    if(selected) types.add(ModuleType.pdf);
                    else types.remove(ModuleType.pdf);
                  }), selected: types.contains(ModuleType.pdf)),
                  const SizedBox(width: 32),
                ],
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 128, top: 16),
        children: [
          for (Module module in widget.isar.modules
              .filter()
              .optional(types.isNotEmpty, (q) => q.anyOf(types, (q, element) => q.typeEqualTo(element)))
              .and()
              .group((q) => q.optional(downloaded, (q) => q.downloadGreaterThan(0)).or().optional(favorited, (q) => q.favoritedSinceIsNotNull()))
              .sortByLastUsedDesc()
              .limit(100)
              .findAllSync())
            ModuleTile(
              key: Key(module.id.toString()),
              moduleId: module.id,
              isar: widget.isar,
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
