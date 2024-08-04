import 'package:okaychata/imports/third_party_imports.dart'
    show
        QuerySnapshot,
        DocumentSnapshot,
        FirebaseFirestore,
        DocumentReference,
        CollectionReference,
        QueryDocumentSnapshot;

import 'package:okaychata/imports/first_party_imports.dart'
    show
        CloudNote,
        textFieldName,
        ownerUserIdFieldName,
        CouldNotUpdateNoteCloudException,
        CouldNotDeleteNoteCloudException,
        CouldNotGetAllNotesCloudException;

class CloudService {
  final CollectionReference<Map<String, dynamic>> notes = FirebaseFirestore.instance.collection('notes');

  static final CloudService _shared = CloudService._sharedInstance();

  // Private constructor.
  CloudService._sharedInstance();

  factory CloudService() => _shared;

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) {
    return notes.snapshots().map(
          (QuerySnapshot<Map<String, dynamic>> event) => event.docs
              .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) => CloudNote.fromSnapshot(doc))
              .where((CloudNote note) => note.ownerUserId == ownerUserId),
        );
  }

  Future<CloudNote> createNewNote({required String text, required String ownerUserId}) async {
    final DocumentReference<Map<String, dynamic>> document = await notes.add(
      <String, dynamic>{
        textFieldName: text,
        ownerUserIdFieldName: ownerUserId,
      },
    );

    final DocumentSnapshot<Map<String, dynamic>> fetchedNote = await document.get();

    return CloudNote(text: text, ownerUserId: ownerUserId, documentId: fetchedNote.id);
  }

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes.where(ownerUserIdFieldName, isEqualTo: ownerUserId).get().then(
            (QuerySnapshot<Map<String, dynamic>> value) => value.docs.map(
              (QueryDocumentSnapshot<Map<String, dynamic>> doc) => CloudNote.fromSnapshot(doc),
            ),
          );
    } catch (e) {
      throw CouldNotGetAllNotesCloudException();
    }
  }

  Future<void> updateNote({required String text, required String documentId}) async {
    try {
      await notes.doc(documentId).update(<Object, Object?>{textFieldName: text});
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
