import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tdd_clean_architecture/core/error/cache_exception.dart';
import 'package:flutter_tdd_clean_architecture/core/error/cache_failure.dart';
import 'package:flutter_tdd_clean_architecture/core/error/server_exception.dart';
import 'package:flutter_tdd_clean_architecture/core/error/server_failure.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:flutter_tdd_clean_architecture/core/network/network_info.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

main() {
  MockRemoteDataSource? mockRemoteDataSource;
  MockLocalDataSource? mockLocalDataSource;
  MockNetworkInfo? mockNetworkInfo;
  NumberTriviaRepositoryImpl? repository;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource!,
      localDataSource: mockLocalDataSource!,
      networkInfo: mockNetworkInfo!,
    );
  });

  tearDown(() {
    mockRemoteDataSource = null;
    mockLocalDataSource = null;
    mockNetworkInfo = null;
    repository = null;
  });

  void runTestsOnline(VoidCallback body) {
    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo!.isConnected).thenAnswer(
          (invocation) async => true,
        );
      });

      body();
    });
  }

  void runTestsOffline(VoidCallback body) {
    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo!.isConnected).thenAnswer(
          (invocation) async => true,
        );
      });

      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    const tNumberTriviaModel = NumberTriviaModel(number: tNumber, text: 'test');
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test(
      'should check if the device is online',
      () async {
        // arrange
        when(() => mockNetworkInfo!.isConnected).thenAnswer(
          (invocation) async => true,
        );
        when(() => mockRemoteDataSource!.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        repository!.getConcreteNumberTrivia(tNumber);
        // assert
        verify(() => mockNetworkInfo!.isConnected);
      },
    );

    runTestsOnline(() {
      setUp(() {
        when(() => mockNetworkInfo!.isConnected).thenAnswer(
          (invocation) async => true,
        );

        test(
          'should return remote data when the call to remote data source is success',
          () async {
            // arrange
            when(() =>
                    mockRemoteDataSource!.getConcreteNumberTrivia(any<int>()))
                .thenAnswer((invocation) async => tNumberTriviaModel);
            // act
            final result = await repository!.getConcreteNumberTrivia(tNumber);
            // assert
            verify(
                () => mockRemoteDataSource!.getConcreteNumberTrivia(tNumber));
            expect(result, equals(const Right(tNumberTrivia)));
          },
        );

        test(
          'should cache the data locally whem the call to remote data source is success',
          () async {
            // arrange
            when(() =>
                    mockRemoteDataSource!.getConcreteNumberTrivia(any<int>()))
                .thenAnswer((invocation) async => tNumberTriviaModel);
            // act
            await repository!.getConcreteNumberTrivia(tNumber);
            // assert
            verify(
                () => mockRemoteDataSource!.getConcreteNumberTrivia(tNumber));
            verifyNoMoreInteractions(() =>
                mockLocalDataSource!.cacheNumberTrivia(tNumberTriviaModel));
          },
        );

        test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
            // arrange
            when(() =>
                    mockRemoteDataSource!.getConcreteNumberTrivia(any<int>()))
                .thenThrow(ServerException());
            // act
            final result = await repository!.getConcreteNumberTrivia(tNumber);
            // assert
            verify(
                () => mockRemoteDataSource!.getConcreteNumberTrivia(tNumber));
            verifyZeroInteractions(mockLocalDataSource);
            expect(result, equals(Left(ServerFailure())));
          },
        );
      });
    });

    runTestsOffline(() {
      setUp(() {
        when(() => mockNetworkInfo!.isConnected).thenAnswer(
          (invocation) async => true,
        );
      });

      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(() => mockLocalDataSource!.getLastNumberTrivia())
              .thenAnswer((invocation) async => tNumberTriviaModel);
          // act
          final result = await repository!.getConcreteNumberTrivia(tNumber);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource!.getLastNumberTrivia());
          expect(result, equals(const Right(tNumberTrivia)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          // arrange
          when(() => mockLocalDataSource!.getLastNumberTrivia())
              .thenThrow(CacheException());
          // act
          final result = await repository!.getConcreteNumberTrivia(tNumber);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource!.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });

  group('getRandomNumberTrivia', () {
    const tNumberTriviaModel = NumberTriviaModel(number: 123, text: 'test');
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test(
      'should check if the device is online',
      () async {
        // arrange
        when(() => mockNetworkInfo!.isConnected).thenAnswer(
          (invocation) async => true,
        );
        when(() => mockRemoteDataSource!.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        repository!.getRandomNumberTrivia();
        // assert
        verify(() => mockNetworkInfo!.isConnected);
      },
    );

    runTestsOnline(() {
      setUp(() {
        when(() => mockNetworkInfo!.isConnected).thenAnswer(
          (invocation) async => true,
        );

        test(
          'should return remote data when the call to remote data source is success',
          () async {
            // arrange
            when(() => mockRemoteDataSource!.getRandomNumberTrivia())
                .thenAnswer((invocation) async => tNumberTriviaModel);
            // act
            final result = await repository!.getRandomNumberTrivia();
            // assert
            verify(() => mockRemoteDataSource!.getRandomNumberTrivia());
            expect(result, equals(const Right(tNumberTrivia)));
          },
        );

        test(
          'should cache the data locally whem the call to remote data source is success',
          () async {
            // arrange
            when(() => mockRemoteDataSource!.getRandomNumberTrivia())
                .thenAnswer((invocation) async => tNumberTriviaModel);
            // act
            await repository!.getRandomNumberTrivia();
            // assert
            verify(() => mockRemoteDataSource!.getRandomNumberTrivia());
            verifyNoMoreInteractions(() =>
                mockLocalDataSource!.cacheNumberTrivia(tNumberTriviaModel));
          },
        );

        test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
            // arrange
            when(() => mockRemoteDataSource!.getRandomNumberTrivia())
                .thenThrow(ServerException());
            // act
            final result = await repository!.getRandomNumberTrivia();
            // assert
            verify(() => mockRemoteDataSource!.getRandomNumberTrivia());
            verifyZeroInteractions(mockLocalDataSource);
            expect(result, equals(Left(ServerFailure())));
          },
        );
      });
    });

    runTestsOffline(() {
      setUp(() {
        when(() => mockNetworkInfo!.isConnected).thenAnswer(
          (invocation) async => true,
        );
      });

      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(() => mockLocalDataSource!.getLastNumberTrivia())
              .thenAnswer((invocation) async => tNumberTriviaModel);
          // act
          final result = await repository!.getRandomNumberTrivia();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource!.getLastNumberTrivia());
          expect(result, equals(const Right(tNumberTrivia)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          // arrange
          when(() => mockLocalDataSource!.getLastNumberTrivia())
              .thenThrow(CacheException());
          // act
          final result = await repository!.getRandomNumberTrivia();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource!.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
