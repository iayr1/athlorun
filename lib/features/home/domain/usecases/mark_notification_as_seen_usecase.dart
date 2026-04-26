import 'package:dartz/dartz.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/features/home/domain/repository/home_repository.dart';

class MarkNotificationAsSeenUsecase {
  final HomeRepository _homeRepository;
  const MarkNotificationAsSeenUsecase(this._homeRepository);
  Future<Either<Failure, dynamic>> call(String id) async {
    return _homeRepository.markNotificationsAsSeen(id);
  }
}
