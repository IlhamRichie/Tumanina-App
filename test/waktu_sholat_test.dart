import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:Tumanina/screens/waktu_sholat_screen.dart';
import 'waktu_sholat_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('WaktuSholatScreen Tests', () {
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
    });

    testWidgets('should fetch and display prayer times successfully',
        (WidgetTester tester) async {
      // Arrange
      when(mockClient.get(Uri.parse(
              'http://api.aladhan.com/v1/timingsByCity?city=Tegal&country=Indonesia&method=4')))
          .thenAnswer((_) async => http.Response(
              '{"data":{"timings":{"Fajr":"05:00","Dhuhr":"12:00","Asr":"15:30","Maghrib":"18:00","Isha":"19:00"}}}',
              200));

      // Act
      await tester.pumpWidget(MaterialApp(
        home: WaktuSholatScreen(client: mockClient),
      ));
      await tester.pump(); // Tunggu fetch selesai

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

      verify(mockClient.get(any)).called(1);
    });

    testWidgets('should display error when API call fails',
        (WidgetTester tester) async {
      // Arrange
      when(mockClient.get(Uri.parse(
              'http://api.aladhan.com/v1/timingsByCity?city=Tegal&country=Indonesia&method=4')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // Act
      await tester.pumpWidget(MaterialApp(
        home: WaktuSholatScreen(client: mockClient),
      ));
      await tester.pump(); // Tunggu fetch selesai

      // Assert
      expect(find.text('Failed to load prayer times'), findsOneWidget);
      verify(mockClient.get(any)).called(1);
    });
  });
}
