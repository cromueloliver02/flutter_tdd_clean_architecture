import 'package:flutter/material.dart';

import '../../domain/entities/number_trivia_entity.dart';

class TriviaCard extends StatelessWidget {
  final NumberTrivia numberTrivia;

  const TriviaCard({
    super.key,
    required this.numberTrivia,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return SizedBox(
      height: screenSize.height / 3,
      child: Column(
        children: [
          Text(
            '${numberTrivia.number}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),
          Flexible(
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  numberTrivia.text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 25),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
