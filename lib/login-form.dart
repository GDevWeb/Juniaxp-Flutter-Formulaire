import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Champs de connexion
            const TextField(
              decoration: InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Mot de passe'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logique de connexion
                Navigator.pushNamed(context, '/');
              },
              child: const Text('Se connecter'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: const Text('Pas encore inscrit ? Inscrivez-vous'),
            ),
          ],
        ),
      ),
    );
  }
}
