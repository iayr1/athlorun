import 'package:dartz/dartz.dart';
import 'package:athlorun/core/global_store/data/models/user_data_progress_model.dart';
import 'package:athlorun/core/global_store/domain/repository/global_store_repository.dart';
import 'package:athlorun/core/status/failures.dart';

class GetUserDataProgressModelUsecase {
  final GlobalStoreRepository _repository;
  GetUserDataProgressModelUsecase(this._repository);
  Future<Either<Failure, UserDataProgressModel>> call() async {
    return _repository.getUserDataProgressModel();
  }
}
