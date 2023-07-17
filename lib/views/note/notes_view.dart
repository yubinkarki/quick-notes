import 'package:flutter/material.dart';

import 'package:okaychata/constants/colors.dart';
import 'package:okaychata/constants/routes.dart';
import 'package:okaychata/enums/menu_action.dart' show MenuAction;
import 'package:okaychata/services/auth/auth_service.dart' show AuthService;
import 'package:okaychata/services/note/note_service.dart' show NoteService;
import 'package:okaychata/utilities/show_logout_dialog.dart' show showLogoutDialog;

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
    _noteService.open();

    super.initState();
  }

  @override
  void dispose() {
    _noteService.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Notes",
          style: textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(newNoteRoute);
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
                  child: Text(
                    "Nothing",
                    style: textTheme.labelMedium,
                  ),
                ),
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text(
                    "Logout",
                    style: textTheme.labelMedium,
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _noteService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _noteService.allNotes,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.active:
                    case ConnectionState.waiting:
                      return Container(
                        color: Theme.of(context).colorScheme.background,
                        alignment: Alignment.center,
                        child: Text(
                          "Waiting for all notes...",
                          style: textTheme.labelLarge,
                        ),
                      );

                    default:
                      return const Scaffold(
                        body: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                  }
                },
              );

            default:
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
          }
        },
      ),
    );
  }
}
