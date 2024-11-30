import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth_providers.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userInfo = authProvider.userInfo;

    // Redirection vers la page de connexion si non auth
    if (!authProvider.isAuthenticated()) {
      Future.microtask(() {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: userInfo == null
          ? const Center(
              child: Text('Chargement des données utilisateur...'),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.orange,
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '${userInfo['firstName']} ${userInfo['lastName']}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Rôles: ${userInfo['roles'].join(', ')}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
