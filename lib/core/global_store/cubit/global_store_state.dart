part of 'global_store_cubit.dart';

@freezed
class GlobalStoreState with _$GlobalStoreState {
  const factory GlobalStoreState.comitial() = _Initial;

  //payment gateway state
  const factory GlobalStoreState.paymentProcessing() = _PaymentProcessing;
  const factory GlobalStoreState.paymentSuccess() = _PaymentSuccess;
  const factory GlobalStoreState.paymentFailure() = _PaymentFailure;
}
