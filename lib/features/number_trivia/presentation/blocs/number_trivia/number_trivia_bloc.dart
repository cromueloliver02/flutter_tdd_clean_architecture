import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tdd_clean_architecture/core/error/failure.dart';
import 'package:flutter_tdd_clean_architecture/core/use_cases/use_case.dart';
import 'package:flutter_tdd_clean_architecture/core/utils/input_converter.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';

import '../../../domain/entities/number_trivia_entity.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String kServerFailureMessage = 'Server Failure';
const String kCacheFailureMessage = 'Cache Failure';
const String kInputFailureMessage =
    'Invalid Input - The number must be a positive integer or zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia _getConcreteNumberTrivia;
  final GetRandomNumberTrivia _getRandomNumberTrivia;
  final InputConverter _inputConverter;

  NumberTriviaBloc({
    required GetConcreteNumberTrivia concrete,
    required GetRandomNumberTrivia random,
    required InputConverter inputConverter,
  })  : _getConcreteNumberTrivia = concrete,
        _getRandomNumberTrivia = random,
        _inputConverter = inputConverter,
        super(NumberTriviaInitial()) {
    on<NumberTriviaGetConcreteRequested>(_onNumberTriviaGetConcreteRequested);
  }

  void _onNumberTriviaGetConcreteRequested(
    NumberTriviaGetConcreteRequested event,
    Emitter<NumberTriviaState> emit,
  ) {
    emit(NumberTriviaInitial()); // temporary hack

    final inputEither =
        _inputConverter.stringToUnsignedInteger(event.numberString);

    inputEither.fold(
      (Failure l) => emit(const NumberTriviaFailure(kInputFailureMessage)),
      (int number) async {
        emit(NumberTriviaLoading());
        final failureOrTrivia =
            await _getConcreteNumberTrivia(Params(number: number));

        failureOrTrivia.fold(
          (Failure failure) =>
              emit(const NumberTriviaFailure(kInputFailureMessage)),
          (NumberTrivia trivia) => emit(NumberTriviaSuccess(trivia: trivia)),
        );
      },
    );
  }
}
