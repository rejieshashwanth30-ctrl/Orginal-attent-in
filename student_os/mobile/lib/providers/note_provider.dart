import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/note_service.dart';

class NoteProvider extends ChangeNotifier {
  List<Note> _notes = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  List<Note> get filteredNotes {
    if (_searchQuery.isEmpty) return _notes;
    final q = _searchQuery.toLowerCase();
    return _notes.where((n) {
      return n.title.toLowerCase().contains(q) ||
          n.content.toLowerCase().contains(q) ||
          n.tags.toLowerCase().contains(q);
    }).toList();
  }

  Future<void> fetchNotes({String? search, String? subjectId}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final res = await NoteService.getNotes(search: search, subjectId: subjectId);
    _isLoading = false;
    if (res.success && res.data != null) {
      _notes = res.data!;
    } else {
      _error = res.message;
    }
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<bool> createNote({
    String? subjectId,
    required String title,
    required String content,
    String tags = '',
    bool isPinned = false,
    String color = '#F3F4F6',
  }) async {
    final res = await NoteService.createNote(
      subjectId: subjectId,
      title: title,
      content: content,
      tags: tags,
      isPinned: isPinned,
      color: color,
    );

    if (res.success && res.data != null) {
      _notes.insert(0, res.data!);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> togglePin(String id) async {
    final res = await NoteService.togglePin(id);
    if (res.success && res.data != null) {
      final index = _notes.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notes[index] = res.data!;
        _notes.sort((a, b) {
          if (a.isPinned && !b.isPinned) return -1;
          if (!a.isPinned && b.isPinned) return 1;
          return b.updatedAt.compareTo(a.updatedAt);
        });
        notifyListeners();
      }
    }
  }

  Future<bool> deleteNote(String id) async {
    final res = await NoteService.deleteNote(id);
    if (res.success) {
      _notes.removeWhere((n) => n.id == id);
      notifyListeners();
      return true;
    }
    return false;
  }
}
