import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        ListTile(
          leading: CircleAvatar(
            child: Icon(Icons.person),
          ),
          title: Text('Contact One'),
          subtitle: Text('Online'),
        ),
        Divider(height: 1),
        ListTile(
          leading: CircleAvatar(
            child: Icon(Icons.person),
          ),
          title: Text('Contact Two'),
          subtitle: Text('Last seen recently'),
        ),
        Divider(height: 1),
        ListTile(
          leading: CircleAvatar(
            child: Icon(Icons.person),
          ),
          title: Text('Contact Three'),
          subtitle: Text('Offline'),
        ),
      ],
    );
  }
}