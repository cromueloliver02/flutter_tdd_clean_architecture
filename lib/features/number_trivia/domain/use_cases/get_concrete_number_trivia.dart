import 'package:dartz/dartz.dart';

import '../../../../core/use_cases/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/number_trivia_entity.dart';
import '../repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}
