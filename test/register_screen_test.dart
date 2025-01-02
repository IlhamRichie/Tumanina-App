import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Tumanina/screens/fitur_login/register_screen.dart';
import 'package:Tumanina/screens/home_screen.dart';

void main() {
  group('RegisterScreen Test', () {
    testWidgets('Displays all UI elements correctly', (WidgetTester tester) async {
      // Bangun layar RegisterScreen
      await tester.pumpWidget(
        const MaterialApp(
          home: RegisterScreen(),
        ),
      );

      // Verifikasi teks judul dan deskripsi
      expect(find.text('Daftar Akun Baru'), findsOneWidget);
      expect(find.text('Isi informasi Anda untuk membuat akun'), findsOneWidget);

      // Verifikasi input fields
      expect(find.byType(TextField), findsNWidgets(3)); // Tiga input fields: Nama, Email, Password

      // Verifikasi tombol daftar
      expect(find.text('Daftar'), findsOneWidget);

      // Verifikasi teks "Sudah punya akun? Masuk"
      expect(find.text('Sudah punya akun? Masuk'), findsOneWidget);
    });

    testWidgets('User can input text in fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: RegisterScreen(),
        ),
      );

      // Input teks di setiap field
      await tester.enterText(find.byType(TextField).at(0), 'John Doe'); // Nama
      await tester.enterText(find.byType(TextField).at(1), 'john@example.com'); // Email
      await tester.enterText(find.byType(TextField).at(2), 'password123'); // Password

      // Verifikasi input teks
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('john@example.com'), findsOneWidget);
      expect(find.text('password123'), findsOneWidget);
    });

    testWidgets('Navigates to HomeScreen on Register button press', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: RegisterScreen(),
          routes: {
            '/home': (context) => const HomeScreen(), // Tambahkan route untuk HomeScreen
          },
        ),
      );

      // Ketuk tombol "Daftar"
      await tester.tap(find.text('Daftar'));
      await tester.pumpAndSettle(); // Tunggu navigasi selesai

      // Verifikasi navigasi ke HomeScreen
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('Password visibility toggle works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: RegisterScreen(),
        ),
      );

      // Pastikan icon visibility_off tampil awalnya
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      // Ketuk ikon untuk toggle visibility
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();

      // Pastikan ikon berubah menjadi visibility
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });
  });
}
