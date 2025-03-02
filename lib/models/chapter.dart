class Chapter {
  final int chapterNumber;
  final String name;
  final String nameMeaning;
  final int versesCount;
  final String chapterSummary;

  Chapter({
    required this.chapterNumber,
    required this.name,
    required this.nameMeaning,
    required this.versesCount,
    required this.chapterSummary,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      chapterNumber: json['chapter_number'],
      name: json['name'],
      nameMeaning: json['name_meaning'],
      versesCount: json['verses_count'],
      chapterSummary: json['chapter_summary'],
    );
  }
}
