import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _cityController = TextEditingController();

  // API endpoint
  final String _apiUrl = "https://s3-4987.nuage-peda.fr/music/api/users";

  // Méthode pour valider et soumettre le formulaire
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Récupérer les données des champs
      final Map<String, dynamic> body = {
        "email": _emailController.text.trim(),
        "roles": ["user"], // Exemple : rôle par défaut
        "password": _passwordController.text,
        "firstName": _firstNameController.text.trim(),
        "lastName": _lastNameController.text.trim(),
        "address": _addressController.text.trim(),
        "postalCode": _postalCodeController.text.trim(),
        "city": _cityController.text.trim(),
      };

      try {
        // Envoyer une requête POST à l'API
        final response = await http.post(
          Uri.parse(_apiUrl),
          headers: {
            "accept": "application/ld+json",
            "Content-Type": "application/ld+json",
          },
          body: jsonEncode(body),
        );

        if (response.statusCode == 201) {
          // Succès : Afficher un message et rediriger
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Compte créé avec succès !')),
          );
          Navigator.pushNamed(
              context, '/login'); // Rediriger vers la page de connexion
        } else {
          // Erreur API : Afficher le message d'erreur
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Erreur : ${responseData['message'] ?? 'Erreur inconnue'}')),
          );
        }
      } catch (e) {
        // Gestion des erreurs réseau
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
        title: const Text('Inscription'),
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
                  if (value.length < 6) {
                    return 'Le mot de passe doit contenir au moins 6 caractères.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Prénom
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'Prénom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un prénom.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Nom
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Adresse
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Adresse'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une adresse.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Code postal
              TextFormField(
                controller: _postalCodeController,
                decoration: const InputDecoration(labelText: 'Code postal'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un code postal.';
                  }
                  if (!RegExp(r'^\d{5}$').hasMatch(value)) {
                    return 'Veuillez entrer un code postal valide.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Ville
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'Ville'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une ville.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Bouton d'inscription
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('S\'inscrire'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
