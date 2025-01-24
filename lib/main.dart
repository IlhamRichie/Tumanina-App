import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart'; // Import untuk inisialisasi locale
import 'screens/intro_screen.dart';
import 'screens/home_screen.dart';
import 'services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi locale untuk format tanggal
  await initializeDateFormatting(
      'id_ID', null); // 'id_ID' untuk bahasa Indonesia

  bool isLoggedIn = false;
  try {
    isLoggedIn = await ApiService().isSessionValid();
  } catch (e) {
    print("Error saat mengecek session: $e");
  }

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tumanina',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        primarySwatch: Colors.blue,
      ),
      home: isLoggedIn ? HomeScreen() : IntroScreen(),
    );
  }
}
