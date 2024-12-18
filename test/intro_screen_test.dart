import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:MyApp/screens/intro_screen.dart'; // Ganti sesuai path proyek
import 'package:MyApp/screens/login_screen.dart';

void main() {
  testWidgets('IntroScreen displays correct content and navigation works',
      (WidgetTester tester) async {
    // Build IntroScreen
    await tester.pumpWidget(MaterialApp(home: IntroScreen()));

    // Periksa slide pertama
    expect(find.text("Selamat Datang di Aplikasi"), findsOneWidget);
    expect(find.text("Aplikasi ini membantu Anda dalam ibadah sehari-hari."),
        findsOneWidget); 

    // Tekan tombol "Selanjutnya"
    await tester.tap(find.text("Selanjutnya"));
    await tester.pumpAndSettle(); // Tunggu animasi selesai

    // Periksa slide kedua
    expect(find.text("Pantau Waktu Sholat"), findsOneWidget);
    expect(find.text("Dapatkan pengingat waktu sholat yang akurat."),
        findsOneWidget);

    // Tekan tombol "Selanjutnya" lagi
    await tester.tap(find.text("Selanjutnya"));
    await tester.pumpAndSettle();

    // Periksa slide ketiga
    expect(find.text("Baca Al-Qur'an"), findsOneWidget);
    expect(find.text("Nikmati bacaan Al-Qur'an dan terjemahannya."),
        findsOneWidget);

    // Tekan tombol "Mulai" dan navigasi ke LoginScreen
    await tester.tap(find.text("Mulai"));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
