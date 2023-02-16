import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/number_trivia/number_trivia_bloc.dart';
import '../../../../injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text('Number Trivia')),
      body: BlocProvider<NumberTriviaBloc>.value(
        value: sl<NumberTriviaBloc>(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // TOP HALF
              SizedBox(
                height: screenSize.height / 3,
                child: const Placeholder(),
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  const Placeholder(fallbackHeight: 40),
                  const SizedBox(height: 10),
                  Row(
                    children: const [
                      Expanded(child: Placeholder(fallbackHeight: 30)),
                      SizedBox(width: 10),
                      Expanded(child: Placeholder(fallbackHeight: 30)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
