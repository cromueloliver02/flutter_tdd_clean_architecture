import 'dart:convert';

import 'package:flutter_tdd_clean_architecture/core/error/cache_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel numberTrivia);
}

const kCachedNumberTrivia = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  const NumberTriviaLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(kCachedNumberTrivia);

    if (jsonString == null) throw CacheException();

    final numberTrivia = NumberTriviaModel.fromMap(jsonDecode(jsonString));

    return Future.value(numberTrivia);
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTrivia) {
    // TODO: implement cacheNumberTrivia
    throw UnimplementedError();
  }
}
