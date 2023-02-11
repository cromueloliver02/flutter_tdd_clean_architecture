import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_architecture/core/error/cache_failure.dart';
import 'package:flutter_tdd_clean_architecture/core/error/server_exception.dart';
import 'package:flutter_tdd_clean_architecture/core/error/server_failure.dart';

import '../../../../core/network/network_info.dart';
import '../../../../core/typedefs/typedefs.dart';
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
  FutureEitherNumberTrivia getConcreteNumberTrivia(
    int number,
  ) async {
    return _getNumberTrivia(
      () => remoteDataSource.getConcreteNumberTrivia(number),
    );
  }

  @override
  FutureEitherNumberTrivia getRandomNumberTrivia() async {
    return _getNumberTrivia(remoteDataSource.getRandomNumberTrivia);
  }

  FutureEitherNumberTrivia _getNumberTrivia(
    FutureNumberTriviaCallback getTriviaCallbank,
  ) async {
    final bool isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        final NumberTriviaModel numberTrivia = await getTriviaCallbank();
        localDataSource.cacheNumberTrivia(numberTrivia);

        return Right(numberTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final NumberTriviaModel numberTrivia =
            await localDataSource.getLastNumberTrivia();

        return Right(numberTrivia);
      } on CacheFailure {
        return Left(CacheFailure());
      }
    }
  }
}
