import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/intro_screen.dart';
import 'screens/home_screen.dart';
import 'services/api_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
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
