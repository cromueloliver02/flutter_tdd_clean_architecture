import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';

import 'package:flutter_tdd_clean_architecture/core/utils/input_converter.dart';

void main() {
  InputConverter? inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  tearDown(() {
    inputConverter = null;
  });

  group('stringToUnsignedInt', () {
    test(
        'should return an integer when the string represents an unsigned integer',
        () async {
      // arrange
      const str = '123';
      // act
      final result = inputConverter!.stringToUnsignedInteger(str);
      // assert
      expect(result, equals(const Right(123)));
    });

    test('should return a Failure when the string is not an integer', () async {
      // arrange
      const str = 'abc';
      // act
      final result = inputConverter!.stringToUnsignedInteger(str);
      // assert
      expect(result, equals(Left(InvalidInputFailure())));
    });
  });
}
