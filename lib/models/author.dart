class Author {
  final int id;
  final String? name; // Nullable if it can be null

  Author({required this.id, this.name});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(id: json['id'] as int, name: json['name'] as String?);
  }
}
