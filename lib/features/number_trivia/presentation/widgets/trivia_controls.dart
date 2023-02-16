import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/presentation/blocs/number_trivia/number_trivia_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({super.key});

  @override
  State<TriviaControls> createState() => TriviaControlsState();
}

class TriviaControlsState extends State<TriviaControls> {
  late final TextEditingController _controller;
  String _numberStr = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
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

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _getConcreteNumberTrivia(BuildContext ctx) {
    _controller.clear();
    ctx
        .read<NumberTriviaBloc>()
        .add(NumberTriviaGetConcreteRequested(numberString: _numberStr));
  }
}
