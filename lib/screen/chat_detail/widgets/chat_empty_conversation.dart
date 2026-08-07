import 'package:flutter/material.dart';

class ChatEmptyConversation extends StatelessWidget {
  final String name;

  const ChatEmptyConversation({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.forum_outlined,
              size: 65,
              color: Colors.grey,
            ),
            const SizedBox(height: 15),
            Text(
              'Start a conversation with $name',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}