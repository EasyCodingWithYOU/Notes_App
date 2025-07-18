import 'package:notes/Features/Notes/Domain/Entity/notes_entity.dart';

abstract class NoteEvent {}

class LoadNotes extends NoteEvent {
  final String uid;
  LoadNotes(this.uid);
}

class AddNewNote extends NoteEvent {
  final NoteEntity note;
  AddNewNote(this.note);
}

class UpdateNoteEvent extends NoteEvent {
  final NoteEntity note;
  UpdateNoteEvent(this.note);
}

class DeleteNoteEvent extends NoteEvent {
  final String id;
  DeleteNoteEvent(this.id);
}
