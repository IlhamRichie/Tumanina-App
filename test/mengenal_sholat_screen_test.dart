import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Tumanina/screens/fitur_sholat/mengenal_sholat_screen.dart';

void main() {
  testWidgets('MengenalSholatScreen renders correctly', (WidgetTester tester) async {
    // Build the MengenalSholatScreen
    await tester.pumpWidget(
      MaterialApp(
        home: MengenalSholatScreen(),
      ),
    );

    // Verify the app bar title
    expect(find.text('Mengenal Sholat'), findsOneWidget);

    // Verify the main card title and description
    expect(find.text('Mengenal Sholat'), findsNWidgets(2)); // Title appears twice: AppBar and Card
    expect(
      find.text(
        'Sholat adalah ibadah wajib yang harus dilaksanakan oleh umat Muslim. Sholat terbagi menjadi beberapa jenis, seperti:',
      ),
      findsOneWidget,
    );

    // Verify the Sholat Wajib card
    expect(find.text('Sholat Wajib'), findsOneWidget);
    expect(
      find.text('Sholat lima waktu yang harus dilaksanakan setiap hari (Subuh, Dzuhur, Ashar, Maghrib, dan Isya).'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.timer), findsOneWidget);

    // Verify the Sholat Sunnah card
    expect(find.text('Sholat Sunnah'), findsOneWidget);
    expect(
      find.text('Sholat yang dianjurkan untuk dikerjakan tetapi tidak wajib, seperti sholat Dhuha, Tahajud, dan Witir.'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.stars), findsOneWidget);

    // Verify the italicized description card
    expect(
      find.text(
        'Dengan mengenal jenis-jenis sholat, diharapkan kita dapat lebih memahami pentingnya menjaga sholat dalam kehidupan sehari-hari.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('MengenalSholatScreen back button works', (WidgetTester tester) async {
    // Build the MengenalSholatScreen with a parent MaterialApp
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MengenalSholatScreen(),
        ),
      ),
    );

    // Verify the back button icon exists
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);

    // Simulate tapping the back button
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // Verify that the navigation is popped (screen is removed)
    expect(find.byType(MengenalSholatScreen), findsNothing);
  });
}
