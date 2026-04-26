import 'package:dartz/dartz.dart';
import 'package:athlorun/core/global_store/data/models/user_data_progress_model.dart';
import 'package:athlorun/core/global_store/data/models/user_data_response_model.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/features/account_registration/domain/repositoy/account_registration_repository.dart';

class PatchUserDataUsecase {
  final AccountRegistrationRepository _repository;
  const PatchUserDataUsecase(this._repository);
  Future<Either<Failure, UserData>> call(
    String id,
    String token,
    UserDataProgressModel body,
  ) async {
    return _repository.patchUser(id, token, body);
  }
}
