import 'package:flutter/material.dart';

import 'package:share_plus/share_plus.dart' show Share;

import 'package:okaychata/services/cloud/cloud_note.dart' show CloudNote;
import 'package:okaychata/utilities/dialogs/show_delete_dialog.dart' show showLDeleteDialog;

typedef NoteCallback = void Function(CloudNote note);

class NoteListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTapNote;

  const NoteListView({
    Key? key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTapNote,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes.elementAt(index);

        return ListTile(
          onTap: () => onTapNote(note),
          title: Text(
            note.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Wrap(
            spacing: 5,
            children: <Widget>[
              IconButton(
                onPressed: () async {
                  Share.share(note.text, subject: "Sharing a Note");
                },
                icon: const Icon(Icons.share),
                iconSize: 20,
              ),
              IconButton(
                onPressed: () async {
                  final shouldDelete = await showLDeleteDialog(context);

                  if (shouldDelete) {
                    onDeleteNote(note);
                  }
                },
                icon: const Icon(Icons.delete),
                iconSize: 20,
              ),
            ],
          ),
        );
      },
    );
  }
}
