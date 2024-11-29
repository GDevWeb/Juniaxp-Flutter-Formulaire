import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.orange,
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ), // Large titles
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ), // Main body text
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ), // Secondary body text
        ),
      ),
      home: const ConnexionInscription(),
    );
  }
}

class ConnexionInscription extends StatefulWidget {
  const ConnexionInscription({super.key});

  @override
  _ConnexionInscriptionState createState() => _ConnexionInscriptionState();
}

class _ConnexionInscriptionState extends State<ConnexionInscription> {
  final _formKey = GlobalKey<FormState>();
  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  final _nameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _cityController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Regex pour la validation
  final String _emailPattern =
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$'; // Simple validation email
  final String _passwordPattern =
      r'^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$'; // Minimum 6 caractères, 1 majuscule, 1 chiffre, 1 spécial

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            const SizedBox(height: 40),
            // Section Connexion
            Text(
              'Connectez-vous',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _loginEmailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un email.';
                      }
                      if (!RegExp(_emailPattern).hasMatch(value)) {
                        return 'Veuillez entrer un email valide.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _loginPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Mot de passe',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un mot de passe.';
                      }
                      if (!RegExp(_passwordPattern).hasMatch(value)) {
                        return 'Mot de passe invalide (6 caractères min, 1 majuscule, 1 chiffre, 1 spécial).';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white, // Texte blanc
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Connexion réussie !'),
                          ),
                        );
                      }
                    },
                    child: const Text('Se connecter'),
                  ),
                  const SizedBox(height: 40),
                  // Section Inscription
                  Text(
                    'Inscrivez-vous',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Vos informations personnelles',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField('Nom', _nameController),
                  const SizedBox(height: 10),
                  _buildTextField('Prénom', _firstNameController),
                  const SizedBox(height: 10),
                  _buildTextField('Adresse', _addressController),
                  const SizedBox(height: 10),
                  _buildTextField('Code postal', _postalCodeController),
                  const SizedBox(height: 10),
                  _buildTextField('Ville', _cityController),
                  const SizedBox(height: 20),
                  Text(
                    'Vos paramètres de connexion',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField('Email', _emailController,
                      emailValidation: true),
                  const SizedBox(height: 10),
                  _buildTextField(
                    'Mot de passe',
                    _passwordController,
                    obscureText: true,
                    passwordValidation: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white, // Texte blanc
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Inscription réussie !'),
                          ),
                        );
                      }
                    },
                    child: const Text('S\'inscrire'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Champs avec validation optionnelle
  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool obscureText = false,
    bool emailValidation = false,
    bool passwordValidation = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
        ),
      ),
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ce champ est obligatoire.';
        }
        if (emailValidation && !RegExp(_emailPattern).hasMatch(value)) {
          return 'Veuillez entrer un email valide.';
        }
        if (passwordValidation && !RegExp(_passwordPattern).hasMatch(value)) {
          return 'Mot de passe invalide (6 caractères min, 1 majuscule, 1 chiffre, 1 spécial).';
        }
        return null;
      },
    );
  }
}
