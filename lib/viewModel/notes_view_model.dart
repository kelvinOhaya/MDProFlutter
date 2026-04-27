import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_md/flutter_md.dart';
import 'package:md_pro/models/note.dart';
import 'package:flutter/services.dart';
import 'package:md_pro/utils/debouncer.dart';
import 'package:md_pro/utils/utils.dart';
import 'dart:convert';

class NotesViewModel extends ChangeNotifier {
  bool isLive = false;
  List<Note> notesList = [];
  List<Note> filteredNotesList = [];
  int _currentNoteIndex = 0;
  String? _currentNoteId;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController searchbarController = TextEditingController();
  Debouncer debouncer = Debouncer(delay: Duration(milliseconds: 600));
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  StreamSubscription<User?>? authSubscription;
  StreamSubscription<List<Note>>? notesSubscription;
  bool _isSeedingNotes = false;

  NotesViewModel() {
    authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        notesSubscription?.cancel();
        notesList = [];
        filteredNotesList = [];
        _currentNoteIndex = 0;
        _currentNoteId = null;
        titleController.clear();
        contentController.clear();
        notifyListeners();
        return;
      }

      _startListening(user.uid);
    });
  }

  void _startListening(String uid) {
    notesSubscription?.cancel();
    notesSubscription = _db
        .collection('users')
        .doc(uid)
        .collection('notes')
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Note.fromMap({'id': doc.id, ...doc.data()}))
              .toList(),
        )
        .listen((newList) {
          notesList = newList;

          if (notesList.isEmpty) {
            _seedInitialNotes();
            notifyListeners();
            return;
          }

          if (_currentNoteId == null ||
              !notesList.any((note) => note.id == _currentNoteId)) {
            _currentNoteId = notesList.first.id;
          }

          final resolvedIndex = notesList.indexWhere(
            (note) => note.id == _currentNoteId,
          );

          if (resolvedIndex == -1) {
            _currentNoteIndex = 0;
            _currentNoteId = notesList.first.id;
          } else {
            _currentNoteIndex = resolvedIndex;
          }

          final activeNote = notesList[_currentNoteIndex];
          if (titleController.text != activeNote.title) {
            titleController.text = activeNote.title;
          }
          if (contentController.text != activeNote.content) {
            contentController.text = activeNote.content;
          }
          notifyListeners();
        });
  }

  int get currentNoteIndex => _currentNoteIndex;
  String? get currentNoteId => _currentNoteId;
  set currentNoteIndex(int newIndex) {
    if (newIndex < 0 || newIndex > notesList.length - 1) return;
    _currentNoteIndex = newIndex;
    _currentNoteId = notesList[newIndex].id;
    titleController.text = notesList[newIndex].title;
    contentController.text = notesList[newIndex].content;
    notifyListeners();
  }

  Future<List<dynamic>> readJson() async {
    final String response = await rootBundle.loadString(
      'assets/dummy_data.json',
    );
    final data = json.decode(response) as List<dynamic>;
    return data;
  }

  Future<void> _seedInitialNotes() async {
    if (_isSeedingNotes) return;
    _isSeedingNotes = true;

    try {
      final seededNotes = await _buildNotesFromAsset();
      notesList = seededNotes;
      if (notesList.isNotEmpty) {
        _currentNoteIndex = 0;
        _currentNoteId = notesList.first.id;
        titleController.text = notesList.first.title;
        contentController.text = notesList.first.content;
      }
      notifyListeners();

      final batch = _db.batch();
      for (final note in seededNotes) {
        batch.set(_userNotesRef.doc(note.id), {
          'title': note.title,
          'content': note.content,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
      await batch.commit();
    } finally {
      _isSeedingNotes = false;
    }
  }

  Future<List<Note>> _buildNotesFromAsset() async {
    final data = await readJson();
    return data.map((item) {
      final map = Map<String, dynamic>.from(item as Map);
      return Note(
        title: (map['title'] ?? '').toString(),
        content: (map['content'] ?? '').toString(),
        id: _userNotesRef.doc().id,
        updatedAt: DateTime.now(),
      );
    }).toList();
  }

  Future<void> saveCurrentNote(String noteId) async {
    final int noteIndex = notesList.indexWhere((note) => note.id == noteId);
    if (noteIndex == -1) return;

    Note currentNote = notesList[noteIndex];
    currentNote.title = titleController.text;
    currentNote.content = contentController.text;
    await _userNotesRef.doc(noteId).update({
      'title': currentNote.title,
      'content': currentNote.content,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  void filterNotes(String value) {
    filteredNotesList = notesList
        .where(
          (note) => '${note.title}${note.content}'.toLowerCase().contains(
            value.toLowerCase(),
          ),
        )
        .toList();
    filteredNotesList.sort((a, b) {
      return Utils.countCommonCharacters(
        '${a.title}${a.content}',
        value,
      ).compareTo(Utils.countCommonCharacters('${b.title}${b.content}', value));
    });
    notifyListeners();
  }

  Future<void> deleteNote(String noteId) async {
    await _userNotesRef.doc(noteId).delete();
    notifyListeners();
  }

  Future<void> addNote() async {
    final docRef = _userNotesRef.doc();
    final newNote = Note(
      title: 'Untitled',
      content: 'make notes here...',
      id: docRef.id,
      updatedAt: DateTime.now(),
    );

    notesList.insert(0, newNote);
    filteredNotesList = notesList;
    _currentNoteIndex = 0;
    _currentNoteId = newNote.id;
    titleController.text = newNote.title;
    contentController.text = newNote.content;
    notifyListeners();

    await docRef.set({
      'title': newNote.title,
      'content': newNote.content,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  void toggleIsLive() {
    bool prevIsLive = isLive;
    isLive = !prevIsLive;
    notifyListeners();
  }

  @override
  void dispose() {
    authSubscription?.cancel();
    notesSubscription?.cancel();
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  CollectionReference get _userNotesRef {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception("No user logged in");

    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('notes');
  }

  Markdown get markdown => Markdown.fromString(contentController.text);
}
