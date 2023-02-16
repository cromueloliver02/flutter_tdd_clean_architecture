import 'package:flutter/material.dart';

class MessageCard extends StatelessWidget {
  final String message;

  const MessageCard({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return SizedBox(
      height: screenSize.height / 3,
      child: Center(
        child: SingleChildScrollView(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 25),
          ),
        ),
      ),
    );
  }
}
