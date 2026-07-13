import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        SizedBox(height: 20),
        CircleAvatar(
          radius: 55,
          child: Icon(
            Icons.person,
            size: 60,
          ),
        ),
        SizedBox(height: 16),
        Center(
          child: Text(
            'User Name',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 5),
        Center(
          child: Text(
            'user@gmail.com',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        SizedBox(height: 30),
        ListTile(
          leading: Icon(Icons.phone_outlined),
          title: Text('Phone'),
          subtitle: Text('+855 12 345 678'),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.alternate_email),
          title: Text('Username'),
          subtitle: Text('@username'),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.info_outline),
          title: Text('Bio'),
          subtitle: Text('Available'),
        ),
      ],
    );
  }
}