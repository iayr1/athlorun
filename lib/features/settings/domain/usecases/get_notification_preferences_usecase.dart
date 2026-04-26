import 'package:dartz/dartz.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/features/settings/data/model/get_notification_preference_response_model.dart';
import 'package:athlorun/features/settings/domain/repository/settings_repository.dart';

class GetNotificationPreferencesUsecase {
  final SettingsRepository _repository;
  const GetNotificationPreferencesUsecase(this._repository);
  Future<Either<Failure, GetNotificationPreferencesResponseModel>> call(
      String id) async {
    return _repository.getNotificationPreferences(id);
  }
}
