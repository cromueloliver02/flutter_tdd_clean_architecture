part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();

  @override
  List<Object> get props => [];
}

class NumberTriviaInitial extends NumberTriviaState {}

class NumberTriviaLoading extends NumberTriviaState {}

class NumberTriviaSuccess extends NumberTriviaState {
  final NumberTrivia trivia;

  const NumberTriviaSuccess({required this.trivia});

  @override
  List<Object> get props => [trivia];
}

class NumberTriviaFailure extends NumberTriviaState {
  final String message;

  const NumberTriviaFailure({required this.message});

  @override
  List<Object> get props => [message];
}
