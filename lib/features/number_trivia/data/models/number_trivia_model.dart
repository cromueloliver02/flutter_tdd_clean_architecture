import '../../domain/entities/number_trivia_entity.dart';

class NumberTriviaModel extends NumberTrivia {
  const NumberTriviaModel({
    required super.number,
    required super.text,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'number': number});
    result.addAll({'text': text});

    return result;
  }

  factory NumberTriviaModel.fromMap(Map<String, dynamic> map) {
    return NumberTriviaModel(
      number: map['number']?.toInt() ?? 0,
      text: map['text'] ?? '',
    );
  }
}
