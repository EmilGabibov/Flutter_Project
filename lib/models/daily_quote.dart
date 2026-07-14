class DailyQuote {
  final String text;
  final String? author;

  const DailyQuote({
    required this.text,
    this.author,
  });

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
