import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:md_pro/main.dart';
import 'package:md_pro/models/note.dart';
import 'package:md_pro/viewModel/notes_view_model.dart';
import 'package:provider/provider.dart';

class NotesDrawer extends StatelessWidget {
  final GlobalKey<ScaffoldState> drawerKey;
  const NotesDrawer({super.key, required this.drawerKey});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Drawer(
          width: double.infinity,
          backgroundColor: Colors.transparent,
          child: Stack(
            alignment: AlignmentGeometry.center,
            children: [
              ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 16,
                  bottom: 0,
                  left: 16,
                  right: 16,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Opacity(
                          opacity: 0,
                          child: IconButton(
                            onPressed: () {
                              drawerKey.currentState?.closeDrawer();
                            },
                            icon: Icon(Icons.close),
                          ),
                        ),
                        Text("Notes", style: TextStyle(fontSize: 40)),
                        IconButton(
                          onPressed: () {
                            drawerKey.currentState?.closeDrawer();
                          },
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: NotesList(),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 48,
                child: Column(
                  children: [
                    NotesDrawerSearchBar(parentConstraints: constraints),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class NotesDrawerSearchBar extends StatefulWidget {
  final BoxConstraints parentConstraints;
  const NotesDrawerSearchBar({super.key, required this.parentConstraints});

  @override
  State<NotesDrawerSearchBar> createState() => _NotesDrawerSearchBarState();
}

class _NotesDrawerSearchBarState extends State<NotesDrawerSearchBar> {
  @override
  Widget build(BuildContext context) {
    final notesViewModel = context.watch<NotesViewModel>();
    return SizedBox(
      width: widget.parentConstraints.maxWidth - 64,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(180),
            ),
            child: SearchBar(
              controller: notesViewModel.searchbarController,
              onChanged: (value) => notesViewModel.filterNotes(value),
              side: WidgetStateProperty.resolveWith<BorderSide?>((states) {
                if (states.contains(WidgetState.focused)) {
                  return const BorderSide(color: AppColors.primary, width: 2);
                } else {
                  return BorderSide(
                    color: AppColors.iconContrast.withValues(alpha: 0.5),
                  );
                }
              }),
              backgroundColor: WidgetStatePropertyAll(Colors.transparent),
              elevation: WidgetStatePropertyAll(3),
              trailing: [Icon(Icons.search_outlined)],
            ),
          ),
        ),
      ),
    );
  }
}

class NotesList extends StatelessWidget {
  final ScrollController _controller = ScrollController();
  NotesList({super.key});

  @override
  Widget build(BuildContext context) {
    final notesViewModel = context.watch<NotesViewModel>();

    return Scrollbar(
      radius: Radius.circular(180),
      controller: _controller,
      child: ListView(
        children: notesViewModel.searchbarController.text == ""
            ? notesViewModel.notesList
                  .map((note) => NoteWidget(note: note))
                  .toList()
            : notesViewModel.filteredNotesList
                  .map((note) => NoteWidget(note: note))
                  .toList(),
      ),
    );
  }
}

class NoteWidget extends StatelessWidget {
  final Note note;
  const NoteWidget({super.key, required this.note});

  void confirmClose(BuildContext context, NotesViewModel notesViewModel) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(textAlign: TextAlign.center, "Delete Note"),
          content: Text(
            textAlign: TextAlign.center,
            "NOTES CANNOT BE RESTORED!\nStill delete?",
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 64,
              children: [
                TextButton(
                  onPressed: () {
                    notesViewModel.deleteNote(note.id);
                    notesViewModel.searchbarController.text = "";
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.redAccent),
                  ),
                  child: Text("Delete", style: TextStyle(color: Colors.white)),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    alignment: Alignment.centerLeft,
                    overlayColor: WidgetStateProperty.resolveWith<Color?>((
                      states,
                    ) {
                      if (states.contains(WidgetState.hovered)) {
                        return AppColors.primary.withValues(alpha: 0.6);
                      }
                      if (states.contains(WidgetState.pressed)) {
                        return AppColors.primary.withValues(alpha: 0.6);
                      } else {
                        return null;
                      }
                    }),
                  ),
                  child: const Text(
                    "Keep",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    NotesViewModel notesViewModel = context.watch<NotesViewModel>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: TextButton(
            onPressed: () {
              notesViewModel.currentNoteIndex = notesViewModel.notesList
                  .indexWhere((noteElem) => noteElem.id == note.id);
              context.pop();
            },
            style: ButtonStyle(
              alignment: Alignment.centerLeft,
              overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
                if (states.contains(WidgetState.hovered)) {
                  return AppColors.iconContrast.withValues(alpha: 0.1);
                }
                if (states.contains(WidgetState.pressed)) {
                  return AppColors.iconContrast.withValues(alpha: 0.1);
                } else {
                  return null;
                }
              }),
            ),

            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                  ),
                  Text(
                    note.content,
                    style: TextStyle(color: AppColors.iconContrast),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                  ),
                ],
              ),
            ),
          ),
        ),

        IconButton(
          onPressed: () => {confirmClose(context, notesViewModel)},
          icon: Icon(Icons.delete_outline, color: AppColors.iconContrast),
          style: ButtonStyle(
            alignment: Alignment.centerLeft,
            overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
              if (states.contains(WidgetState.hovered)) {
                return Colors.red;
              }
              if (states.contains(WidgetState.pressed)) {
                return Colors.red;
              } else {
                return null;
              }
            }),
          ),
        ),
      ],
    );
  }
}
