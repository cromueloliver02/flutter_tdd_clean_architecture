import 'package:flutter/material.dart';

import './features/number_trivia/presentation/pages/number_trivia_page.dart';

class NumberTriviaApp extends StatelessWidget {
  const NumberTriviaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Colors.green.shade800,
      ),
      home: const NumberTriviaPage(),
    );
  }
}
