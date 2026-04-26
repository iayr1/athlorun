import 'package:dartz/dartz.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/features/events/data/models/request/ticket_booking_request_model.dart';
import 'package:athlorun/features/events/data/models/response/get_events_response_model.dart';
import 'package:athlorun/features/events/data/models/response/ticket_booking_response_model.dart';

abstract class EventsRepository {
  Future<Either<Failure, GetEventsResponseModel>> getEvents();
  Future<Either<Failure, TicketBookingResponseModel>> bookedEventTicket(
    TicketBookingRequestModel body,
    String userId,
    String eventId,
    String slotId,
  );
}
