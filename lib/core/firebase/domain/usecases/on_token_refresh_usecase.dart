import 'package:dartz/dartz.dart';
import 'package:athlorun/core/firebase/domain/repository/firebase_repository.dart';
import 'package:athlorun/core/status/failures.dart';

class OnTokenRefreshUsecase {
  final FirebaseRepository _repository;

  const OnTokenRefreshUsecase(this._repository);

  Future<Either<Failure, void>> call(void Function(String) onData) async {
    return _repository.onTokenRefresh(onData);
  }
}
