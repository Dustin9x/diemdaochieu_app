import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:diemdaochieu_app/screens/tabs.dart';
import 'package:diemdaochieu_app/screens/profile_screen.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 204, 148, 0),
  ),
  textTheme: GoogleFonts.interTextTheme(),
);

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
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
