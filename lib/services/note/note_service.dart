import 'package:okaychata/imports/dart_imports.dart' show StreamController, Directory;

import 'package:okaychata/imports/flutter_imports.dart' show immutable;

import 'package:okaychata/imports/third_party_imports.dart'
    show join, Database, openDatabase, getApplicationDocumentsDirectory, MissingPlatformDirectoryException;

import 'package:okaychata/imports/first_party_imports.dart';

class NoteService {
  Database? _db;
  DatabaseUser? _user;

  List<DatabaseNote> _notes = <DatabaseNote>[];

  late final StreamController<List<DatabaseNote>> _notesStreamController;

  // Creating a singleton of NoteService.
  static final NoteService _shared = NoteService._sharedInstance();

  NoteService._sharedInstance() {
    _notesStreamController = StreamController<List<DatabaseNote>>.broadcast(
      onListen: () {
        _notesStreamController.sink.add(_notes);
      },
    );
  }

  factory NoteService() => _shared;

  // Getting all notes from current user only.
  Stream<List<DatabaseNote>> get allNotes {
    return _notesStreamController.stream.filter((DatabaseNote note) {
      final DatabaseUser? currentUser = _user;

      if (currentUser != null) {
        return note.userId == currentUser.id;
      } else {
        throw UserNotSetException();
      }
    });
  }

  Future<DatabaseUser> getOrCreateUser({
    required String email,
    bool setAsCurrentUser = true,
  }) async {
    try {
      final DatabaseUser existingUser = await getUser(email: email);

      if (setAsCurrentUser) {
        _user = existingUser;
      }

      return existingUser;
    } on UserDoesNotExistException {
      final DatabaseUser createdUser = await createUser(email: email);

      if (setAsCurrentUser) {
        _user = createdUser;
      }

      return createdUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _cacheNotes() async {
    final Iterable<DatabaseNote> allNotes = await getAllNotes();

    _notes = allNotes.toList();
    _notesStreamController.add(_notes);
  }

  Future<DatabaseNote> updateNote({required DatabaseNote note, required String newText}) async {
    await _ensureOpenDb();

    final Database db = _getDatabase();

    // Make sure note exists.
    await getNote(id: note.id);

    // Update database.
    final int updateCount = await db.update(
      noteTable,
      <String, Object?>{
        textColumn: newText,
        isSyncedWithCloudColumn: 0,
      },
      where: 'id = ?',
      whereArgs: <Object?>[note.id],
    );

    if (updateCount == 0) {
      throw CouldNotUpdateNoteException();
    } else {
      final DatabaseNote updatedNote = await getNote(id: note.id);

      _notes.removeWhere((DatabaseNote note) => note.id == updatedNote.id);
      _notes.add(updatedNote);
      _notesStreamController.add(_notes);

      return updatedNote;
    }
  }

  Future<Iterable<DatabaseNote>> getAllNotes() async {
    await _ensureOpenDb();

    final Database db = _getDatabase();

    final List<Map<String, Object?>> notes = await db.query(noteTable);

    return notes.map((Map<String, Object?> note) => DatabaseNote.fromRow(note));
  }

  Future<DatabaseNote> getNote({required int id}) async {
    await _ensureOpenDb();

    final Database db = _getDatabase();

    final List<Map<String, Object?>> notes = await db.query(
      noteTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: <Object?>[id],
    );

    if (notes.isEmpty) {
      throw CouldNotFindNoteException();
    } else {
      final DatabaseNote note = DatabaseNote.fromRow(notes.first);

      _notes.removeWhere((DatabaseNote note) => note.id == id);
      _notes.add(note);
      _notesStreamController.add(_notes);

      return note;
    }
  }

  Future<int> deleteAllNotes() async {
    await _ensureOpenDb();

    final Database db = _getDatabase();

    final int numberOfDeletions = await db.delete(noteTable);

    _notes = <DatabaseNote>[];
    _notesStreamController.add(_notes);

    return numberOfDeletions;
  }

  Future<void> deleteNote({required int id}) async {
    await _ensureOpenDb();

    final Database db = _getDatabase();

    final int deletedCount = await db.delete(
      noteTable,
      where: 'id = ?',
      whereArgs: <Object?>[id],
    );

    if (deletedCount == 0) {
      throw CouldNotDeleteNoteException();
    } else {
      _notes.removeWhere((DatabaseNote note) => note.id == id);
      _notesStreamController.add(_notes);
    }
  }

  Future<DatabaseNote> createNote({required DatabaseUser owner, required String text}) async {
    await _ensureOpenDb();

    final Database db = _getDatabase();

    // Make sure owner exists in the database.
    final DatabaseUser dbUser = await getUser(email: owner.email);

    if (dbUser != owner) {
      throw UserDoesNotExistException();
    }

    // Create a note.
    final int noteId = await db.insert(
      noteTable,
      <String, Object?>{userIdColumn: owner.id, textColumn: text, isSyncedWithCloudColumn: 1},
    );

    final DatabaseNote note = DatabaseNote(
      id: noteId,
      userId: owner.id,
      text: text,
      isSyncedWithCloud: true,
    );

    _notes.add(note);
    _notesStreamController.add(_notes);

    return note;
  }

  Future<DatabaseUser> getUser({required String email}) async {
    await _ensureOpenDb();

    final Database db = _getDatabase();

    final List<Map<String, Object?>> getResult = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: <Object?>[email.toLowerCase()],
    );

    if (getResult.isEmpty) {
      throw UserDoesNotExistException();
    } else {
      return DatabaseUser.fromRow(getResult.first);
    }
  }

  // Create a new entry in user table.
  Future<DatabaseUser> createUser({required String email}) async {
    await _ensureOpenDb();

    final Database db = _getDatabase();

    final List<Map<String, Object?>> createResult = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: <Object?>[email.toLowerCase()],
    );

    if (createResult.isNotEmpty) {
      throw UserAlreadyExistsException();
    }

    final int insertedUserId = await db.insert(userTable, <String, Object?>{emailColumn: email.toLowerCase()});

    return DatabaseUser(id: insertedUserId, email: email);
  }

  // Delete one row from user table.
  Future<void> deleteUser({required String email}) async {
    await _ensureOpenDb();

    final Database db = _getDatabase();

    final int deleteResult = await db.delete(
      userTable,
      where: 'email = ?',
      whereArgs: <Object?>[email.toLowerCase()],
    );

    if (deleteResult != 1) {
      throw CouldNotDeleteUserException();
    }
  }

  Database _getDatabase() {
    final Database? db = _db;

    if (db == null) {
      throw DatabaseNotOpenException();
    } else {
      return db;
    }
  }

  Future<void> close() async {
    final Database? db = _db;

    if (db == null) {
      throw DatabaseAlreadyOpenException();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> _ensureOpenDb() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {
      // Nothing to see here.
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }

    try {
      final Directory docsPath = await getApplicationDocumentsDirectory(); // Get the 'document' directory details.

      final String dbPath = join(docsPath.path, dbName); // Join the path and db name.

      final Database db = await openDatabase(dbPath); // Open database from given path.

      _db = db;

      await db.execute(createUserTable);

      await db.execute(createNoteTable);

      await _cacheNotes();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;

  // Default constructor.
  const DatabaseUser({required this.id, required this.email});

  // Named constructor 'fromRow'. The colon initializes instance variables before running the constructor body.
  DatabaseUser.fromRow(Map<String, Object?> mapItem)
      : id = mapItem[idColumn] as int,
        email = mapItem[emailColumn] as String;

  @override
  String toString() => 'Person: ID = $id, EMAIL = $email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  DatabaseNote({
    required this.id,
    required this.text,
    required this.userId,
    required this.isSyncedWithCloud,
  });

  DatabaseNote.fromRow(Map<String, Object?> mapItem)
      : id = mapItem[idColumn] as int,
        userId = mapItem[userIdColumn] as int,
        text = mapItem[textColumn] as String,
        isSyncedWithCloud = mapItem[isSyncedWithCloudColumn] as int == 1 ? true : false;

  @override
  String toString() => 'Note: ID = $id, User ID = $userId, Text = $text, Cloud = $isSyncedWithCloud';

  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
