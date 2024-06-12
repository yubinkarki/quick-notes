import "package:okaychata/imports/flutter_imports.dart" show immutable;

import "package:okaychata/imports/third_party_imports.dart" show QueryDocumentSnapshot;

import "package:okaychata/imports/first_party_imports.dart" show ownerUserIdFieldName, textFieldName;

@immutable
class CloudNote {
  final String documentId;
  final String ownerUserId;
  final String text;

  const CloudNote({
    required this.documentId,
    required this.ownerUserId,
    required this.text,
  });

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        text = snapshot.data()[textFieldName] as String;
}
