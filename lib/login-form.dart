import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import './providers/auth_providers.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final String _apiUrl =
      "https://s3-4987.nuage-peda.fr/music/api/authentication_token";

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, String> body = {
        "email": _emailController.text.trim(),
        "password": _passwordController.text.trim(),
      };

      try {
        final response = await http.post(
          Uri.parse(_apiUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body),
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          final String token = responseData["token"];
          final Map<String, dynamic> userInfo = responseData["data"];

          // Mise à jour du contexte avec le token et les infos utilisateur
          Provider.of<AuthProvider>(context, listen: false)
              .setAuthData(token, userInfo);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Connexion réussie !')),
          );

          // Redirection vers la page d'accueil
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/',
            (route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erreur : Identifiants invalides.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur réseau : $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un email.';
                  }
                  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
                    return 'Veuillez entrer un email valide.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Mot de passe
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Mot de passe'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un mot de passe.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Bouton de connexion
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Se connecter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
