import 'package:flutter/foundation.dart' show immutable;

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

import 'package:okaychata/constants/notes.dart';
import 'package:okaychata/services/note/note_exceptions.dart';

class NoteService {
  Database? _db;

  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabase();

    final getResult = await db.query(
      userTable,
      limit: 1,
      where: "email = ?",
      whereArgs: [email.toLowerCase()],
    );

    if (getResult.isEmpty) {
      throw UserDoesNotExistException();
    } else {
      return DatabaseUser.fromRow(getResult.first);
    }
  }

  // Create a new entry in user table.
  Future<DatabaseUser> createUser({required String email}) async {
    final db = _getDatabase();

    final createResult = await db.query(
      userTable,
      limit: 1,
      where: "email = ?",
      whereArgs: [email.toLowerCase()],
    );

    if (createResult.isNotEmpty) {
      throw UserAlreadyExistsException();
    }

    final int insertedUserId = await db.insert(userTable, {emailColumn: email.toLowerCase()});

    return DatabaseUser(id: insertedUserId, email: email);
  }

  // Delete one row from user table.
  Future<void> deleteUser({required String email}) async {
    final db = _getDatabase();

    final deleteResult = await db.delete(
      userTable,
      where: "email = ?",
      whereArgs: [email.toLowerCase()],
    );

    if (deleteResult != 1) {
      throw CouldNotDeleteUserException();
    }
  }

  Database _getDatabase() {
    final db = _db;

    if (db == null) {
      throw DatabaseNotOpenException();
    } else {
      return db;
    }
  }

  Future<void> close() async {
    final db = _db;

    if (db == null) {
      throw DatabaseAlreadyOpenException();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }

    try {
      final docsPath = await getApplicationDocumentsDirectory(); // Get the 'document' directory details.

      final dbPath = join(docsPath.path, dbName); // Join the path and db name.

      final db = await openDatabase(dbPath); // Open database from given path.

      _db = db;

      await db.execute(createUserTable);

      await db.execute(createNoteTable);
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
  String toString() => "Person: ID = $id, EMAIL = $email";

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
    required this.userId,
    required this.text,
    required this.isSyncedWithCloud,
  });

  DatabaseNote.fromRow(Map<String, Object?> mapItem)
      : id = mapItem[idColumn] as int,
        userId = mapItem[userIdColumn] as int,
        text = mapItem[textColumn] as String,
        isSyncedWithCloud = mapItem[isSyncedWithCloudColumn] as int == 1 ? true : false;

  @override
  String toString() => "Note: ID = $id, User ID = $userId, Text = $text, Cloud = $isSyncedWithCloud";

  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
