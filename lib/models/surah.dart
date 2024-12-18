class Surah {
  final int id;
  final String name;
  final String translation;
  final String? audioUrl;

  Surah({
    required this.id,
    required this.name,
    required this.translation,
    this.audioUrl,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      id: json['number'] ?? 0, // Gunakan 0 jika `number` null
      name: json['englishName'] ?? 'Unknown', // Default jika nama tidak tersedia
      translation: json['englishNameTranslation'] ?? 'No translation',
      audioUrl: null, // Audio akan ditangani di detail ayat
    );
  }
}
