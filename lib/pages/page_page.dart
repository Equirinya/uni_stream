import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:isar/isar.dart';
import 'package:uni_stream/database.dart';
import 'package:url_launcher/url_launcher.dart';

import '../content_api.dart';
import '../moduleTile.dart';
import 'course_page.dart';

class PagePage extends StatelessWidget {
  const PagePage({Key? key, required this.isar, required this.api, required this.moduleId}) : super(key: key);
  final Isar isar;
  final ContentHandler api;
  final int moduleId;

  @override
  Widget build(BuildContext context) {
    Module? module = isar.modules.getSync(moduleId);
    module?.submodules.loadSync();
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 32.0),
          child: Text(module?.title ?? "Module not found", overflow: TextOverflow.ellipsis),
        )
      ),
      body:
          module == null ? const Center(child: Text("Module not found")) :
      ListView(
        padding: const EdgeInsets.only(bottom: 128),
        children: [
          if(module.description != null && module.description!.isNotEmpty)
            Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Html(
                  data: module.description!,
                  onLinkTap: (url, attributes, element) {
                    launchUrl(
                      Uri.parse(url!),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  extensions: const [
                    TableHtmlExtension(),
                  ],
                  style: {
                    "html": Style(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  },
                )),
          for (Module submodule in (module.submodules.toList()..sort((a, b) => a.index - b.index)))
            ModuleTile(
              key: Key(submodule.id.toString()),
              moduleId: submodule.id,
              isar: isar,
              api: api,
            ),
        ],
      ),
    );
  }
}
