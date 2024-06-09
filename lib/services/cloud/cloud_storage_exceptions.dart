class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CouldNotCreateNoteCloudException extends CloudStorageException {}

class CouldNotUpdateNoteCloudException extends CloudStorageException {}

class CouldNotDeleteNoteCloudException extends CloudStorageException {}

class CouldNotGetAllNotesCloudException extends CloudStorageException {}
