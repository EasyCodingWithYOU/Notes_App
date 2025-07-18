import 'package:notes/Features/Notes/Domain/Entity/notes_entity.dart';

class NoteModel extends NoteEntity {
  NoteModel({
    required super.id,
    required super.title,
    required super.message,
    required super.uid,
  });

  /// For reading from Firebase
  factory NoteModel.fromMap(Map<String, dynamic> map, String id) {
    return NoteModel(
      id: id,
      title: map['title'],
      message: map['message'],
      uid: map['uid'],
    );
  }

  /// For saving to Firebase
  Map<String, dynamic> toMap() => {
    'title': title,
    'message': message,
    'uid': uid,
  };

  /// Converts Entity to Model
  factory NoteModel.fromEntity(NoteEntity entity) {
    return NoteModel(
      id: entity.id,
      title: entity.title,
      message: entity.message,
      uid: entity.uid,
    );
  }
}
