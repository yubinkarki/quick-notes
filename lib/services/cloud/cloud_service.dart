import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:okaychata/constants/cloud_storage.dart';
import 'package:okaychata/services/cloud/cloud_storage_exceptions.dart';
import 'package:okaychata/services/cloud/cloud_note.dart' show CloudNote;

class CloudStorage {
  final notes = FirebaseFirestore.instance.collection("notes");

  static final CloudStorage _shared = CloudStorage._sharedInstance();

  // Private constructor.
  CloudStorage._sharedInstance();

  factory CloudStorage() => _shared;

  // Custom formatting for this block.
  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) {
    return notes.snapshots().map(
          (event) =>
              event.docs.map((doc) => CloudNote.fromSnapshot(doc))
              .where((note) => note.ownerUserId == ownerUserId),
        );
  }

  Future<CloudNote> createNewNote({required String ownerUserId, required String text}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: text,
    });

    final fetchedNote = await document.get();

    return CloudNote(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      text: text,
    );
  }

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
            (value) => value.docs.map((doc) => CloudNote.fromSnapshot(doc)),
          );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Future<void> updateNote({required String documentId, required String text}) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }
}
