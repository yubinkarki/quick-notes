import 'package:flutter/material.dart';

import 'package:okaychata/constants/routes.dart';
import 'package:okaychata/enums/menu_action.dart';
import 'package:okaychata/services/auth/auth_service.dart';
import 'package:okaychata/utilities/show_logout_dialog.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main UI"),
        actions: [
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
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text("Log Out"),
                ),
                PopupMenuItem<MenuAction>(
                  value: MenuAction.nothing,
                  child: Text("Nothing"),
                ),
              ];
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.green[200],
        alignment: Alignment.center,
        child: const Text(
          "Hello World",
          style: TextStyle(
            fontSize: 40,
          ),
        ),
      ),
    );
  }
}
