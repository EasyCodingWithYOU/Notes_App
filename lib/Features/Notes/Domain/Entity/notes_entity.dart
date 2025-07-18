// lib/Features/Notes/Domain/Entities/note_entity.dart
class NoteEntity {
  final String id;
  final String title;
  final String message;
  final String uid;

  NoteEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.uid,
  });
}
