import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Tumanina/screens/tasbih_screen.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Arrange: Render TasbihScreen langsung
    await tester.pumpWidget(const MaterialApp(home: TasbihScreen()));

    // Assert: Pastikan teks Hitungan: 0 ada di awal
    expect(find.text('Hitungan: 0'), findsOneWidget);

    // Act: Tekan tombol increment
    final incrementButton = find.byIcon(Icons.add);
    await tester.tap(incrementButton);
    await tester.pump();

    // Assert: Pastikan teks Hitungan: 1 muncul
    expect(find.text('Hitungan: 1'), findsOneWidget);
  });
}
