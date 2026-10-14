
import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chat_bubble_outline, size: 48),
            SizedBox(height: 12),
            Text('Your conversations will appear here.'),
            SizedBox(height: 8),
            Text(
              'Messaging will be added in a future version.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
