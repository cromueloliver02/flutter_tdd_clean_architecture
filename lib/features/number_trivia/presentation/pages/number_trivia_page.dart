import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/number_trivia/number_trivia_bloc.dart';
import '../widgets/widgets.dart';
import '../../../../injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: _buildNumberTrivia,
              ),
              const SizedBox(height: 10),
              const TriviaControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberTrivia(BuildContext ctx, NumberTriviaState state) {
    final Size screenSize = MediaQuery.of(ctx).size;

    if (state is NumberTriviaInitial) {
      return const MessageCard(message: 'Start searching!');
    }

    if (state is NumberTriviaLoading) {
      return const LoadingCard();
    }

    if (state is NumberTriviaFailure) {
      return MessageCard(message: state.message);
    }

    if (state is NumberTriviaSuccess) {
      return TriviaCard(numberTrivia: state.trivia);
    }

    return SizedBox(
      height: screenSize.height / 3,
      child: const Placeholder(),
    );
  }
}
