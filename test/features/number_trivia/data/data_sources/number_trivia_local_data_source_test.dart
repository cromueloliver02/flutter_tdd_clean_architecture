import 'dart:convert';

import 'package:flutter_tdd_clean_architecture/core/error/cache_exception.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  MockSharedPreferences? mockSharedPreferences;
  NumberTriviaLocalDataSourceImpl? dataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(mockSharedPreferences!);
  });

  tearDown(() {
    mockSharedPreferences = null;
    dataSource = null;
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromMap(jsonDecode(fixture('trivia_cached.json')));

    test(
      'should return NumberTrivia from SharedPreferences when there is one in the cache',
      () async {
        // arrange
        when(() => mockSharedPreferences!.getString(any<String>()))
            .thenReturn(fixture('trivia_cached.json'));
        // act
        final result = await dataSource!.getLastNumberTrivia();
        // assert
        verify(() => mockSharedPreferences!.getString(kCachedNumberTrivia));
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a CacheException when there is no cache number trivia',
      () async {
        // arrange
        when(() => mockSharedPreferences!.getString(any<String>()))
            .thenReturn(null);
        // act
        final call = dataSource!.getLastNumberTrivia;
        // assert
        expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheNumberTrivia', () {
    const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'test');

    test(
      'should call SharedPreferences to cache the data',
      () async {
        // act
        dataSource!.cacheNumberTrivia(tNumberTriviaModel);
        // assert
        final expectedJsonString = jsonEncode(tNumberTriviaModel.toMap());
        verify(() => mockSharedPreferences!
            .setString(kCachedNumberTrivia, expectedJsonString));
      },
    );
  });
}
