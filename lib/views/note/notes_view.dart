import "package:okaychata/imports/flutter_imports.dart";

import "package:okaychata/imports/third_party_imports.dart" show ReadContext;

import "package:okaychata/imports/first_party_imports.dart"
    show
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

extension Count<T extends Iterable> on Stream<T> {
  Stream<int> get getLength => map((event) => event.length);
}

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
    return await Future.delayed(const Duration(milliseconds: 1500), () => AppStrings.delaying);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<int>(
          stream: _noteService.allNotes(ownerUserId: userId).getLength,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final int noteCount = snapshot.data ?? 0;

              return Text(AppStrings.notesCount(noteCount), style: textTheme.titleLarge);
            } else {
              return Text(AppStrings.empty, style: textTheme.titleLarge);
            }
          },
        ),
        actions: [
          IconButton(
            tooltip: AppStrings.addNewNote,
            onPressed: () => Navigator.of(context).pushNamed(addNewNoteRoute),
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogoutDialog(context);
                  if (!context.mounted) return;

                  if (shouldLogout) {
                    context.read<AuthBloc>().add(const AuthEventLogout());
                  }
                  break;

                case MenuAction.nothing:
                  break;
              }
            },
            itemBuilder: (context) {
              return [
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
      body: FutureBuilder(
        future: fakeDelay(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _noteService.allNotes(ownerUserId: userId),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                    case ConnectionState.active:
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        final allNotes = snapshot.data as Iterable<CloudNote>;

                        return NoteListView(
                          notes: allNotes,
                          onDeleteNote: (note) async {
                            await _noteService.deleteNote(documentId: note.documentId);
                          },
                          onTapNote: (note) => Navigator.of(context).pushNamed(
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
