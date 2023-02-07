import 'dart:convert';

import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test text');

  test(
    'should be a subclass of NumberTrivia entity',
    () async {
      // assert
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );

  group(
    'fromMap',
    () {
      test(
        'should return a valid model when the JSON number is an integer',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              jsonDecode(fixture('trivia.json'));

          // act
          final result = NumberTriviaModel.fromMap(jsonMap);

          // assert
          expect(result, equals(tNumberTriviaModel));
        },
      );

      test(
        'should return a valid model when the JSON number is regarded as a double',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              jsonDecode(fixture('trivia_double.json'));

          // act
          final result = NumberTriviaModel.fromMap(jsonMap);

          // assert
          expect(result, equals(tNumberTriviaModel));
        },
      );
    },
  );

  group('toMap', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tNumberTriviaModel.toMap();

        // assert
        final expectedMap = {'number': 1, 'text': 'Test text'};
        expect(result, equals(expectedMap));
      },
    );
  });
}
