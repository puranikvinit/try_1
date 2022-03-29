//KARKALA SRINIVASA VENKATARAMANA
//OM JAI DURGE MAA

import 'package:app_using_clean_arch_with_tdd/features/number_trivia/domain/entities/number_trivia_entity.dart';

class NumberTriviaModel extends NumberTriviaEntity {
  const NumberTriviaModel({
    required int number,
    required String trivia,
  }) : super(
          number: number,
          trivia: trivia,
        );

  factory NumberTriviaModel.fromJson(Map<String, dynamic> mapResponse) {
    return NumberTriviaModel(
      number: (mapResponse["number"] as num).toInt(),
      trivia: mapResponse["text"],
    );
  }
}
