const String idColumn = 'id';
const String noteTable = 'note';
const String userTable = 'user';
const String dbName = 'notes.db';
const String textColumn = 'text';
const String emailColumn = 'email';
const String userIdColumn = 'user_id'; // This is FK in 'notes' table.
const String isSyncedWithCloudColumn = 'is_synced_with_cloud';

const String createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
        "id" INTEGER NOT NULL,
        "email" TEXT NOT NULL UNIQUE,
        PRIMARY KEY("id" AUTOINCREMENT));
        ''';

const String createNoteTable = '''CREATE TABLE IF NOT EXISTS "note" (
        "id" INTEGER NOT NULL,
        "user_id" INTEGER NOT NULL,
        "text" TEXT,
        "is_synced_with_cloud" INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY("user_id") REFERENCES "user"("id"),
        PRIMARY KEY("id" AUTOINCREMENT));
        ''';
