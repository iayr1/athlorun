import 'package:dartz/dartz.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/features/home/domain/repository/home_repository.dart';

class GetNotificationsUsecase {
  final HomeRepository _homeRepository;
  const GetNotificationsUsecase(this._homeRepository);
  Future<Either<Failure, dynamic>> call(String type, String status) async {
    return _homeRepository.getNotifications(type, status);
  }
}
