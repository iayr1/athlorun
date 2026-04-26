import 'package:dartz/dartz.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/core/utils/utils.dart';
import 'package:athlorun/features/events/data/datasource/remote/event_client.dart';
import 'package:athlorun/features/events/data/models/request/ticket_booking_request_model.dart';
import 'package:athlorun/features/events/data/models/response/get_events_response_model.dart';
import 'package:athlorun/features/events/data/models/response/ticket_booking_response_model.dart';
import 'package:athlorun/features/events/domain/repository/events_repository.dart';

class EventsRespositoryImpl implements EventsRepository {
  final EventClient _eventClient;
  const EventsRespositoryImpl(this._eventClient);

  @override
  Future<Either<Failure, GetEventsResponseModel>> getEvents() async {
    try {
      final response = await _eventClient.getEvents();
      return right(response);
    } catch (e) {
      Utils.debugLog(e.toString());
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, TicketBookingResponseModel>> bookedEventTicket(
      TicketBookingRequestModel body,
      String userId,
      String eventId,
      String slotId) async {
    try {
      final response =
          await _eventClient.bookedEventTicket(body, userId, eventId, slotId);
      return right(response);
    } catch (e) {
      Utils.debugLog(e.toString());
      return left(ServerFailure());
    }
  }
}
