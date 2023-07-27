import 'package:flutter/material.dart';

import 'package:okaychata/constants/routes.dart';
import 'package:okaychata/views/note/note_list_view.dart';
import 'package:okaychata/enums/menu_action.dart' show MenuAction;
import 'package:okaychata/constants/colors.dart' show CustomColors;
import 'package:okaychata/services/auth/auth_service.dart' show AuthService;
import 'package:okaychata/services/note/note_service.dart' show NoteService, DatabaseNote;
import 'package:okaychata/utilities/dialogs/show_logout_dialog.dart' show showLogoutDialog;

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NoteService _noteService;

  String get userEmail => AuthService.factoryFirebase().currentUser!.email!;

  @override
  void initState() {
    _noteService = NoteService();
    super.initState();
  }

  Future<String> futureCreateUser() async {
    await _noteService.getOrCreateUser(email: userEmail);

    return Future.delayed(const Duration(seconds: 1), () => "Delaying");
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Notes", style: textTheme.titleLarge),
        actions: [
          IconButton(
            tooltip: "Add new note here",
            onPressed: () {
              Navigator.of(context).pushNamed(addNewNoteRoute);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogoutDialog(context);

                  if (shouldLogout) {
                    AuthService.factoryFirebase().logOut();

                    if (!mounted) return;

                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
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
                  child: Text("Nothing", style: textTheme.labelMedium),
                ),
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text("Logout", style: textTheme.labelMedium),
                ),
              ];
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: futureCreateUser(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _noteService.allNotes,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                    case ConnectionState.active:
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        final allNotes = snapshot.data as List<DatabaseNote>;

                        return NoteListView(
                          notes: allNotes,
                          onDeleteNote: (note) async {
                            await _noteService.deleteNote(id: note.id);
                          },
                          onTapNote: (note) {
                            Navigator.of(context).pushNamed(
                              addNewNoteRoute,
                              arguments: note,
                            );
                          },
                        );
                      } else {
                        return Container(
                          color: Theme.of(context).colorScheme.background,
                          alignment: Alignment.center,
                          child: Text(
                            "There are no notes right now...",
                            style: textTheme.labelMedium,
                          ),
                        );
                      }

                    default:
                      return const Placeholder(color: CustomColors.transparent);
                  }
                },
              );

            default:
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }
}
