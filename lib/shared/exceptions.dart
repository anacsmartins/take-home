class ShortenerException implements Exception {
  final String message;
  const ShortenerException(this.message);

  @override
  String toString() => 'ShortenerException: $message';
}
