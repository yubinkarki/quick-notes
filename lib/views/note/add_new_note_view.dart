import 'package:flutter/material.dart';

import 'package:okaychata/services/auth/auth_service.dart';
import 'package:okaychata/services/note/note_service.dart';
import 'package:okaychata/utilities/generics/get_arguments.dart';
import 'package:okaychata/utilities/dialogs/show_generic_dialog.dart';

class AddNewNoteView extends StatefulWidget {
  const AddNewNoteView({Key? key}) : super(key: key);

  @override
  State<AddNewNoteView> createState() => _AddNewNoteViewState();
}

class _AddNewNoteViewState extends State<AddNewNoteView> {
  DatabaseNote? _note;
  late final NoteService _noteService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _noteService = NoteService();
    _textController = TextEditingController();
    super.initState();
  }

  Future<DatabaseNote?> populateTextField(BuildContext context) async {
    final widgetNote = context.getArgument<DatabaseNote>();

    _note = widgetNote;

    _textController.text = widgetNote?.text ?? "";

    return widgetNote;
  }

  void _handleAddButton() async {
    final text = _textController.text;

    FocusManager.instance.primaryFocus?.unfocus();

    if (text.isEmpty) {
      Future.delayed(
        const Duration(milliseconds: 200),
        () => showGenericDialog(
          context: context,
          title: "Error",
          content: "Please write something to add",
          optionsBuilder: () => {"Got It": null},
        ),
      );
    } else {
      final existingUser = AuthService.factoryFirebase().currentUser!;
      final email = existingUser.email!;
      final owner = await _noteService.getUser(email: email);

      await _noteService.createNote(owner: owner, text: text);

      Future.delayed(
        const Duration(milliseconds: 200),
        () => showGenericDialog(
          context: context,
          title: "Success",
          content: "Note added successfully",
          optionsBuilder: () => {"Great": null},
        ),
      );
    }
  }

  void _handleUpdateButton() async {
    final note = _note;
    final text = _textController.text;

    FocusManager.instance.primaryFocus?.unfocus();

    if (text.isNotEmpty && note != null) {
      await _noteService.updateNote(note: note, newText: text);

      Future.delayed(
        const Duration(milliseconds: 200),
        () => showGenericDialog(
          context: context,
          title: "Success",
          content: "Note updated successfully",
          optionsBuilder: () => {"Great": null},
        ),
      );
    } else {
      Future.delayed(
        const Duration(milliseconds: 200),
        () => showGenericDialog(
          context: context,
          title: "Error",
          content: "Please write something to update",
          optionsBuilder: () => {"Got It": null},
        ),
      );
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final widgetNote = context.getArgument<DatabaseNote>();
    final inputTextValue = widgetNote?.text;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "New Note",
          style: textTheme.titleLarge,
        ),
      ),
      body: FutureBuilder(
        future: populateTextField(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: TextField(
                        controller: _textController,
                        keyboardType: TextInputType.multiline,
                        minLines: 4,
                        maxLines: null,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          constraints: BoxConstraints(maxHeight: 250.0),
                          border: OutlineInputBorder(),
                          hintText: "Write your note here...",
                        ),
                      ),
                    ),
                    Container(
                      width: 120.0,
                      height: 45.0,
                      margin: const EdgeInsets.only(top: 10, bottom: 50),
                      child: inputTextValue != null
                          ? OutlinedButton(
                              onPressed: _handleUpdateButton,
                              child: Text(
                                "Update",
                                style: textTheme.labelMedium,
                              ),
                            )
                          : OutlinedButton(
                              onPressed: _handleAddButton,
                              child: Text(
                                "Add",
                                style: textTheme.labelMedium,
                              ),
                            ),
                    ),
                  ],
                ),
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
