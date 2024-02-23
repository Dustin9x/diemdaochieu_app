import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:diemdaochieu_app/screens/tabs.dart';
import 'package:diemdaochieu_app/screens/profile_screen.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 255, 199, 1),
  ),
  textTheme: GoogleFonts.interTextTheme(),
);

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      //home: const TabsScreen(),
      title: 'Điểm Đảo Chiều',
      initialRoute: '/',
      routes: {
        '/': (context) => const TabsScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
