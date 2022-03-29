//KARKALA SRINIVASA VENKATARAMANA
//OM JAI DURGE MAA

import 'package:app_using_clean_arch_with_tdd/core/failures/failures.dart';
import 'package:app_using_clean_arch_with_tdd/core/usecase_regulation/usecase_regulation.dart';
import 'package:app_using_clean_arch_with_tdd/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:app_using_clean_arch_with_tdd/features/number_trivia/domain/repositories/number_trivia_repository_contract.dart';
import 'package:dartz/dartz.dart';

class GetConcreteNumberTrivia extends UseCaseRegulation{
  NumberTriviaRepositoryContract repo;

  GetConcreteNumberTrivia({
    required this.repo,
  });

  @override
  Future<Either<Failures, NumberTriviaEntity>?>? call({int? number}) async {
    return await repo.getConcreteNumberTrivia(int.parse(number.toString()));
  }
}