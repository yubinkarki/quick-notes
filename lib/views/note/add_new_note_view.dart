import 'package:okaychata/imports/flutter_imports.dart';

import 'package:okaychata/imports/first_party_imports.dart'
    show
        AppSize,
        AuthUser,
        CloudNote,
        AppMargin,
        AppStrings,
        AuthService,
        GetArgument,
        CloudService,
        DoubleExtension,
        StringExtension,
        showGenericDialog;

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
          title: AppStrings.error,
          content: AppStrings.addError,
          optionsBuilder: () => <String, dynamic>{AppStrings.ok: null},
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
          title: AppStrings.success,
          content: AppStrings.noteAdded,
          optionsBuilder: () => <String, dynamic>{AppStrings.ok: null},
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
          title: AppStrings.success,
          content: AppStrings.noteAdded,
          optionsBuilder: () => <String, dynamic>{AppStrings.ok: null},
        ),
      );
    } else {
      Future<dynamic>.delayed(
        const Duration(milliseconds: 200),
        () => showGenericDialog(
          context: context,
          title: AppStrings.error,
          content: AppStrings.updateError,
          optionsBuilder: () => <String, dynamic>{AppStrings.ok: null},
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorTheme = Theme.of(context).colorScheme;
    final CloudNote? widgetNote = context.getArgument<CloudNote>();
    final String? inputTextValue = widgetNote?.text;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        title: Text(AppStrings.addNewNote.titleCase, style: textTheme.titleLarge?.copyWith(color: Colors.white)),
      ),
      body: FutureBuilder<CloudNote?>(
        future: populateTextField(context),
        builder: (BuildContext context, AsyncSnapshot<CloudNote?> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Expanded(
                child: ColoredBox(
                  color: colorTheme.surface,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      AppSize.s20.sizedBoxHeight,
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextField(
                          minLines: 4,
                          maxLines: null,
                          autocorrect: false,
                          controller: _textController,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            hintText: AppStrings.addNote,
                            constraints: BoxConstraints(maxHeight: AppSize.s260),
                          ),
                        ),
                      ),
                      Container(
                        width: AppSize.s120,
                        height: AppSize.s45,
                        margin: const EdgeInsets.only(top: AppMargin.m10, bottom: AppMargin.m50),
                        child: inputTextValue != null
                            ? OutlinedButton(
                                onPressed: _handleUpdateButton,
                                child: Text(AppStrings.update, style: textTheme.labelMedium),
                              )
                            : OutlinedButton(
                                onPressed: _handleAddButton,
                                child: Text(AppStrings.add, style: textTheme.labelMedium),
                              ),
                      ),
                    ],
                  ),
                ),
              );

            default:
              return ColoredBox(
                color: colorTheme.surface,
                child: const Center(child: CircularProgressIndicator()),
              );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
