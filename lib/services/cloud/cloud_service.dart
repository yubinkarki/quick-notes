import 'package:okaychata/imports/third_party_imports.dart' show FirebaseFirestore;

import 'package:okaychata/imports/first_party_imports.dart'
    show
        CloudNote,
        textFieldName,
        ownerUserIdFieldName,
        CouldNotUpdateNoteCloudException,
        CouldNotDeleteNoteCloudException,
        CouldNotGetAllNotesCloudException;

class CloudService {
  final notes = FirebaseFirestore.instance.collection('notes');

  static final CloudService _shared = CloudService._sharedInstance();

  // Private constructor.
  CloudService._sharedInstance();

  factory CloudService() => _shared;

  // Custom formatting for this block.
  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) {
    return notes.snapshots().map(
          (event) =>
              event.docs.map((doc) => CloudNote.fromSnapshot(doc)).where((note) => note.ownerUserId == ownerUserId),
        );
  }

  Future<CloudNote> createNewNote({
    required String ownerUserId,
    required String text,
  }) async {
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
      throw CouldNotGetAllNotesCloudException();
    }
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNoteCloudException();
    }
  }

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteCloudException();
    }
  }
}
