class Ayat {
  final int number;
  final String text;
  final String audioUrl;

  Ayat({
    required this.number,
    required this.text,
    required this.audioUrl,
  });

  factory Ayat.fromJson(Map<String, dynamic> json) {
    return Ayat(
      number: json['nomor'],
      text: json['teks'],
      audioUrl: json['audio'],
    );
  }
  
}
