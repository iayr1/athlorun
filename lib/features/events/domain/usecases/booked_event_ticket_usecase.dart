import 'package:dartz/dartz.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/features/events/data/models/request/ticket_booking_request_model.dart';
import 'package:athlorun/features/events/data/models/response/ticket_booking_response_model.dart';
import 'package:athlorun/features/events/domain/repository/events_repository.dart';

class BookedEventTicketUsecase {
  final EventsRepository _eventsRepository;
  BookedEventTicketUsecase(this._eventsRepository);

  Future<Either<Failure, TicketBookingResponseModel>> call(
      TicketBookingRequestModel body,
      String userId,
      String eventId,
      String slotId) async {
    return _eventsRepository.bookedEventTicket(body, userId, eventId, slotId);
  }
}
