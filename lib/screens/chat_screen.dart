import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, String>> messages = [];
  bool isLoading = false;

  Future<void> _sendMessage(String text) async {
    if (text.isEmpty) return;
    setState(() {
      messages.add({"role": "user", "content": text});
      isLoading = true;
    });
    _scrollToBottom();

    final url = Uri.parse('https://api.deepseek.com/chat/completions');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer sk-56b37fb7305645069a84a799d4883730',
    };

    List<Map<String, String>> apiMessages = [
      {
        "role": "system",
        "content":
            "You are Krishna from the Bhagavad Gita. Provide wise and insightful answers from Bhagavad Gita books. Also give reference to Bhagavad Gita verse in your answer if required.",
      },
      ...messages,
    ];

    final body = jsonEncode({
      'model': 'deepseek-chat',
      'messages': apiMessages,
      'stream': true,
    });

    try {
      final request =
          http.Request('POST', url)
            ..headers.addAll(headers)
            ..body = body;

      final streamedResponse = await request.send();
      if (streamedResponse.statusCode == 200) {
        String accumulatedResponse = '';
        await for (final chunk in streamedResponse.stream.transform(
          utf8.decoder,
        )) {
          // Log raw chunk for debugging
          print('Raw chunk: $chunk');

          // Handle DeepSeek streaming format (assuming JSON chunks)
          try {
            final lines = chunk
                .split('\n')
                .where((line) => line.trim().isNotEmpty);
            for (var line in lines) {
              if (line.startsWith('data: ')) {
                line = line.substring(6);
              }
              if (line == '[DONE]') {
                break;
              }
              final jsonData = jsonDecode(line);
              final content =
                  jsonData['choices']?[0]?['delta']?['content'] as String?;
              if (content != null) {
                accumulatedResponse += content;
                setState(() {
                  if (messages.last['role'] == 'user') {
                    messages.add({
                      "role": "assistant",
                      "content": accumulatedResponse,
                    });
                  } else {
                    messages.last['content'] = accumulatedResponse;
                  }
                  isLoading = false; // Hide shimmer when response starts
                });
                _scrollToBottom();
                await Future.delayed(
                  Duration(milliseconds: 10),
                ); // Typing effect
              }
            }
          } catch (e) {
            print('Error parsing chunk: $e');
            continue;
          }
        }
      } else {
        setState(() {
          messages.add({
            "role": "assistant",
            "content": "Sorry, something went wrong.",
          });
        });
      }
    } catch (e) {
      setState(() {
        messages.add({"role": "assistant", "content": "Error occurred: $e"});
      });
    } finally {
      setState(() {
        isLoading = false;
      });
      _scrollToBottom();
    }

    _controller.clear();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Krishna'),
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
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: messages.length + (isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (isLoading && index == messages.length) {
                    return Semantics(
                      label: 'Waiting for Krishna\'s response',
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Shimmer.fromColors(
                          baseColor: Colors.orange[100]!,
                          highlightColor: Colors.orange[50]!,
                          period: const Duration(milliseconds: 1000),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 150,
                                    height: 10,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    width: 100,
                                    height: 10,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  final message = messages[index];
                  final isUser = message['role'] == 'user';
                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: isUser ? Colors.orange[100] : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          message['content']!,
                          style: TextStyle(
                            color:
                                isUser ? Colors.orange[900] : Colors.grey[800],
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Ask Krishna a question...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.orange[800]!),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.orange[800]),
                    onPressed:
                        isLoading ? null : () => _sendMessage(_controller.text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
