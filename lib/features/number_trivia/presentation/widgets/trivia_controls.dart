import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/presentation/blocs/number_trivia/number_trivia_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({super.key});

  @override
  State<TriviaControls> createState() => TriviaControlsState();
}

class TriviaControlsState extends State<TriviaControls> {
  String _numberStr = '';

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

            _numberStr = value;
          },
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _getConcreteNumberTrivia(context),
                child: const Text('Search'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                child: const Text('Get random trivia'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _getConcreteNumberTrivia(BuildContext ctx) {
    ctx
        .read<NumberTriviaBloc>()
        .add(NumberTriviaGetConcreteRequested(numberString: _numberStr));
  }
}
