import 'package:flutter_tdd_clean_architecture/core/error/cache_failure.dart';
import 'package:flutter_tdd_clean_architecture/core/error/server_failure.dart';
import 'package:flutter_tdd_clean_architecture/core/use_cases/use_case.dart';
import 'package:flutter_tdd_clean_architecture/core/utils/input_converter.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/presentation/blocs/number_trivia/number_trivia_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc? bloc;
  MockGetConcreteNumberTrivia? mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia? mockGetRandomNumberTrivia;
  MockInputConverter? mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia!,
      random: mockGetRandomNumberTrivia!,
      inputConverter: mockInputConverter!,
    );
  });

  tearDown(() {
    mockGetConcreteNumberTrivia = null;
    mockGetRandomNumberTrivia = null;
    mockInputConverter = null;
    bloc = null;
  });

  test('NumberTriviaState should be initial state', () {
    expect(bloc!.state, equals(NumberTriviaInitial()));
  });

  group('GetTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia(number: 1, text: 'test');

    void setUpMockInputConverterSuccess() {
      when(() => mockInputConverter!.stringToUnsignedInteger(any<String>()))
          .thenReturn(const Right(tNumberParsed));
    }

    test(
        'should call the InputConverter to validate and convert the string to am unsigned integer',
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      // act
      bloc!.add(
        const NumberTriviaGetConcreteRequested(numberString: tNumberString),
      );
      await untilCalled(
        () => mockInputConverter!.stringToUnsignedInteger(any<String>()),
      );
      // assert
      verify(() => mockInputConverter!.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [Error] when the input is invalid', () async {
      // arrange
      when(() => mockInputConverter!.stringToUnsignedInteger(any<String>()))
          .thenReturn(Left(InvalidInputFailure()));

      // assert later
      final expected = [
        NumberTriviaInitial(),
        const NumberTriviaFailure(message: kInputFailureMessage),
      ];
      expectLater(bloc!.stream, emitsInOrder(expected));

      // act
      bloc!.add(
        const NumberTriviaGetConcreteRequested(numberString: tNumberString),
      );
    });

    test('should get the data from the concrete use case', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(() => mockGetConcreteNumberTrivia!(Params(number: any<int>())))
          .thenAnswer((invocation) async => const Right(tNumberTrivia));
      // act
      bloc!.add(
        const NumberTriviaGetConcreteRequested(numberString: tNumberString),
      );
      await untilCalled(
        () => mockGetConcreteNumberTrivia!(Params(number: any<int>())),
      );
      // assert
      verify(
        () => mockGetConcreteNumberTrivia!(const Params(number: tNumberParsed)),
      );
    });

    test('should emit [Loading, Success] when data is gotten successfully', () {
      // arrange
      setUpMockInputConverterSuccess();
      when(() => mockGetConcreteNumberTrivia!(Params(number: any<int>())))
          .thenAnswer((invocation) async => const Right(tNumberTrivia));
      // assert later
      final expected = [
        NumberTriviaInitial(),
        NumberTriviaLoading(),
        const NumberTriviaSuccess(trivia: tNumberTrivia),
      ];
      expectLater(bloc!.stream, emitsInOrder(expected));
      // act
      bloc!.add(
        const NumberTriviaGetConcreteRequested(numberString: tNumberString),
      );
    });

    test('should emit [Loading, Failure] when getting data fails', () {
      // arrange
      setUpMockInputConverterSuccess();
      when(() => mockGetConcreteNumberTrivia!(Params(number: any<int>())))
          .thenAnswer((invocation) async => Left(ServerFailure()));
      // assert later
      final expected = [
        NumberTriviaInitial(),
        NumberTriviaLoading(),
        const NumberTriviaFailure(message: kServerFailureMessage),
      ];
      expectLater(bloc!.stream, emitsInOrder(expected));
      // act
      bloc!.add(
        const NumberTriviaGetConcreteRequested(numberString: tNumberString),
      );
    });

    test(
        'should emit [Loading, Failure] with a proper message for the error when getting data fails',
        () {
      // arrange
      setUpMockInputConverterSuccess();
      when(() => mockGetConcreteNumberTrivia!(Params(number: any<int>())))
          .thenAnswer((invocation) async => Left(CacheFailure()));
      // assert later
      final expected = [
        NumberTriviaInitial(),
        NumberTriviaLoading(),
        const NumberTriviaFailure(message: kCacheFailureMessage),
      ];
      expectLater(bloc!.stream, emitsInOrder(expected));
      // act
      bloc!.add(
        const NumberTriviaGetConcreteRequested(numberString: tNumberString),
      );
    });
  });
}
