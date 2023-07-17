import 'package:flutter/material.dart';
import 'package:okaychata/services/auth/auth_service.dart';

import 'package:okaychata/services/note/note_service.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({Key? key}) : super(key: key);

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  DatabaseNote? _note;
  late final NoteService _noteService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _noteService = NoteService();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final note = _note;

    if (note == null) {
      return;
    }

    final text = _textController.text;

    await _noteService.updateNote(note: note, newText: text);
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<DatabaseNote> createNewNote() async {
    final existingNote = _note;

    if (existingNote != null) {
      return existingNote;
    }

    final existingUser = AuthService.factoryFirebase().currentUser!;
    final email = existingUser.email!;
    final owner = await _noteService.getUser(email: email);

    return await _noteService.createNote(owner: owner);
  }

  void _deleteNoteIfTextIsEmpty() async {
    final note = _note;

    if (_textController.text.isEmpty && note != null) {
      await _noteService.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;

    if (text.isNotEmpty && note != null) {
      await _noteService.updateNote(note: note, newText: text);
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text("New Note")),
      body: FutureBuilder(
        future: createNewNote(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _note = snapshot.data as DatabaseNote;

              _setupTextControllerListener();

              return Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  minLines: 4,
                  maxLines: null,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    constraints: BoxConstraints(
                      maxHeight: 300.0,
                    ),
                    border: OutlineInputBorder(),
                    hintText: "Write your note here...",
                  ),
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
      ),
    );
  }
}
