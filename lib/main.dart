import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PillMindApp());
}

class PillMindApp extends StatelessWidget {
  const PillMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PillMind AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF080810),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00F2FE),
          surface: Color(0xFF12121E),
        ),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(ThemeData.dark().textTheme),
      ),
      home: const DashboardScreen(),
    );
  }
}
