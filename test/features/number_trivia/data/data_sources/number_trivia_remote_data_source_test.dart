import 'dart:convert';

import 'package:flutter_tdd_clean_architecture/core/error/server_exception.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late final NumberTriviaRemoteDataSourceImpl dataSource;
  late final MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromMap(jsonDecode(fixture('trivia.json')));

    test(
      '''should perform a GET request on a URL with number being the
      endpoint and with application/json header''',
      () {
        // arrange
        when(() => mockHttpClient.get(any<Uri>(), headers: any())).thenAnswer(
            (invocation) async => http.Response(fixture('trivia.json'), 200));
        // act
        dataSource.getConcreteNumberTrivia(tNumber);
        // assert
        verify(() => mockHttpClient.get(
              Uri.parse('http://numbersapi.com/$tNumber'),
              headers: {'Content-Type': 'application/json'},
            ));
      },
    );

    test('should return NumberTrivia when the response code is 200 (success)',
        () async {
      // arrange
      when(() => mockHttpClient.get(any<Uri>(), headers: any())).thenAnswer(
          (invocation) async => http.Response(fixture('trivia.json'), 200));
      // act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'should return a ServerException when the response code is NOT 200 (success)',
        () async {
      // arrange
      when(() => mockHttpClient.get(any<Uri>(), headers: any())).thenAnswer(
          (invocation) async => http.Response('Something went wrong', 200));
      // act
      final call = dataSource.getConcreteNumberTrivia;
      // assert
      expect(
          () => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
