import 'dart:convert';
import 'package:bhagavad_gita_simplified/models/chapter.dart';
import 'package:bhagavad_gita_simplified/screens/verse_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as services;

class ChapterListScreen extends StatefulWidget {
  const ChapterListScreen({super.key});

  @override
  _ChapterListScreenState createState() => _ChapterListScreenState();
}

class _ChapterListScreenState extends State<ChapterListScreen> {
  List<Chapter> chapters = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadChapters();
  }

  Future<void> loadChapters() async {
    try {
      final String response = await services.rootBundle.loadString(
        'assets/data/chapters.json',
      );
      final data = json.decode(response) as List;
      setState(() {
        chapters = data.map((json) => Chapter.fromJson(json)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading chapters: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bhagavad Gita'),
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
                : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: chapters.length,
                  itemBuilder: (context, index) {
                    final chapter = chapters[index];
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => VerseListScreen(
                                    chapterNumber: chapter.chapterNumber,
                                  ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.orange[100],
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Center(
                                  child: Text(
                                    '${chapter.chapterNumber}',
                                    style: TextStyle(
                                      color: Colors.orange[800],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      chapter.name,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge!.copyWith(
                                        color: Colors.orange[900],
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      chapter.nameMeaning,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Verses: ${chapter.versesCount}',
                                      style: TextStyle(
                                        color: Colors.grey[800],
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.orange[800],
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
