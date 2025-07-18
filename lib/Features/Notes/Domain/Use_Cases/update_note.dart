import 'package:notes/Features/Notes/Domain/Entity/notes_entity.dart';
import 'package:notes/Features/Notes/Domain/Repository/notes_repository.dart';

class UpdateNoteUseCase {
  final NoteRepository repository;

  UpdateNoteUseCase(this.repository);

  Future<void> call(NoteEntity note) async {
    return await repository.updateNote(note);
  }
}
