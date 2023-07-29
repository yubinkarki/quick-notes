// Returns a Stream of List of type T.
extension Filter<T> on Stream<List<T>> {
  // Filters the list based on the 'where' function.
  Stream<List<T>> filter(bool Function(T) isCurrentUserNote) {
    return map((items) => items.where(isCurrentUserNote).toList());
  }
}
