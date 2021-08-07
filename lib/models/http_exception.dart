class HttpExceprion implements Exception {
  final String message;

  HttpExceprion(this.message);

  @override
  String toString() {
    return message;
  }
}
