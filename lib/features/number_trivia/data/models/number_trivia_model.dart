import '../../domain/entities/number_trivia_entity.dart';

class NumberTriviaModel extends NumberTrivia {
  const NumberTriviaModel({
    required super.number,
    required super.text,
  });

  factory NumberTriviaModel.fromMap(Map<String, dynamic> map) {
    return NumberTriviaModel(
      number: map['number']?.toInt() ?? 0,
      text: map['text'] ?? '',
    );
  }
}
