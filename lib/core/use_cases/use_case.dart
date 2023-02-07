import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../error/failure.dart';

abstract class UseCase<T, P> {
  Future<Either<Failure, T>> call(P params);
}

class Params extends Equatable {
  final int number;

  const Params({
    required this.number,
  });

  @override
  List<Object> get props => [number];
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
