//KARKALA SRINIVASA VENKATARAMANA
//OM JAI DURGE MAA

import 'dart:convert';

import 'package:app_using_clean_arch_with_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../core/fixtures/fixtures_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, trivia: "Test Text");

  test("Given When Then", () async {
    //Arrange
    final mapResponse =
        jsonDecode(await fixture('number_trivia_int_response.json'));
    //Act
    final result = NumberTriviaModel.fromJson(mapResponse);
    //Assert
    expect(result, tNumberTriviaModel);
  });

  test("Given When Then", () async {
    //Arrange
    final mapResponse =
        jsonDecode(await fixture('number_trivia_double_response.json'));
    //Act
    final result = NumberTriviaModel.fromJson(mapResponse);
    //Assert
    expect(result, tNumberTriviaModel);
  });
}
