//KARKALA SRINIVASA VENKATARAMANA
//OM JAI DURGE MAA

import 'package:app_using_clean_arch_with_tdd/core/platform/network_info.dart';
import 'package:app_using_clean_arch_with_tdd/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:app_using_clean_arch_with_tdd/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:app_using_clean_arch_with_tdd/features/number_trivia/data/repositories/number_trivia_repository_implementation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  MockRemoteDataSource mockRemoteDataSource = MockRemoteDataSource();
  MockLocalDataSource mockLocalDataSource = MockLocalDataSource();
  MockNetworkInfo mockNetworkInfo = MockNetworkInfo();

  NumberTriviaRepositoryImplementation numberTriviaRepositoryImplementation =
      NumberTriviaRepositoryImplementation(
    remoteDataSource: mockRemoteDataSource,
    localDataSource: mockLocalDataSource,
    networkInfo: mockNetworkInfo,
  );

  test("Should Check if the Device is Online", () async {
    //Arrange
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    //Act
    numberTriviaRepositoryImplementation.getConcreteNumberTrivia(1);
    //Assert
    verify(mockNetworkInfo.isConnected);
  });
}
