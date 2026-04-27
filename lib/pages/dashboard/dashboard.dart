import 'package:flutter/material.dart';
import 'package:md_pro/main.dart';
import 'package:md_pro/pages/dashboard/subWidgets/editor.dart';
import 'package:md_pro/pages/dashboard/subWidgets/notes_drawer.dart';
import 'package:md_pro/services/auth_service.dart';
import 'package:md_pro/viewModel/notes_view_model.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();
  Dashboard({super.key});
  @override
  Widget build(BuildContext context) {
    final notesViewModel = context.watch<NotesViewModel>();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 26, 26, 26),
      key: scaffoldStateKey,
      drawer: NotesDrawer(drawerKey: scaffoldStateKey),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                notesViewModel.addNote();
              },
              tooltip: 'create a note',
              icon: Icon(Icons.add, size: 40),
            ),
            IconButton(
              onPressed: () => {scaffoldStateKey.currentState?.openDrawer()},
              tooltip: 'notes',
              icon: Icon(Icons.description_outlined, size: 40),
            ),
            IconButton(
              onPressed: () => {AuthService.signOut()},
              tooltip: 'logout',
              icon: Icon(Icons.logout, size: 40),
            ),
          ],
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: EdgeInsets.only(top: 8, right: 32, bottom: 32, left: 32),
            child: Column(
              children: [
                //title
                TextFormField(
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                  controller: notesViewModel.titleController,
                  onChanged: (value) => notesViewModel.debouncer.run(() {
                    final noteId = notesViewModel.currentNoteId;
                    if (noteId == null) return;
                    notesViewModel.saveCurrentNote(noteId);
                  }),
                ),
                Expanded(child: Editor()),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 3,
        shape: CircleBorder(),
        tooltip: notesViewModel.isLive ? 'raw text' : 'preview',
        onPressed: () {
          notesViewModel.toggleIsLive();
        },
        backgroundColor: AppColors.primary,
        child: notesViewModel.isLive
            ? Icon(Icons.pause, size: 48)
            : Icon(Icons.play_arrow, size: 48),
      ),
    );
  }
}
