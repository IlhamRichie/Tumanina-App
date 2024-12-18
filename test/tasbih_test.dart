import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:MyApp/screens/tasbih_screen.dart';

void main() {
  group('Tasbih Screen', () {
    testWidgets('should increment counter when incrementCounter is called',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(home: TasbihScreen()));

      // Act
      final incrementButton = find.byIcon(Icons.add);
      await tester.tap(incrementButton); // Simulasikan tekan tombol
      await tester.pump(); // Perbarui UI setelah state berubah

      // Assert
      expect(find.text('Hitungan: 1'), findsOneWidget); // Mencari teks yang cocok
    });

    testWidgets('should reset counter when resetCounter is called',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(home: TasbihScreen()));

      // Act
      final incrementButton = find.byIcon(Icons.add);
      final resetButton = find.text('Reset');

      // Tambahkan counter dulu
      await tester.tap(incrementButton);
      await tester.pump();

      // Tekan tombol reset
      await tester.tap(resetButton);
      await tester.pump();

      // Assert
      expect(find.text('Hitungan: 0'), findsOneWidget); // Mencari teks yang cocok
    });
  });
}
