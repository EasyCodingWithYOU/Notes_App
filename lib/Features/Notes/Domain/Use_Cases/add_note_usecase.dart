import 'package:notes/Features/Notes/Domain/Entity/notes_entity.dart';
import 'package:notes/Features/Notes/Domain/Repository/notes_repository.dart';

class AddNote {
  final NoteRepository repository;
  AddNote(this.repository);

  Future<void> call(NoteEntity note) => repository.addNote(note);
}
