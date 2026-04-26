import 'package:athlorun/core/firebase/data/datasources/remote/firestore_backend.dart';
import 'package:athlorun/features/events/data/models/request/ticket_booking_request_model.dart';
import 'package:athlorun/features/events/data/models/response/get_events_response_model.dart';
import 'package:athlorun/features/events/data/models/response/ticket_booking_response_model.dart';

class EventClient {
  EventClient(this._backend);

  final FirestoreBackend _backend;

  Future<GetEventsResponseModel> getEvents() async {
    final events = await _backend.getCollection(collection: 'events');
    return GetEventsResponseModel.fromJson({
      'status': 200,
      'statusText': 'OK',
      'message': 'Fetched',
      'data': events,
    });
  }

  Future<TicketBookingResponseModel> bookedEventTicket(
    TicketBookingRequestModel body,
    String userId,
    String eventId,
    String slotId,
  ) async {
    final data = body.toJson()
      ..addAll({'userId': userId, 'eventId': eventId, 'slotId': slotId});
    await _backend.upsertDocument(
      collection: 'event_bookings',
      docId: '$userId-$eventId-$slotId',
      data: data,
    );
    return TicketBookingResponseModel.fromJson({
      'status': 200,
      'statusText': 'OK',
      'message': 'Booked',
      'data': data,
    });
  }
}
