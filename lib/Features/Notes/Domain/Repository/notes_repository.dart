// lib/Features/Notes/Domain/Repositories/note_repository.dart

import 'package:notes/Features/Notes/Domain/Entity/notes_entity.dart';

abstract class NoteRepository {
  Future<void> addNote(NoteEntity note);
  Future<void> updateNote(NoteEntity note);
  Future<void> deleteNote(String id);
  Stream<List<NoteEntity>> getNotes(String uid);
}
