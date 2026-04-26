import 'package:dartz/dartz.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/features/settings/data/model/delete_user_response_model.dart';
import 'package:athlorun/features/settings/domain/repository/settings_repository.dart';

class DeleteUserUsecase {
  final SettingsRepository _repository;
  const DeleteUserUsecase(this._repository);
  Future<Either<Failure, DeleteUserResponseModel>> call(String id) async {
    return _repository.deleteUser(id);
  }
}
