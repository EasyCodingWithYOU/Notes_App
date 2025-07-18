import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/Features/Notes/Domain/Entity/notes_entity.dart';
import 'package:notes/Features/Notes/Domain/Use_Cases/add_note_usecase.dart';
import 'package:notes/Features/Notes/Domain/Use_Cases/delete_note.dart';
import 'package:notes/Features/Notes/Domain/Use_Cases/get_notes.dart';
import 'package:notes/Features/Notes/Domain/Use_Cases/update_note.dart';
import 'package:notes/Features/Notes/Presentation/bloc/notes_event.dart';
import 'package:notes/Features/Notes/Presentation/bloc/notes_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final AddNote addNoteUseCase;
  final GetNotesUseCase getNotesUseCase;
  final UpdateNoteUseCase updateNoteUseCase;
  final DeleteNoteUseCase deleteNoteUseCase;

  NoteBloc({
    required this.addNoteUseCase,
    required this.getNotesUseCase,
    required this.updateNoteUseCase,
    required this.deleteNoteUseCase,
  }) : super(NoteInitial()) {
    on<LoadNotes>((event, emit) async {
      emit(NoteLoading());
      await emit.forEach<List<NoteEntity>>(
        getNotesUseCase(event.uid),
        onData: (notes) => NoteLoaded(notes),
        onError: (e, _) => NoteError(e.toString()),
      );
    });

    on<AddNewNote>((event, emit) async {
      await addNoteUseCase(event.note);
    });

    on<UpdateNoteEvent>((event, emit) async {
      await updateNoteUseCase(event.note);
    });

    on<DeleteNoteEvent>((event, emit) async {
      await deleteNoteUseCase(event.id);
    });
  }
}
