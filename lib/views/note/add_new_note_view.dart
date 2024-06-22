import 'package:okaychata/imports/flutter_imports.dart';

import 'package:okaychata/imports/first_party_imports.dart'
    show CloudNote, AuthService, CloudService, GetArgument, showGenericDialog, AuthUser;

class AddNewNoteView extends StatefulWidget {
  const AddNewNoteView({super.key});

  @override
  State<AddNewNoteView> createState() => _AddNewNoteViewState();
}

class _AddNewNoteViewState extends State<AddNewNoteView> {
  CloudNote? _note;
  late final CloudService _noteService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _noteService = CloudService();
    _textController = TextEditingController();
    super.initState();
  }

  Future<CloudNote?> populateTextField(BuildContext context) async {
    final CloudNote? widgetNote = context.getArgument<CloudNote>();

    _note = widgetNote;

    _textController.text = widgetNote?.text ?? '';

    return widgetNote;
  }

  void _handleAddButton() async {
    final String text = _textController.text;

    FocusManager.instance.primaryFocus?.unfocus();

    if (text.isEmpty) {
      Future<dynamic>.delayed(
        const Duration(milliseconds: 200),
        () => showGenericDialog(
          context: context,
          title: 'Error',
          content: 'Please write something to add',
          optionsBuilder: () => <String, dynamic>{'Got It': null},
        ),
      );
    } else {
      final AuthUser existingUser = AuthService.factoryFirebase().currentUser!;
      final String userId = existingUser.id;

      await _noteService.createNewNote(ownerUserId: userId, text: text);

      Future<dynamic>.delayed(
        const Duration(milliseconds: 200),
        () => showGenericDialog(
          context: context,
          title: 'Success',
          content: 'Note added successfully',
          optionsBuilder: () => <String, dynamic>{'Great': null},
        ),
      );
    }
  }

  void _handleUpdateButton() async {
    final CloudNote? note = _note;
    final String text = _textController.text;

    FocusManager.instance.primaryFocus?.unfocus();

    if (text.isNotEmpty && note != null) {
      await _noteService.updateNote(documentId: note.documentId, text: text);

      Future<dynamic>.delayed(
        const Duration(milliseconds: 200),
        () => showGenericDialog(
          context: context,
          title: 'Success',
          content: 'Note updated successfully',
          optionsBuilder: () => <String, dynamic>{'Great': null},
        ),
      );
    } else {
      Future<dynamic>.delayed(
        const Duration(milliseconds: 200),
        () => showGenericDialog(
          context: context,
          title: 'Error',
          content: 'Please write something to update',
          optionsBuilder: () => <String, dynamic>{'Got It': null},
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
    final CloudNote? widgetNote = context.getArgument<CloudNote>();
    final String? inputTextValue = widgetNote?.text;

    return Scaffold(
      appBar: AppBar(
        title: Text('New Note', style: textTheme.titleLarge),
      ),
      body: FutureBuilder<CloudNote?>(
        future: populateTextField(context),
        builder: (BuildContext context, AsyncSnapshot<CloudNote?> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
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
                          hintText: 'Write your note here...',
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
                              child: Text('Update', style: textTheme.labelMedium),
                            )
                          : OutlinedButton(
                              onPressed: _handleAddButton,
                              child: Text('Add', style: textTheme.labelMedium),
                            ),
                    ),
                  ],
                ),
              );

            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
