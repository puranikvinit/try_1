//KARKALA SRINIVASA VENKATARAMANA
//OM JAI DURGE MAA

import 'package:app_using_clean_arch_with_tdd/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:app_using_clean_arch_with_tdd/features/number_trivia/domain/repositories/number_trivia_repository_contract.dart';
import 'package:app_using_clean_arch_with_tdd/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRepositoryContract extends Mock
    implements NumberTriviaRepositoryContract {}

void main() {
  MockNumberTriviaRepositoryContract mockNumberTriviaRepositoryContract =
      MockNumberTriviaRepositoryContract();
  GetRandomNumberTrivia usecase = GetRandomNumberTrivia(
    numberTriviaRepositoryContract: mockNumberTriviaRepositoryContract,
  );

  const tNumberTrivia = NumberTriviaEntity(number: 1, trivia: "Test");

  test("Given When Then", () async {
    //Arrange
    when(mockNumberTriviaRepositoryContract.getRandomNumberTrivia())
        .thenAnswer((_) async => const Right(tNumberTrivia));
    //Act
    final result = await usecase.call(number: null);
    //Assert
    expect(result, const Right(tNumberTrivia));
  });
}
