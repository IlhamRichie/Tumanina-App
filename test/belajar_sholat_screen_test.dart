import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Tumanina/screens/fitur_sholat/belajar_sholat_screen.dart';
import 'package:Tumanina/screens/fitur_sholat/mengenal_sholat_screen.dart';
import 'package:Tumanina/screens/fitur_sholat/gerakan_sholat/sholat_screen.dart';
import 'package:Tumanina/screens/fitur_sholat/syarat_sholat_screen.dart';
import 'package:Tumanina/screens/home_screen.dart';

void main() {
  testWidgets('BelajarSholatScreen renders correctly and navigates properly', (WidgetTester tester) async {
    // Build the BelajarSholatScreen
    await tester.pumpWidget(
      MaterialApp(
        home: BelajarSholatScreen(),
      ),
    );

    // Verify the app bar title
    expect(find.text('Belajar Sholat'), findsOneWidget);

    // Verify the list items are displayed correctly
    expect(find.text('Mengenal Sholat dan Jenis Sholat'), findsOneWidget);
    expect(find.text('Syarat Sholat'), findsOneWidget);
    expect(find.text('Gerakan dan Bacaan Sholat'), findsOneWidget);

    // Test tapping on the first item and navigating to MengenalSholatScreen
    await tester.tap(find.text('Mengenal Sholat dan Jenis Sholat'));
    await tester.pumpAndSettle();
    expect(find.byType(MengenalSholatScreen), findsOneWidget);

    // Go back to BelajarSholatScreen
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Test tapping on the second item and navigating to SyaratSholatScreen
    await tester.tap(find.text('Syarat Sholat'));
    await tester.pumpAndSettle();
    expect(find.byType(SyaratSholatScreen), findsOneWidget);

    // Go back to BelajarSholatScreen
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Test tapping on the third item and navigating to SholatScreen
    await tester.tap(find.text('Gerakan dan Bacaan Sholat'));
    await tester.pumpAndSettle();
    expect(find.byType(SholatScreen), findsOneWidget);

    // Test back navigation to HomeScreen
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => BelajarSholatScreen(),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
