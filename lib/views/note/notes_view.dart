import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:okaychata/constants/routes.dart';
import 'package:okaychata/enums/menu_action.dart' show MenuAction;
import 'package:okaychata/bloc/auth/auth_bloc.dart' show AuthBloc;
import 'package:okaychata/constants/colors.dart' show CustomColors;
import 'package:okaychata/services/cloud/cloud_note.dart' show CloudNote;
import 'package:okaychata/bloc/auth/auth_event.dart' show AuthEventLogout;
import 'package:okaychata/views/note/note_list_view.dart' show NoteListView;
import 'package:okaychata/services/auth/auth_service.dart' show AuthService;
import 'package:okaychata/services/cloud/cloud_service.dart' show CloudService;
import 'package:okaychata/utilities/dialogs/show_logout_dialog.dart' show showLogoutDialog;

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
    return Future.delayed(const Duration(milliseconds: 1500), () => "Delaying");
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
                  if (!mounted) return;

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
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
