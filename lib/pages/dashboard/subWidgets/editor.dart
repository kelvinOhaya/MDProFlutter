import 'package:flutter/material.dart';
import 'package:flutter_md/flutter_md.dart';
import 'package:md_pro/viewModel/notes_view_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Editor extends StatelessWidget {
  const Editor({super.key});

  @override
  Widget build(BuildContext context) {
    final notesViewModel = context.watch<NotesViewModel>();
    return Stack(
      children: [
        notesViewModel.isLive
            ? SingleChildScrollView(
                child: MarkdownTheme(
                  data: MarkdownThemeData.mergeTheme(
                    Theme.of(context),
                    onLinkTap: (title, url) async {
                      final uri = Uri.tryParse(url);
                      if (uri == null) return;
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    },
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: MarkdownWidget(markdown: notesViewModel.markdown),
                    ),
                  ),
                ),
              )
            : TextFormField(
                controller: notesViewModel.contentController,
                onChanged: (value) {
                  notesViewModel.debouncer.run(() {
                    notesViewModel.saveCurrentNote(
                      notesViewModel
                          .notesList[notesViewModel.currentNoteIndex]
                          .id,
                    );
                  });
                },
                maxLines: null,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
              ),
      ],
    );
  }
}
