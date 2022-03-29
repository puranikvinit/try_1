//KARKALA SRINIVASA VENKATARAMANA
//OM JAI DURGE MAA

import 'package:equatable/equatable.dart';

class NumberTriviaEntity extends Equatable {
  final int number;
  final String trivia;

  const NumberTriviaEntity({
    required this.number,
    required this.trivia,
  });

  @override
  List<Object?> get props => [
        number,
        trivia,
      ];
}
