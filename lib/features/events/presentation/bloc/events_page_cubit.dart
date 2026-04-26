import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:athlorun/config/routes/routes.dart';
import 'package:athlorun/core/global_store/data/models/user_auth_data_model.dart';
import 'package:athlorun/core/global_store/domain/usecases/get_user_auth_data_usecase.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import 'package:athlorun/core/utils/utils.dart';
import 'package:athlorun/features/events/data/models/request/ticket_booking_request_model.dart';
import 'package:athlorun/features/events/data/models/response/ticket_booking_response_model.dart';
import 'package:athlorun/features/events/domain/usecases/booked_event_ticket_usecase.dart';
import 'package:athlorun/features/events/domain/usecases/get_events_usecase.dart';
import 'package:athlorun/features/events/data/models/response/get_events_response_model.dart';

part 'events_page_state.dart';
part 'events_page_cubit.freezed.dart';

class EventsPageCubit extends Cubit<EventsPageState> {
  final GetEventsUsecase _eventsUsecase;
  final GetUserAuthDataUsecase _getUserAuthDataUsecase;
  final BookedEventTicketUsecase _bookedEventTicketUsecase;

  EventsPageCubit(this._eventsUsecase, this._getUserAuthDataUsecase,
      this._bookedEventTicketUsecase)
      : super(const EventsPageState.comitial());

  List<TicketHolder> ticketHolders = [];
  List<TextEditingController> nameControllers = [];
  List<TextEditingController> ageControllers = [];
  bool isFormFilled = false;
  bool _isApplied = false;
  double _discountValue = 0.0;
  String _discountType = "";
  Coupon? enterdCouponCode;

  List<TicketHolder> get getTicketHolders => ticketHolders;
  List<TextEditingController> get getNameControllers => nameControllers;
  List<TextEditingController> get getAgeControllers => ageControllers;
  bool get getisFormFilled => isFormFilled;
  bool get isApplied => _isApplied;
  double get discountValue => _discountValue;
  String get discountType => _discountType;

  void generateForms(int count) {
    ticketHolders = List.generate(
        count, (index) => TicketHolder(name: '', age: 0, gender: 'Male'));
    nameControllers = List.generate(count, (_) => TextEditingController());
    ageControllers = List.generate(count, (_) => TextEditingController());

    emit(EventsPageState.generateForms(ticketHolders));
  }

  void updateTicketHolder(int index) {
    ticketHolders[index] = TicketHolder(
      name: nameControllers[index].text,
      age: int.tryParse(ageControllers[index].text) ?? 0,
      gender: ticketHolders[index].gender,
    );
    checkFormFilled();
    emit(const EventsPageState.updateTicketHolder());
  }

  void checkFormFilled() {
    isFormFilled = ticketHolders.every(
      (holder) =>
          holder.name!.isNotEmpty &&
          holder.age! > 0 &&
          holder.gender!.isNotEmpty,
    );

    emit(EventsPageState.formValidationUpdated(isFormFilled));
  }

  // void submitForm(
  //   BuildContext context,
  //   GetEventsResponseModelData getEventsResponseModelData,
  //   Slot? slot,
  //   double amount,
  //   int? ticketQuantity,
  // ) {
  //   for (var holder in ticketHolders) {
  //     if (holder.name!.isEmpty || holder.age! <= 0 || holder.gender!.isEmpty) {
  //       Utils.showCustomDialog(
  //           context, AppStrings.error, 'Please fill all fields.');
  //       return;
  //     }
  //   }

  //   Utils.debugLog(
  //       '✅ Submitted: ${ticketHolders.map((e) => '${e.name}, ${e.age}, ${e.gender}').toList()}');
  //   _finalAmount = totalAmount;
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //       builder: (_) => BlocProvider.value(
  //         value: context.read<EventsPageCubit>(),
  //         child: ReviewBookingPageWrapper(
  //           getEventsResponseModelData: getEventsResponseModelData,
  //           totalAmount: amount,
  //           finalAmount: finalAmount,
  //           ticketHolder: ticketHolders,
  //           slot: slot,
  //         ),
  //       ),
  //     ),
  //   );
  // }
  void submitForm(
    BuildContext context,
    GetEventsResponseModelData getEventsResponseModelData,
    Slot? slot,
    double amount,
    int? ticketQuantity,
  ) {
    //Sync text controllers into ticketHolders before checking
    for (int i = 0; i < nameControllers.length; i++) {
      updateTicketHolder(i);
    }

    for (var holder in ticketHolders) {
      if (holder.name!.isEmpty || holder.age! <= 0 || holder.gender!.isEmpty) {
        Utils.showCustomDialog(
            context, AppStrings.error, 'Please fill all fields.');
        return;
      }
    }

    Utils.debugLog(
        '✅ Submitted: ${ticketHolders.map((e) => '${e.name}, ${e.age}, ${e.gender}').toList()}');

    final copiedHolders = List<TicketHolder>.from(ticketHolders);

    Navigator.pushReplacementNamed(
      context,
      AppRoutes.reviewBookingPage,
      arguments: {
        "slot": slot,
        "ticketQuantity": ticketQuantity,
        "totalAmount": amount,
        "ticketHolderList": copiedHolders,
        "getEventsResponseModelData": getEventsResponseModelData
      },
    );
  }

  void setApplied(bool applied, double originalAmount) {
    _isApplied = applied;
    emit(EventsPageState.isAppliedCoupon(applied, originalAmount));
  }

  void clearCoupon(double originalAmount) {
    _isApplied = false;
    _discountValue = 0.0;
    _discountType = '';
    enterdCouponCode = null;

    emit(EventsPageState.isAppliedCoupon(false, originalAmount));
  }

  // Apply coupon code
  void applyCouponCode(
    BuildContext context,
    GetEventsResponseModelData getEventsResponseModelData,
    TextEditingController couponCodecontroller,
    double totalAmount,
  ) {
    final coupons = getEventsResponseModelData.coupons ?? [];
    final enteredCode = couponCodecontroller.text.trim();

    final matchedCoupon = coupons.firstWhereOrNull(
      (coupon) => coupon.code == enteredCode,
    );

    enterdCouponCode = matchedCoupon;

    if (matchedCoupon == null) {
      Utils.showCustomDialog(context, AppStrings.error, "Invalid coupon code.");
      return;
    }

    final usageLimit = matchedCoupon.usageLimit ?? 0;
    final usageCount = matchedCoupon.usageCount ?? 0;

    if (usageCount >= usageLimit) {
      Utils.showCustomDialog(
          context, AppStrings.error, "This coupon has already been used up.");
      return;
    }

    final minPurchase =
        double.tryParse(matchedCoupon.minimumPurchase ?? '') ?? 0.0;

    if (totalAmount < minPurchase) {
      Utils.showCustomDialog(
        context,
        AppStrings.error,
        "Minimum purchase of ₹${minPurchase.toStringAsFixed(2)} required to apply this coupon.",
      );
      return;
    }

    _discountType = matchedCoupon.discountType!;
    _discountValue = double.tryParse(matchedCoupon.discountValue ?? '0') ?? 0;

    double newAmount = totalAmount;

    if (_discountType == "flat") {
      newAmount = totalAmount - _discountValue;
    } else if (_discountType == "percentage") {
      final discountAmount = totalAmount * (_discountValue / 100);
      newAmount = totalAmount - discountAmount;
    }

    _isApplied = true;

    setApplied(_isApplied, newAmount);
  }

  //gettingAuthData
  Future<void> getAuthData() async {
    emit(const EventsPageState.gettingAuthData());
    final response = await _getUserAuthDataUsecase();
    response.fold((failure) {
      emit(EventsPageState.getAuthDataError(failure.message));
    }, (authData) {
      emit(EventsPageState.gotAuthData(authData));
    });
  }

  //get events
  Future<void> getEvents() async {
    emit(const EventsPageState.loadingEvents());
    final response = await _eventsUsecase.call();
    response.fold((l) {
      emit(EventsPageState.loadEventsError(l.errorMessage));
    }, (r) {
      emit(EventsPageState.loadedEvents(r));
    });
  }

  Future<void> bookedEventTickets(
      TicketBookingRequestModel body, String eventId, String slotId) async {
    emit(const EventsPageState.bookingEventTicket());
    final authData = await _getUserAuthDataUsecase();
    authData.fold((l) {
      emit(EventsPageState.bookingEventTicketError(l.errorMessage));
    }, (authData) async {
      final response = await _bookedEventTicketUsecase.call(
        body,
        authData.id,
        eventId,
        slotId,
      );
      response.fold((l) {
        emit(EventsPageState.bookingEventTicketError(l.errorMessage));
      }, (r) {
        emit(EventsPageState.bookedEventTicket(r));
      });
    });
  }

  Function? _startLoading;
  Function? _stopLoading;

  Future<void> assignLoadingFunction(
      Function startLoading, Function stopLoading) async {
    _startLoading = startLoading;
    _stopLoading = stopLoading;
    return await null;
  }

  Future<void> startLoading() async {
    await _startLoading!();
  }

  Future<void> stopLoading() async {
    await _stopLoading!();
  }
}
