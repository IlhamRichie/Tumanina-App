class Article {
  final String id;
  final String title;
  final String author;
  final String date;
  final String url;

  Article({
    required this.id,
    required this.title,
    required this.author,
    required this.date,
    required this.url,
  });

  // Fungsi untuk mengonversi dari Map ke Article
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      date: json['date'],
      url: json['url'],
    );
  }

  // Fungsi untuk mengonversi Article ke Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'date': date,
      'url': url,
    };
  }
}
