import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tdd_clean_architecture/core/error/cache_failure.dart';
import 'package:flutter_tdd_clean_architecture/core/error/failure.dart';
import 'package:flutter_tdd_clean_architecture/core/error/server_failure.dart';
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
    on<NumberTriviaGetRandomRequested>(_onNumberTriviaGetRandomRequested);
  }

  void _onNumberTriviaGetConcreteRequested(
    NumberTriviaGetConcreteRequested event,
    Emitter<NumberTriviaState> emit,
  ) {
    emit(NumberTriviaInitial()); // temporary hack

    final inputEither =
        _inputConverter.stringToUnsignedInteger(event.numberString);

    inputEither.fold(
      (Failure l) =>
          emit(const NumberTriviaFailure(message: kInputFailureMessage)),
      (int number) async {
        emit(NumberTriviaLoading());
        final failureOrTrivia =
            await _getConcreteNumberTrivia(Params(number: number));

        failureOrTrivia.fold(
          (Failure failure) =>
              emit(NumberTriviaFailure(message: _mapFailureToMessage(failure))),
          (NumberTrivia trivia) => emit(NumberTriviaSuccess(trivia: trivia)),
        );
      },
    );
  }

  void _onNumberTriviaGetRandomRequested(
    NumberTriviaGetRandomRequested event,
    Emitter<NumberTriviaState> emit,
  ) async {
    emit(NumberTriviaInitial()); // temporary hack
    emit(NumberTriviaLoading());

    final failureOrTrivia = await _getRandomNumberTrivia(NoParams());

    failureOrTrivia.fold(
      (Failure failure) =>
          emit(NumberTriviaFailure(message: _mapFailureToMessage(failure))),
      (NumberTrivia trivia) => emit(NumberTriviaSuccess(trivia: trivia)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return kServerFailureMessage;
      case CacheFailure:
        return kCacheFailureMessage;
      default:
        return 'Unexpected error';
    }
  }
}
