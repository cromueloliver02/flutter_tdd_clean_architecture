import 'package:flutter/material.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({super.key});

  @override
  State<TriviaControls> createState() => TriviaControlsState();
}

class TriviaControlsState extends State<TriviaControls> {
  String numberStr = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'Input a number',
            border: OutlineInputBorder(),
          ),
          onChanged: (String? value) {
            if (value == null) return;

            numberStr = value;
          },
        ),
        const SizedBox(height: 10),
        Row(
          children: const [
            Expanded(child: Placeholder(fallbackHeight: 30)),
            SizedBox(width: 10),
            Expanded(child: Placeholder(fallbackHeight: 30)),
          ],
        ),
      ],
    );
  }
}
