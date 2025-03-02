import 'dart:convert';
import 'package:bhagavad_gita_simplified/models/author.dart';
import 'package:bhagavad_gita_simplified/models/commentary.dart';
import 'package:bhagavad_gita_simplified/models/language.dart';
import 'package:bhagavad_gita_simplified/models/translation.dart';
import 'package:bhagavad_gita_simplified/models/verse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class VerseDetailsScreen extends StatefulWidget {
  final Verse verse;

  const VerseDetailsScreen({required this.verse});

  @override
  _VerseDetailsScreenState createState() => _VerseDetailsScreenState();
}

class _VerseDetailsScreenState extends State<VerseDetailsScreen> {
  List<Translation> translations = [];
  List<Commentary> commentaries = [];
  List<Author> authors = [];
  List<Language> languages = [];
  String? selectedTranslationAuthor = 'all';
  String? selectedCommentaryAuthor = 'all';
  String? selectedCommentaryLanguage = 'all';
  bool isLoading = true;
  String? errorMessage;
  final AudioPlayer audioPlayer = AudioPlayer();
  final TextEditingController noteController = TextEditingController();
  Database? database;

  @override
  void initState() {
    super.initState();
    _initialize();
    loadData();
    try {
      print('Attempting to play audio...');
      audioPlayer.play(AssetSource('audio/verse_music.mp3'));
      print('Audio play initiated');
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  Future<void> _initialize() async {
    try {
      await initDatabase();
      await loadNote();
    } catch (e) {
      print('Error initializing database or loading note: $e');
      setState(() {
        errorMessage = 'Error initializing: $e';
      });
    }
  }

  Future<void> initDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'notes.db');
      database = await openDatabase(
        path,
        version: 2,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE notes (
              verseId INTEGER PRIMARY KEY,
              noteText TEXT NOT NULL
            )
          ''');
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            await db.execute('DROP TABLE IF EXISTS notes');
            await db.execute('''
              CREATE TABLE notes (
                verseId INTEGER PRIMARY KEY,
                noteText TEXT NOT NULL
              )
            ''');
          }
        },
      );
      print('Database initialized at: $path');
    } catch (e) {
      print('Error opening database: $e');
      rethrow;
    }
  }

  Future<void> loadNote() async {
    if (database == null) {
      print('Database not initialized yet');
      return;
    }
    final db = await database!;
    final maps = await db.query(
      'notes',
      columns: ['noteText'],
      where: 'verseId = ?',
      whereArgs: [widget.verse.id],
    );
    if (maps.isNotEmpty) {
      noteController.text = maps.first['noteText'] as String;
    }
  }

  Future<void> saveNote() async {
    if (database == null) {
      print('Database not initialized yet');
      ScaffoldMessenger.of(
        this.context,
      ).showSnackBar(const SnackBar(content: Text('Database not ready')));
      return;
    }
    final noteText = noteController.text.trim();
    if (noteText.isNotEmpty) {
      final db = await database!;
      await db.insert('notes', {
        'verseId': widget.verse.id,
        'noteText': noteText,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      ScaffoldMessenger.of(
        this.context,
      ).showSnackBar(const SnackBar(content: Text('Note saved')));
    }
  }

  Future<void> loadData() async {
    try {
      final String? transResponse = await rootBundle.loadString(
        'assets/data/translation.json',
      );
      final String? authResponse = await rootBundle.loadString(
        'assets/data/authors.json',
      );
      final String? langResponse = await rootBundle.loadString(
        'assets/data/languages.json',
      );

      if (transResponse == null) throw Exception('translation.json not found');
      if (authResponse == null) throw Exception('authors.json not found');
      if (langResponse == null) throw Exception('languages.json not found');

      final transData = json.decode(transResponse) as List? ?? [];
      final authData = json.decode(authResponse) as List? ?? [];
      final langData = json.decode(langResponse) as List? ?? [];

      setState(() {
        translations =
            transData
                .map((json) => Translation.fromJson(json))
                .where((t) => t.verseId == widget.verse.id)
                .toList();
        commentaries = [
          Commentary(
            verseId: widget.verse.id,
            authorId: 1,
            authorName: 'Default Author',
            language: 'English',
            description: 'Commentary data will be added later.',
          ),
        ];
        authors = authData.map((json) => Author.fromJson(json)).toList();
        languages = langData.map((json) => Language.fromJson(json)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading data: $e';
        isLoading = false;
      });
      print('Caught error: $e');
    }
  }

  @override
  void dispose() {
    audioPlayer.stop();
    audioPlayer.dispose();
    noteController.dispose();
    database?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Translation> filteredTranslations =
        selectedTranslationAuthor == 'all'
            ? translations
            : translations
                .where(
                  (t) =>
                      t.authorId.toString() ==
                      (selectedTranslationAuthor ?? ''),
                )
                .toList();

    List<Commentary> filteredCommentaries =
        commentaries.where((c) {
          final authorMatch =
              selectedCommentaryAuthor == 'all' ||
              c.authorId.toString() == (selectedCommentaryAuthor ?? '');
          final langMatch =
              selectedCommentaryLanguage == 'all' ||
              c.language == (selectedCommentaryLanguage ?? '');
          return authorMatch && langMatch;
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Verse ${widget.verse.verseNumber}'),
        elevation: 2,
        backgroundColor: Colors.orange[800],
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange[50]!, Colors.white],
          ),
        ),
        child:
            isLoading
                ? const Center(
                  child: CircularProgressIndicator(color: Colors.orange),
                )
                : errorMessage != null
                ? Center(
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/images/verse_image.jpg',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        title: 'Original Text',
                        content: widget.verse.text,
                      ),
                      _buildSection(
                        title: 'Transliteration',
                        content: widget.verse.transliteration,
                      ),
                      _buildSection(
                        title: 'Word Meanings',
                        content: widget.verse.wordMeanings,
                      ),
                      _buildTranslationsSection(filteredTranslations),
                      _buildCommentariesSection(filteredCommentaries),
                      _buildNotesSection(),
                    ],
                  ),
                ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(this.context).textTheme.titleLarge!.copyWith(
                color: Colors.orange[900],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: TextStyle(color: Colors.grey[800], fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTranslationsSection(List<Translation> filteredTranslations) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Translations',
              style: Theme.of(this.context).textTheme.titleLarge!.copyWith(
                color: Colors.orange[900],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: selectedTranslationAuthor,
              onChanged:
                  (value) => setState(() => selectedTranslationAuthor = value),
              items: [
                const DropdownMenuItem(
                  value: 'all',
                  child: Text('All Authors'),
                ),
                ...authors.map(
                  (a) => DropdownMenuItem(
                    value: a.id.toString(),
                    child: Text(a.name ?? 'Unknown'),
                  ),
                ),
              ],
              isExpanded: true,
              style: TextStyle(color: Colors.grey[800]),
              dropdownColor: Colors.orange[50],
            ),
            const SizedBox(height: 8),
            ...filteredTranslations.map(
              (t) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  '${t.authorName ?? 'Unknown'}: ${t.description ?? 'No description'}',
                  style: TextStyle(color: Colors.grey[800], fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentariesSection(List<Commentary> filteredCommentaries) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Commentaries',
              style: Theme.of(this.context).textTheme.titleLarge!.copyWith(
                color: Colors.orange[900],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedCommentaryAuthor,
                    onChanged:
                        (value) =>
                            setState(() => selectedCommentaryAuthor = value),
                    items: [
                      const DropdownMenuItem(
                        value: 'all',
                        child: Text('All Authors'),
                      ),
                      ...authors.map(
                        (a) => DropdownMenuItem(
                          value: a.id.toString(),
                          child: Text(a.name ?? 'Unknown'),
                        ),
                      ),
                    ],
                    isExpanded: true,
                    style: TextStyle(color: Colors.grey[800]),
                    dropdownColor: Colors.orange[50],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedCommentaryLanguage,
                    onChanged:
                        (value) =>
                            setState(() => selectedCommentaryLanguage = value),
                    items: [
                      const DropdownMenuItem(
                        value: 'all',
                        child: Text('All Languages'),
                      ),
                      ...languages.map(
                        (l) => DropdownMenuItem(
                          value: l.code ?? '',
                          child: Text(l.name ?? 'Unknown'),
                        ),
                      ),
                    ],
                    isExpanded: true,
                    style: TextStyle(color: Colors.grey[800]),
                    dropdownColor: Colors.orange[50],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...filteredCommentaries.map(
              (c) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  '${c.authorName ?? 'Unknown'} (${c.language ?? 'Unknown'}): ${c.description ?? 'No description'}',
                  style: TextStyle(color: Colors.grey[800], fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notes',
              style: Theme.of(this.context).textTheme.titleLarge!.copyWith(
                color: Colors.orange[900],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.orange[800]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.orange[800]!, width: 2),
                ),
              ),
              maxLines: 3,
              style: TextStyle(color: Colors.grey[800]),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: saveNote,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[800],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Save Note'),
            ),
          ],
        ),
      ),
    );
  }
}
