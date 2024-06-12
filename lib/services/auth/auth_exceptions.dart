// Login exceptions.
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

// Register exceptions.
class WeakPasswordAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

class EmailAlreadyUsedAuthException implements Exception {}

// Generic exceptions.
class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}

// For test cases.
class NotInitializedException implements Exception {}
