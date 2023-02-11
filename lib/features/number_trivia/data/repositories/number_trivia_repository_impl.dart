import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_architecture/core/error/server_exception.dart';
import 'package:flutter_tdd_clean_architecture/core/error/server_failure.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/platform/network_info.dart';
import '../../domain/entities/number_trivia_entity.dart';
import '../../domain/repositories/number_trivia_repository.dart';
import '../data_sources/number_trivia_local_data_source.dart';
import '../data_sources/number_trivia_remote_data_source.dart';
import '../models/number_trivia_model.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
    int number,
  ) async {
    networkInfo.isConnected;

    try {
      final NumberTriviaModel numberTrivia =
          await remoteDataSource.getConcreteNumberTrivia(number);
      localDataSource.cacheNumberTrivia(numberTrivia);

      return Right(numberTrivia);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() {
    // TODO: implement getRandomNumberTrivia
    throw UnimplementedError();
  }
}
