import 'package:dartz/dartz.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/features/events/data/models/response/get_events_response_model.dart';
import 'package:athlorun/features/events/domain/repository/events_repository.dart';

class GetEventsUsecase {
  final EventsRepository _eventsRepository;
  GetEventsUsecase(this._eventsRepository);

  Future<Either<Failure, GetEventsResponseModel>> call() async {
    return _eventsRepository.getEvents();
  }
}
