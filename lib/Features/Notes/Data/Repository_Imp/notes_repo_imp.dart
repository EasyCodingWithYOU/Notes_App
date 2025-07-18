import 'package:notes/Features/Notes/Data/Model/notes_model.dart';
import 'package:notes/Features/Notes/Data/Sources/notes_firebase_data_source.dart';
import 'package:notes/Features/Notes/Domain/Entity/notes_entity.dart';
import 'package:notes/Features/Notes/Domain/Repository/notes_repository.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NotesFirebaseDatasource datasource;
  NoteRepositoryImpl(this.datasource);

  @override
  Future<void> addNote(NoteEntity note) =>
      datasource.addNote(NoteModel.fromEntity(note));

  @override
  Future<void> updateNote(NoteEntity note) =>
      datasource.updateNote(NoteModel.fromEntity(note));

  @override
  Future<void> deleteNote(String id) => datasource.deleteNote(id);

  @override
  Stream<List<NoteEntity>> getNotes(String uid) => datasource.getNotes(uid);
}
