import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Tumanina/screens/waktu_sholat_screen.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import '../waktu_sholat_test.mocks.dart'; // File mock yang dipertahankan

@GenerateMocks([http.Client])
void main() {
  group('WaktuSholatScreen Widget Test', () {
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient(); // Menggunakan MockClient dari waktu_sholat_test.mocks.dart
    });

    testWidgets('menampilkan waktu sholat dengan benar',
        (WidgetTester tester) async {
      // Arrange
      when(mockClient.get(any)).thenAnswer((_) async => http.Response(
          '{"data":{"timings":{"Fajr":"05:00","Dhuhr":"12:00","Asr":"15:30","Maghrib":"18:00","Isha":"19:00"}}}',
          200));

      // Act
      await tester.pumpWidget(MaterialApp(
        home: WaktuSholatScreen(client: mockClient),
      ));
      await tester.pump(); // Tunggu UI diperbarui

      // Assert
      expect(find.text('Subuh'), findsOneWidget);
      expect(find.text('05:00'), findsOneWidget);
      expect(find.text('Dzuhur'), findsOneWidget);
      expect(find.text('12:00'), findsOneWidget);
      expect(find.text('Ashar'), findsOneWidget);
      expect(find.text('15:30'), findsOneWidget);
      expect(find.text('Maghrib'), findsOneWidget);
      expect(find.text('18:00'), findsOneWidget);
      expect(find.text('Isya'), findsOneWidget);
      expect(find.text('19:00'), findsOneWidget);
    });

    testWidgets('menampilkan error jika fetch gagal',
        (WidgetTester tester) async {
      // Arrange
      when(mockClient.get(any)).thenAnswer((_) async => http.Response('Not Found', 404));

      // Act
      await tester.pumpWidget(MaterialApp(
        home: WaktuSholatScreen(client: mockClient),
      ));
      await tester.pump(); // Tunggu UI diperbarui

      // Assert
      expect(find.text('Failed to load prayer times'), findsOneWidget);
    });
  });
}
