import 'package:okaychata/imports/flutter_imports.dart';

import 'package:okaychata/imports/third_party_imports.dart' show Share;

import 'package:okaychata/imports/first_party_imports.dart'
    show CloudNote, showLDeleteDialog, AppStrings, AppPadding, AppSize;

typedef NoteCallback = void Function(CloudNote note);

class NoteListView extends StatelessWidget {
  final NoteCallback onTapNote;
  final NoteCallback onDeleteNote;
  final Iterable<CloudNote> notes;

  const NoteListView({
    super.key,
    required this.notes,
    required this.onTapNote,
    required this.onDeleteNote,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      padding: const EdgeInsets.only(top: AppPadding.p20, bottom: AppPadding.p50),
      itemBuilder: (BuildContext context, int index) {
        final CloudNote note = notes.elementAt(index);

        return ListTile(
          onTap: () => onTapNote(note),
          contentPadding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
          title: Text(note.text, maxLines: 1, softWrap: true, overflow: TextOverflow.ellipsis),
          trailing: Wrap(
            spacing: AppSize.s6,
            children: <Widget>[
              IconButton(
                iconSize: AppSize.s20,
                icon: const Icon(Icons.share),
                onPressed: () async => await Share.share(note.text, subject: AppStrings.sharingNote),
              ),
              IconButton(
                iconSize: AppSize.s20,
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  final bool shouldDelete = await showLDeleteDialog(context);

                  if (shouldDelete) {
                    onDeleteNote(note);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
