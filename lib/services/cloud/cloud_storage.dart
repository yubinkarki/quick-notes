import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:okaychata/constants/cloud_storage.dart';
import 'package:okaychata/services/cloud/cloud_note.dart';
import 'package:okaychata/services/cloud/cloud_storage_exceptions.dart';

class CloudStorage {
  final notes = FirebaseFirestore.instance.collection("notes");

  static final CloudStorage _shared = CloudStorage._sharedInstance();

  // Private constructor.
  CloudStorage._sharedInstance();

  factory CloudStorage() => _shared;

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) {
    return notes.snapshots().map(
          (event) =>
              event.docs.map((doc) => CloudNote.fromSnapshot(doc)).where((note) => note.ownerUserId == ownerUserId),
        );
  }

  Future<void> createNewNote({required String ownerUserId}) async {
    await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: "",
    });
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
            (value) => value.docs.map(
              (doc) {
                return CloudNote(
                  documentId: doc.id,
                  ownerUserId: doc.data()[ownerUserIdFieldName] as String,
                  text: doc.data()[textFieldName] as String,
                );
              },
            ),
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
