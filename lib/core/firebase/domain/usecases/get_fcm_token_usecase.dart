import 'package:dartz/dartz.dart';
import 'package:athlorun/core/firebase/domain/repository/firebase_repository.dart';
import 'package:athlorun/core/status/failures.dart';

class GetFcmTokenUsecase {
  final FirebaseRepository _repository;

  const GetFcmTokenUsecase(this._repository);

  Future<Either<Failure, String?>> call() async {
    return _repository.getFcmToken();
  }
}
