import 'package:notes/Features/Notes/Domain/Entity/notes_entity.dart';
import 'package:notes/Features/Notes/Domain/Repository/notes_repository.dart';

class GetNotesUseCase {
  final NoteRepository repository;

  GetNotesUseCase(this.repository);

  Stream<List<NoteEntity>> call(String uid) {
    return repository.getNotes(uid);
  }
}
