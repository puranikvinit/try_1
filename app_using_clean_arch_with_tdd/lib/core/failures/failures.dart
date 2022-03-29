//KARKALA SRINIVASA VENKATARAMANA
//OM JAI DURGE MAA

import 'package:equatable/equatable.dart';

abstract class Failures extends Equatable {
  final List properties;

  const Failures({
    required this.properties,
  });

  @override
  List<Object?> get props => [
        properties,
      ];
}


abstract class ServerFailure implements Failures {}

abstract class CacheFailure implements Failures {}
