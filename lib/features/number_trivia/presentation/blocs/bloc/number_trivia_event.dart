part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();

  @override
  List<Object> get props => [];
}

class NumberTriviaGetConcreteRequested extends NumberTriviaEvent {
  final String numberString;

  const NumberTriviaGetConcreteRequested({
    required this.numberString,
  });

  @override
  List<Object> get props => [numberString];
}

class NumberTriviaGetRandomRequested extends NumberTriviaEvent {}
