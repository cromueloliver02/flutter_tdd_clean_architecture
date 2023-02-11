import 'package:dartz/dartz.dart';

import '../../features/number_trivia/data/models/number_trivia_model.dart';
import '../../features/number_trivia/domain/entities/number_trivia_entity.dart';
import '../error/failure.dart';

typedef FutureEitherNumberTrivia = Future<Either<Failure, NumberTrivia>>;

typedef FutureNumberTriviaCallback = Future<NumberTriviaModel> Function();
