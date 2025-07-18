import 'package:notes/Features/Notes/Domain/Entity/notes_entity.dart';

abstract class NoteState {}

class NoteInitial extends NoteState {}

class NoteLoading extends NoteState {}

class NoteLoaded extends NoteState {
  final List<NoteEntity> notes;
  NoteLoaded(this.notes);
}

class NoteError extends NoteState {
  final String message;
  NoteError(this.message);
}
