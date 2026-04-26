import 'package:dartz/dartz.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/features/home/data/models/request/step_request_model.dart';
import 'package:athlorun/features/home/data/models/response/step_response_model.dart';
import 'package:athlorun/features/home/data/models/response/wallet_response_model.dart';

abstract class HomeRepository {
  Future<Either<Failure, dynamic>> getNotifications(String type, String status);

  Future<Either<Failure, dynamic>> markNotificationsAsSeen(String id);

  Future<Either<Failure, StepResponseModel>> updateStepsData(
      String id, StepRequestModel body);

  Future<Either<Failure, WalletResponseModel>> getUserWallet(
      String userId, String walletId);
}
