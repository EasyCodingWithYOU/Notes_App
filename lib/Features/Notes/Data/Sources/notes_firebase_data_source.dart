// lib/Features/Notes/Data/DataSources/notes_firebase_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/Features/Notes/Data/Model/notes_model.dart';

class NotesFirebaseDatasource {
  final notesCollection = FirebaseFirestore.instance.collection('notes');

  Future<void> addNote(NoteModel note) {
    return notesCollection.add(note.toMap());
  }

  Future<void> updateNote(NoteModel note) {
    return notesCollection.doc(note.id).update(note.toMap());
  }

  Future<void> deleteNote(String id) {
    return notesCollection.doc(id).delete();
  }

  Stream<List<NoteModel>> getNotes(String uid) {
    return notesCollection
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => NoteModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }
}
