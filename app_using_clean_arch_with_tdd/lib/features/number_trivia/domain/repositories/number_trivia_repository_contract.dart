//KARKALA SRINIVASA VENKATARAMANA
//OM JAI DURGE MAA

import 'package:app_using_clean_arch_with_tdd/core/failures/failures.dart';
import 'package:app_using_clean_arch_with_tdd/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:dartz/dartz.dart';

abstract class NumberTriviaRepositoryContract {
  Future<Either<Failures, NumberTriviaEntity>?>? getConcreteNumberTrivia(
      int number);

  Future<Either<Failures, NumberTriviaEntity>?>? getRandomNumberTrivia();
}
