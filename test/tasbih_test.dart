import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Tumanina/screens/tasbih_screen.dart'; // Sesuaikan path dengan struktur project Anda

void main() {
  group('Tasbih Screen', () {
    testWidgets('should increment counter when incrementCounter is called',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(home: TasbihScreen()));

      // Act
      final tasbihImage = find.byKey(const Key('tasbih-gesture')); // Cari GestureDetector dengan key
      await tester.tap(tasbihImage); // Simulasikan tap pada GestureDetector
      await tester.pump(); // Perbarui UI setelah state berubah

      // Assert
      expect(find.text('Hitungan: 1'), findsOneWidget); // Mencari teks yang cocok
    });

    testWidgets('should reset counter when resetCounter is called',
        (WidgetTester tester) async {
      // Atur ukuran layar test
      tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      // Arrange
      await tester.pumpWidget(const MaterialApp(home: TasbihScreen()));

      // Act
      final tasbihImage = find.byKey(const Key('tasbih-gesture')); // Cari GestureDetector dengan key
      final resetButton = find.text('Reset'); // Cari tombol dengan teks Reset

      // Tambahkan counter dulu
      await tester.tap(tasbihImage); // Simulasikan tap pada GestureDetector
      await tester.pump();

      // Pastikan tombol reset terlihat sebelum ditekan
      await tester.ensureVisible(resetButton);
      await tester.tap(resetButton); // Simulasikan tap pada tombol Reset
      await tester.pump(); // Perbarui UI setelah state berubah

      // Assert
      expect(find.text('Hitungan: 0'), findsOneWidget); // Mencari teks yang cocok
    });
  });
}