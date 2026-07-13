import 'package:flutter/material.dart';
import '../../models/home_model.dart';

class ChatTile extends StatelessWidget {

  final ChatModel chat;

  const ChatTile({
    super.key,
    required this.chat,
  });


  @override
  Widget build(BuildContext context) {

    return ListTile(

      leading: CircleAvatar(
        radius: 28,
        backgroundImage: NetworkImage(chat.image),
      ),

      title: Text(
        chat.name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),

      subtitle: Text(
        chat.message,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),

      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Text(
            chat.time,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),

          if(chat.unread > 0)
            Container(
              margin: const EdgeInsets.only(top: 5),
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),

              child: Text(
                chat.unread.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            )

        ],
      ),

    );

  }
}