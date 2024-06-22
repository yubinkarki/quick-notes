import 'package:okaychata/imports/flutter_imports.dart';

import 'package:okaychata/imports/third_party_imports.dart' show ReadContext;

import 'package:okaychata/imports/first_party_imports.dart'
    show
        Count,
        AuthBloc,
        CloudNote,
        MenuAction,
        AppStrings,
        AuthService,
        CloudService,
        CustomColors,
        NoteListView,
        addNewNoteRoute,
        AuthEventLogout,
        showLogoutDialog;

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final CloudService _noteService;

  String get userId => AuthService.factoryFirebase().currentUser!.id;

  @override
  void initState() {
    _noteService = CloudService();
    super.initState();
  }

  Future<String> fakeDelay() async {
    return await Future<String>.delayed(const Duration(milliseconds: 1500), () => AppStrings.delaying);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<int>(
          stream: _noteService.allNotes(ownerUserId: userId).getLength,
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            if (snapshot.hasData) {
              final int noteCount = snapshot.data ?? 0;

              return Text(AppStrings.notesCount(noteCount), style: textTheme.titleLarge);
            } else {
              return Text(AppStrings.empty, style: textTheme.titleLarge);
            }
          },
        ),
        actions: <Widget>[
          IconButton(
            tooltip: AppStrings.addNewNote,
            onPressed: () => Navigator.of(context).pushNamed(addNewNoteRoute),
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (MenuAction value) async {
              switch (value) {
                case MenuAction.logout:
                  final bool shouldLogout = await showLogoutDialog(context);
                  if (!context.mounted) return;

                  if (shouldLogout) {
                    context.read<AuthBloc>().add(const AuthEventLogout());
                  }
                  break;

                case MenuAction.nothing:
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<MenuAction>>[
                PopupMenuItem<MenuAction>(
                  value: MenuAction.nothing,
                  child: Text(AppStrings.nothing, style: textTheme.labelMedium),
                ),
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text(AppStrings.logout, style: textTheme.labelMedium),
                ),
              ];
            },
          ),
        ],
      ),
      body: FutureBuilder<String>(
        future: fakeDelay(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder<Iterable<CloudNote>>(
                stream: _noteService.allNotes(ownerUserId: userId),
                builder: (BuildContext context, AsyncSnapshot<Iterable<CloudNote>> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                    case ConnectionState.active:
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        final Iterable<CloudNote> allNotes = snapshot.data as Iterable<CloudNote>;

                        return NoteListView(
                          notes: allNotes,
                          onDeleteNote: (CloudNote note) async {
                            await _noteService.deleteNote(documentId: note.documentId);
                          },
                          onTapNote: (CloudNote note) => Navigator.of(context).pushNamed(
                            addNewNoteRoute,
                            arguments: note,
                          ),
                        );
                      } else {
                        return Container(
                          color: Theme.of(context).colorScheme.surface,
                          alignment: Alignment.center,
                          child: Text(AppStrings.noNotes, style: textTheme.labelMedium),
                        );
                      }

                    default:
                      return const Placeholder(color: CustomColors.transparent);
                  }
                },
              );

            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
