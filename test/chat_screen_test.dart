import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Tumanina/screens/tasbih_screen.dart'; // Sesuaikan path dengan struktur project Anda

void main() {
  group('Tasbih Screen Tests', () {
    testWidgets('should increment counter when tasbih is tapped', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(home: TasbihScreen()));

      // Act
      final tasbihGesture = find.byKey(const Key('tasbih-gesture')); // Cari GestureDetector dengan key
      await tester.tap(tasbihGesture); // Simulasikan tap pada GestureDetector
      await tester.pump(); // Perbarui UI setelah state berubah

      // Assert
      expect(find.text('Hitungan: 1'), findsOneWidget, reason: 'Counter should increment to 1 after tap');
    });

    testWidgets('should reset counter when Reset button is tapped', (WidgetTester tester) async {
      // Atur ukuran layar test
      tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      // Arrange
      await tester.pumpWidget(const MaterialApp(home: TasbihScreen()));

      // Act
      final tasbihGesture = find.byKey(const Key('tasbih-gesture')); // Cari GestureDetector dengan key
      final resetButton = find.text('Reset'); // Cari tombol dengan teks Reset

      // Tambahkan hitungan
      await tester.tap(tasbihGesture); // Simulasikan tap pada GestureDetector
      await tester.pump();

      // Verifikasi bahwa hitungan bertambah
      expect(find.text('Hitungan: 1'), findsOneWidget, reason: 'Counter should increment to 1 before resetting');

      // Pastikan tombol reset terlihat sebelum ditekan
      await tester.ensureVisible(resetButton);
      await tester.tap(resetButton); // Simulasikan tap pada tombol Reset
      await tester.pump(); // Perbarui UI setelah state berubah

      // Assert
      expect(find.text('Hitungan: 0'), findsOneWidget, reason: 'Counter should reset to 0 after Reset button is tapped');
    });
  });
}
