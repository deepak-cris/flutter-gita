class Verse {
  final int id; // Should not be nullable
  final int chapterNumber;
  final int verseNumber;
  final String text;
  final String transliteration;
  final String wordMeanings;

  Verse({
    required this.id,
    required this.chapterNumber,
    required this.verseNumber,
    required this.text,
    required this.transliteration,
    required this.wordMeanings,
  });

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      id: json['id'] as int,
      chapterNumber: json['chapter_number'] as int,
      verseNumber: json['verse_number'] as int,
      text: json['text'] as String,
      transliteration: json['transliteration'] as String,
      wordMeanings: json['word_meanings'] as String,
    );
  }
}
