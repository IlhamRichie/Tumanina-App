import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Tumanina/screens/tasbih_screen.dart';

void main() {
  group('TasbihScreen Widget Test', () {
    testWidgets('semua widget ditampilkan dengan benar', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(home: TasbihScreen()));

      // Assert
      expect(find.text('Hitungan: 0'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('Reset'), findsOneWidget);
      expect(find.text('Tasbih'), findsOneWidget);
      expect(find.text('Tahmid'), findsOneWidget);
      expect(find.text('Takbir'), findsOneWidget);
    });

    testWidgets('counter bertambah ketika tombol + ditekan', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(home: TasbihScreen()));

      // Act
      final incrementButton = find.byIcon(Icons.add);
      await tester.tap(incrementButton);
      await tester.pump();

      // Assert
      expect(find.text('Hitungan: 1'), findsOneWidget);
    });

    testWidgets('counter reset ketika tombol reset ditekan', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(home: TasbihScreen()));

      // Act
      final incrementButton = find.byIcon(Icons.add);
      final resetButton = find.text('Reset');

      await tester.tap(incrementButton); // Tambahkan counter
      await tester.pump();
      expect(find.text('Hitungan: 1'), findsOneWidget);

      await tester.tap(resetButton); // Reset counter
      await tester.pump();

      // Assert
      expect(find.text('Hitungan: 0'), findsOneWidget);
    });
  });
}
