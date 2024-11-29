import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nom : John Doe', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Email : john.doe@example.com',
                style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
