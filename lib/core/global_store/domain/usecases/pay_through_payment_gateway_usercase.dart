import 'package:dartz/dartz.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:athlorun/core/global_store/domain/repository/global_store_repository.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/core/status/success.dart';
import 'package:athlorun/core/utils/utils.dart';

class PayThroughPaymentGatewayUsercase {
  final GlobalStoreRepository _globalStoreRepository;
  PayThroughPaymentGatewayUsercase(this._globalStoreRepository);

  Future<Either<Failure, Success>> call(
    String orderId,
    double orderAmount,
    String paymentSessionid,
    CFPaymentGatewayService cashfree,
  ) async {
    try {
      return await _globalStoreRepository.payThroughPaymentGateWay(
        orderId,
        orderAmount,
        paymentSessionid,
        cashfree,
      );
    } catch (e, stackTrace) {
      Utils.debugLog("Error: $stackTrace");
      return Left(
        ServerFailure(
          message: e.toString(),
        ),
      );
    }
  }
}
