import 'package:notes/Features/Notes/Domain/Repository/notes_repository.dart';

class DeleteNoteUseCase {
  final NoteRepository repository;

  DeleteNoteUseCase(this.repository);

  Future<void> call(String noteId) async {
    return await repository.deleteNote(noteId);
  }
}
