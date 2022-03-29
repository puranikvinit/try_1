//KARKALA SRINIVASA VENKATARAMANA
//OM JAI DURGE MAA

import 'package:app_using_clean_arch_with_tdd/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTriviaModel);
}
