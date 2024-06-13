import 'package:okaychata/imports/flutter_imports.dart';

import 'package:okaychata/imports/third_party_imports.dart' show Share;

import 'package:okaychata/imports/first_party_imports.dart' show CloudNote, showLDeleteDialog;

typedef NoteCallback = void Function(CloudNote note);

class NoteListView extends StatelessWidget {
  final NoteCallback onTapNote;
  final NoteCallback onDeleteNote;
  final Iterable<CloudNote> notes;

  const NoteListView({
    Key? key,
    required this.notes,
    required this.onTapNote,
    required this.onDeleteNote,
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
                  await Share.share(note.text, subject: 'Sharing a Note');
                },
                iconSize: 20,
                icon: const Icon(Icons.share),
              ),
              IconButton(
                onPressed: () async {
                  final shouldDelete = await showLDeleteDialog(context);

                  if (shouldDelete) {
                    onDeleteNote(note);
                  }
                },
                iconSize: 20,
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        );
      },
    );
  }
}
