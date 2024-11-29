import 'package:flutter/material.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscription'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Champs d'inscription
            const TextField(
              decoration: InputDecoration(labelText: 'Nom'),
            ),
            const SizedBox(height: 10),
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
                // Logique d'inscription
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('S\'inscrire'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Déjà inscrit ? Connectez-vous'),
            ),
          ],
        ),
      ),
    );
  }
}
