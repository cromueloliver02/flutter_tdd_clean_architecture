import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_tdd_clean_architecture/core/error/failure.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late GetConcreteNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  const tNumber = 1;
  const tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  test(
    'should get trivia for the number from the repository',
    () async {
      // arrange
      when<Future<Either<Failure, NumberTrivia>>>(
        () => mockNumberTriviaRepository.getConcreteNumberTrivia(any<int>()),
      ).thenAnswer((realInvocation) async => const Right(tNumberTrivia));

      // act
      final result = await usecase(number: tNumber);

      // assert
      expect(result, const Right(tNumberTrivia));
      verify<Future<Either<Failure, NumberTrivia>>>(
        () => mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber),
      );
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
