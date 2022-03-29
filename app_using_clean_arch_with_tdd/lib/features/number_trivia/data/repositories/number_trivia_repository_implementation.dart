//KARKALA SRINIVASA VENKATARAMANA
//OM JAI DURGE MAA

import 'package:app_using_clean_arch_with_tdd/core/platform/network_info.dart';
import 'package:app_using_clean_arch_with_tdd/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:app_using_clean_arch_with_tdd/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:app_using_clean_arch_with_tdd/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:app_using_clean_arch_with_tdd/core/failures/failures.dart';
import 'package:app_using_clean_arch_with_tdd/features/number_trivia/domain/repositories/number_trivia_repository_contract.dart';
import 'package:dartz/dartz.dart';

class NumberTriviaRepositoryImplementation
    implements NumberTriviaRepositoryContract {
  NumberTriviaRemoteDataSource remoteDataSource;
  NumberTriviaLocalDataSource localDataSource;
  NetworkInfo networkInfo;

  NumberTriviaRepositoryImplementation({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failures, NumberTriviaEntity>?>? getConcreteNumberTrivia(
      int number) {
    networkInfo.isConnected;
  }

  @override
  Future<Either<Failures, NumberTriviaEntity>?>? getRandomNumberTrivia() {}
}
