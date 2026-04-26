import 'package:dio/dio.dart';
import 'package:athlorun/core/constants/api_strings.dart';
import 'package:athlorun/features/events/data/models/request/ticket_booking_request_model.dart';
import 'package:athlorun/features/events/data/models/response/get_events_response_model.dart';
import 'package:athlorun/features/events/data/models/response/ticket_booking_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'event_client.g.dart';

@RestApi()
abstract class EventClient {
  factory EventClient(Dio dio) = _EventClient;

  //GET EVENTS
  @GET(ApiStrings.getEvents)
  Future<GetEventsResponseModel> getEvents();

  //BOOKED EVENTS TICKET
  @POST(ApiStrings.bookedEventTicket)
  Future<TicketBookingResponseModel> bookedEventTicket(
    @Body() TicketBookingRequestModel body,
    @Path("user_id") String userId,
    @Path("eventId") String eventId,
    @Path("slotId") String slotId,
  );
}
