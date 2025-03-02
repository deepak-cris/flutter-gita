import 'dart:convert';
import 'package:bhagavad_gita_simplified/models/chapter.dart';
import 'package:bhagavad_gita_simplified/screens/verse_list_screen.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart' as services;

class ChapterListScreen extends material.StatefulWidget {
  const ChapterListScreen({super.key});

  @override
  _ChapterListScreenState createState() => _ChapterListScreenState();
}

class _ChapterListScreenState extends material.State<ChapterListScreen> {
  List<Chapter> chapters = [];
  bool isLoading = true;
  bool isLoadingCommitTest = true;
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
  material.Widget build(material.BuildContext context) {
    return material.Scaffold(
      appBar: material.AppBar(
        title: const material.Text('Bhagavad Gita'),
        elevation: 2,
        backgroundColor: material.Colors.orange[800],
        foregroundColor: material.Colors.white,
      ),
      body: material.Container(
        decoration: material.BoxDecoration(
          gradient: material.LinearGradient(
            begin: material.Alignment.topCenter,
            end: material.Alignment.bottomCenter,
            colors: [material.Colors.orange[50]!, material.Colors.white],
          ),
        ),
        child:
            isLoading
                ? const material.Center(
                  child: material.CircularProgressIndicator(
                    color: material.Colors.orange,
                  ),
                )
                : errorMessage != null
                ? material.Center(
                  child: material.Text(
                    errorMessage!,
                    style: const material.TextStyle(color: material.Colors.red),
                  ),
                )
                : material.GridView.builder(
                  padding: const material.EdgeInsets.all(16),
                  gridDelegate:
                      const material.SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1, // 1 chapter per row
                        // No childAspectRatio for dynamic rectangular height
                        mainAxisSpacing: 8, // Space between rows
                      ),
                  itemCount: chapters.length,
                  itemBuilder: (context, index) {
                    final chapter = chapters[index];
                    return material.Card(
                      elevation: 4,
                      shape: material.RoundedRectangleBorder(
                        borderRadius: material.BorderRadius.circular(12),
                      ),
                      child: material.InkWell(
                        onTap: () {
                          material.Navigator.push(
                            context,
                            material.MaterialPageRoute(
                              builder:
                                  (context) => VerseListScreen(
                                    chapterNumber: chapter.chapterNumber,
                                  ),
                            ),
                          );
                        },
                        child: material.Padding(
                          padding: const material.EdgeInsets.all(16),
                          child: material.IntrinsicHeight(
                            child: material.Row(
                              crossAxisAlignment:
                                  material.CrossAxisAlignment.center,
                              children: [
                                material.Container(
                                  width: 60,
                                  height: 60,
                                  decoration: material.BoxDecoration(
                                    color: material.Colors.orange[100],
                                    borderRadius: material
                                        .BorderRadius.circular(30),
                                  ),
                                  child: material.Center(
                                    child: material.Text(
                                      '${chapter.chapterNumber}',
                                      style: material.TextStyle(
                                        color: material.Colors.orange[800],
                                        fontWeight: material.FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),
                                ),
                                const material.SizedBox(width: 16),
                                material.Expanded(
                                  child: material.Column(
                                    crossAxisAlignment:
                                        material.CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        material.MainAxisAlignment.center,
                                    children: [
                                      material.Text(
                                        chapter.name,
                                        style: material.Theme.of(
                                          context,
                                        ).textTheme.titleLarge!.copyWith(
                                          color: material.Colors.orange[900],
                                          fontWeight: material.FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow:
                                            material.TextOverflow.ellipsis,
                                      ),
                                      const material.SizedBox(height: 8),
                                      material.Text(
                                        chapter.nameMeaning,
                                        style: material.TextStyle(
                                          color: material.Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                        overflow:
                                            material.TextOverflow.ellipsis,
                                      ),
                                      const material.SizedBox(height: 8),
                                      material.Text(
                                        'Verses: ${chapter.versesCount}',
                                        style: material.TextStyle(
                                          color: material.Colors.grey[800],
                                          fontSize: 12,
                                          fontStyle: material.FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                material.Icon(
                                  material.Icons.arrow_forward_ios,
                                  color: material.Colors.orange[800],
                                  size: 18,
                                ),
                              ],
                            ),
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
