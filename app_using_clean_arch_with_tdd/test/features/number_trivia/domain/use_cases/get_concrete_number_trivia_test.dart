//KARKALA SRINIVASA VENKATARAMANA
//OM JAI DURGE MAA

import 'package:app_using_clean_arch_with_tdd/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:app_using_clean_arch_with_tdd/features/number_trivia/domain/repositories/number_trivia_repository_contract.dart';
import 'package:app_using_clean_arch_with_tdd/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRepositoryContract extends Mock
    implements NumberTriviaRepositoryContract {}

void main() {
  MockNumberTriviaRepositoryContract mockNumberTriviaRepositoryContract =
      MockNumberTriviaRepositoryContract();
  GetConcreteNumberTrivia usecase = GetConcreteNumberTrivia(
    repo: mockNumberTriviaRepositoryContract,
  );

  const tNumberTriviaEntity = NumberTriviaEntity(number: 1, trivia: "Test");

  test(
    "Given When Then",
    () async {
      //Arrange
      when(mockNumberTriviaRepositoryContract.getConcreteNumberTrivia(1))
          .thenAnswer((_) async => const Right(tNumberTriviaEntity));
      //Act
      final result = await usecase(number: 1);
      //Assert
      expect(
        result,
        const Right(tNumberTriviaEntity),
      );
    },
  );
}
