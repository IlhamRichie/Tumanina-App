import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ArtikelScreen extends StatefulWidget {
  const ArtikelScreen({super.key});

  @override
  _ArtikelScreenState createState() => _ArtikelScreenState();
}

class _ArtikelScreenState extends State<ArtikelScreen> {
  List articles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    final url = Uri.parse(
        'https://example.com/api/articles?topic=sholat'); // Replace with your API URL
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        articles = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load articles');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artikel Seputar Sholat'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : articles.isNotEmpty
              ? ListView.builder(
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(article['title']),
                        subtitle: Text(article['description']),
                        onTap: () {
                          print(
                              'Clicked on article: ${article['title']}'); // Debug print
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ArtikelDetailScreen(article: article),
                            ),
                          );
                        },
                      ),
                    );
                  },
                )
              : const Center(child: Text("No articles found")),
    );
  }
}

class ArtikelDetailScreen extends StatelessWidget {
  final Map<String, dynamic> article;

  const ArtikelDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article['title'],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              article['content'] ?? 'No content available',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
