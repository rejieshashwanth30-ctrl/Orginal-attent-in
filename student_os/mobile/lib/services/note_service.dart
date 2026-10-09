import '../models/note.dart';
import 'api_service.dart';
import 'mock_data_service.dart';

class NoteService {
  static Future<ApiResponse<List<Note>>> getNotes({String? search, String? subjectId}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    var list = MockDataService.notes;
    if (subjectId != null && subjectId.isNotEmpty) {
      list = list.where((n) => n.subjectId == subjectId).toList();
    }
    if (search != null && search.trim().isNotEmpty) {
      final q = search.toLowerCase().trim();
      list = list.where((n) => n.title.toLowerCase().contains(q) || n.content.toLowerCase().contains(q) || n.tags.toLowerCase().contains(q)).toList();
    }
    return ApiResponse(success: true, data: List.from(list));
  }

  static Future<ApiResponse<Note>> createNote({
    String? subjectId,
    required String title,
    required String content,
    String tags = '',
    bool isPinned = false,
    String color = '#4F46E5',
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final note = Note(
      id: 'note-${DateTime.now().millisecondsSinceEpoch}',
      userId: MockDataService.currentUser.id,
      subjectId: subjectId,
      title: title,
      content: content,
      tags: tags,
      isPinned: isPinned,
      color: color,
      updatedAt: DateTime.now(),
    );
    MockDataService.notes.insert(0, note);
    return ApiResponse(success: true, data: note);
  }

  static Future<ApiResponse<Note>> updateNote(String id, {
    String? title,
    String? content,
    String? tags,
    bool? isPinned,
    String? color,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = MockDataService.notes.indexWhere((n) => n.id == id);
    if (index != -1) {
      final old = MockDataService.notes[index];
      final updated = Note(
        id: old.id,
        userId: old.userId,
        subjectId: old.subjectId,
        title: title ?? old.title,
        content: content ?? old.content,
        tags: tags ?? old.tags,
        isPinned: isPinned ?? old.isPinned,
        color: color ?? old.color,
        updatedAt: DateTime.now(),
      );
      MockDataService.notes[index] = updated;
      return ApiResponse(success: true, data: updated);
    }
    return ApiResponse(success: false, message: 'Note not found');
  }

  static Future<ApiResponse<dynamic>> deleteNote(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    MockDataService.notes.removeWhere((n) => n.id == id);
    return ApiResponse(success: true, message: 'Deleted');
  }

  static Future<ApiResponse<Note>> togglePin(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = MockDataService.notes.indexWhere((n) => n.id == id);
    if (index != -1) {
      final old = MockDataService.notes[index];
      final updated = Note(
        id: old.id,
        userId: old.userId,
        subjectId: old.subjectId,
        title: old.title,
        content: old.content,
        tags: old.tags,
        isPinned: !old.isPinned,
        color: old.color,
        updatedAt: DateTime.now(),
      );
      MockDataService.notes[index] = updated;
      return ApiResponse(success: true, data: updated);
    }
    return ApiResponse(success: false, message: 'Note not found');
  }
}
