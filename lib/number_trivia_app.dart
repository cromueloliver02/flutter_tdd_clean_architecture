import 'package:flutter/material.dart';

class NumberTriviaApp extends StatelessWidget {
  const NumberTriviaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: const Scaffold(
        body: Center(
          child: Text('Number Trivia App'),
        ),
      ),
    );
  }
}
