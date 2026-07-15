const maxDailyQuoteTextLength = 180;

String? normalizeDailyQuoteText(String? value) {
  final normalized = value?.trim();
  if (normalized == null || normalized.isEmpty) return null;
  if (normalized.runes.length > maxDailyQuoteTextLength) return null;
  return normalized;
}

String? normalizeDailyQuoteAuthor(String? value) {
  final normalized = value?.trim();
  return normalized == null || normalized.isEmpty ? null : normalized;
}

class DailyQuote {
  final String text;
  final String? author;

  const DailyQuote({required this.text, this.author});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyQuote &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          author == other.author;

  @override
  int get hashCode => text.hashCode ^ author.hashCode;
}
