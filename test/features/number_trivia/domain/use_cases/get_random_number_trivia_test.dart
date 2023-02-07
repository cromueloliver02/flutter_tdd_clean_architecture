import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_tdd_clean_architecture/core/error/failure.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late GetRandomNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  const tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  test(
    'should get trivia from the repository',
    () async {
      // arrange
      when<Future<Either<Failure, NumberTrivia>>>(
        () => mockNumberTriviaRepository.getRandomNumberTrivia(),
      ).thenAnswer((realInvocation) async => const Right(tNumberTrivia));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, const Right(tNumberTrivia));
      verify<Future<Either<Failure, NumberTrivia>>>(
        () => mockNumberTriviaRepository.getRandomNumberTrivia(),
      );
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
