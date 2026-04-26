part of 'events_page_cubit.dart';

@freezed
class EventsPageState with _$EventsPageState {
  const factory EventsPageState.comitial() = _Initial;

  //Auth State
  const factory EventsPageState.gettingAuthData() = _GettingAuthData;
  const factory EventsPageState.gotAuthData(UserAuthDataModel authData) =
      _GotAuthData;
  const factory EventsPageState.getAuthDataError(String error) =
      _GetAuthDataError;

  //Get Events State
  const factory EventsPageState.loadingEvents() = _LoadingEvents;
  const factory EventsPageState.loadedEvents(GetEventsResponseModel events) =
      _LoadedEvents;
  const factory EventsPageState.loadEventsError(String error) =
      _LoadEventsError;

  //Generate Form State
  const factory EventsPageState.generateForms(
      List<TicketHolder> ticketHolders) = _GenerateForms;

  //Update Ticker Holder State
  const factory EventsPageState.updateTicketHolder() = _UpdateTicketHolder;

  //Ticket Form Holder State
  const factory EventsPageState.formValidationUpdated(bool isFormFilled) =
      _FormValidationUpdated;

  //Booked Event Ticket State
  const factory EventsPageState.bookingEventTicket() = _BookingEventTicket;
  const factory EventsPageState.bookedEventTicket(
      TicketBookingResponseModel response) = _BookedEventTicket;
  const factory EventsPageState.bookingEventTicketError(String error) =
      _BookingEventTicketError;

  const factory EventsPageState.isAppliedCoupon(bool isApplied, double amount) =
      _IsAppliedCoupon;

  const factory EventsPageState.addSlot(Slot? selectSlot) = _AddSlot;
  const factory EventsPageState.updatedTicketQuantity(
    int quantity,
    double totalAmount,
    bool ticketLimitReached,
  ) = _UpdatedTicketQuantity;
  const factory EventsPageState.ticketLimitReached(quantity) =
      TicketLimitReached;
}
