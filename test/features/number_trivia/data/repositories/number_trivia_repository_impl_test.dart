import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_architecture/core/error/server_exception.dart';
import 'package:flutter_tdd_clean_architecture/core/error/server_failure.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:flutter_tdd_clean_architecture/core/platform/network_info.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

main() {
  late final MockRemoteDataSource mockRemoteDataSource;
  late final MockLocalDataSource mockLocalDataSource;
  late final MockNetworkInfo mockNetworkInfo;
  late final NumberTriviaRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    const tNumberTriviaModel = NumberTriviaModel(number: tNumber, text: 'test');
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test(
      'should check if the device is online',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer(
          (invocation) async => true,
        );
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(() => mockNetworkInfo.isConnected);
      },
    );

    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer(
          (invocation) async => true,
        );

        test(
          'should return remote data when the call to remote data source is success',
          () async {
            // arrange
            when(() => mockRemoteDataSource.getConcreteNumberTrivia(any<int>()))
                .thenAnswer((invocation) async => tNumberTriviaModel);
            // act
            final result = await repository.getConcreteNumberTrivia(tNumber);
            // assert
            verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
            expect(result, equals(const Right(tNumberTrivia)));
          },
        );

        test(
          'should cache the data locally whem the call to remote data source is success',
          () async {
            // arrange
            when(() => mockRemoteDataSource.getConcreteNumberTrivia(any<int>()))
                .thenAnswer((invocation) async => tNumberTriviaModel);
            // act
            await repository.getConcreteNumberTrivia(tNumber);
            // assert
            verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
            verifyNoMoreInteractions(() =>
                mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
          },
        );

        test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
            // arrange
            when(() => mockRemoteDataSource.getConcreteNumberTrivia(any<int>()))
                .thenThrow(ServerException());
            // act
            final result = await repository.getConcreteNumberTrivia(tNumber);
            // assert
            verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
            verifyZeroInteractions(mockLocalDataSource);
            expect(result, equals(Left(ServerFailure())));
          },
        );
      });
    });
  });
}
