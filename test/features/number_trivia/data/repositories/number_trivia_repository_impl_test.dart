import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
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
    const tNumberTrivia = tNumberTriviaModel;

    test(
      'should check if the device is online',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer(
          (invocation) async => true,
        );
        // act
        repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(() => mockNetworkInfo.isConnected);
      },
    );
  });
}
