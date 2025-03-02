class Commentary {
  final int verseId;
  final int authorId;
  final String authorName;
  final String language;
  final String description;

  Commentary({
    required this.verseId,
    required this.authorId,
    required this.authorName,
    required this.language,
    required this.description,
  });

  factory Commentary.fromJson(Map<String, dynamic> json) {
    return Commentary(
      verseId: json['verse_id'],
      authorId: json['author_id'],
      authorName: json['authorName'],
      language: json['language'],
      description: json['description'],
    );
  }
}
