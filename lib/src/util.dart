int countBrTags(String text) {
  final regex = RegExp(r'<br\s*/?>', caseSensitive: false);
  return regex.allMatches(text).length;
}