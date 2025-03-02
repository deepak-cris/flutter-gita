class Translation {
  final int verseId;
  final int authorId;
  final String? authorName; // Nullable if it can be null in JSON
  final String? description; // Nullable if it can be null

  Translation({
    required this.verseId,
    required this.authorId,
    this.authorName,
    this.description,
  });

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
      verseId: json['verse_id'] as int,
      authorId: json['author_id'] as int,
      authorName: json['authorName'] as String?,
      description: json['description'] as String?,
    );
  }
}
