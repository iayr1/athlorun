import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:athlorun/core/global_store/domain/usecases/get_user_auth_data_usecase.dart';
import 'package:athlorun/core/global_store/domain/usecases/pay_through_payment_gateway_usercase.dart';
import 'package:athlorun/core/utils/utils.dart';

part 'global_store_state.dart';
part 'global_store_cubit.freezed.dart';

class GlobalStoreCubit extends Cubit<GlobalStoreState> {
  final PayThroughPaymentGatewayUsercase _payThroughPaymentGatewayUsercase;
  final GetUserAuthDataUsecase _getUserAuthDataUsecase;
  GlobalStoreCubit(
    this._payThroughPaymentGatewayUsercase,
    this._getUserAuthDataUsecase,
  ) : super(const GlobalStoreState.comitial());

  //Cashfree payment gateway

  Future<void> payThroughPaymentGateway(
    BuildContext context,
    String orderId,
    double orderAmount,
    String paymentSessionid,
  ) async {
    emit(const GlobalStoreState.paymentProcessing());
    CFPaymentGatewayService cashfree = CFPaymentGatewayService();

    Utils.debugLog("Payment processing of Events");

    cashfree.setCallback(
      (orderId) async {
        Utils.debugLog("orderId");
        Utils.debugLog(orderId);

        Utils.showCustomDialog(
          context,
          "Payment Success",
          "Success",
        );
      },
      (res, err) {
        Utils.debugLog(res.toString());
        Utils.showCustomDialog(
          context,
          " Payment Failed!",
          "Failed",
        );
      },
    );

    if (orderId.isNotEmpty && paymentSessionid.isNotEmpty) {
      final result = await _payThroughPaymentGatewayUsercase.call(
        orderId,
        orderAmount,
        paymentSessionid,
        cashfree,
      );
      result.fold(
        (l) {
          Utils.debugLog("eror from cleardues result page");
          Utils.showCustomDialog(
            context,
            "Payment Failed!",
            "Failed",
          );
        },
        (r) async {},
      );
    }
  }
}
