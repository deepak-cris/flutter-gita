class Language {
  final String? code; // Nullable if it can be null
  final String? name; // Nullable if it can be null

  Language({this.code, this.name});

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      code: json['code'] as String?,
      name: json['language'] as String?,
    );
  }
}
