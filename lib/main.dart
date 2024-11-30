import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './home_page.dart';
import './login-form.dart';
import './profile_page.dart';
import './providers/albums_provider.dart';
import './providers/artists_provider.dart';
import './providers/auth_providers.dart';
import './signup_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider()
            ..loadAuthData(), // Load des données utilisateur au démarrage
        ),
        ChangeNotifierProvider(create: (_) => AlbumsProvider()),
        ChangeNotifierProvider(create: (_) => ArtistsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Music App',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
          primaryColor: Colors.orange,
          textTheme: const TextTheme(
            titleLarge: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
            bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
            bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ),
        initialRoute: '/', // Définition de ma route initiale
        routes: {
          '/': (context) => const HomePage(),
          '/login': (context) => const LoginForm(),
          '/signup': (context) => const SignupForm(),
          '/profile': (context) => const ProfilePage(),
        },
      ),
    );
  }
}
