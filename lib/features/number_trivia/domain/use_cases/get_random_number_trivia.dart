import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/use_cases/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/number_trivia_entity.dart';
import '../repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await repository.getRandomNumberTrivia();
  }
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
