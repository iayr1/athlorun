import 'package:dartz/dartz.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/core/utils/utils.dart';
import 'package:athlorun/features/home/data/datasources/remote/home_remote_client.dart';
import 'package:athlorun/features/home/data/models/request/step_request_model.dart';
import 'package:athlorun/features/home/data/models/response/step_response_model.dart';
import 'package:athlorun/features/home/data/models/response/wallet_response_model.dart';
import 'package:athlorun/features/home/domain/repository/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteClient _remoteClient;
  const HomeRepositoryImpl(this._remoteClient);
  @override
  Future<Either<Failure, dynamic>> getNotifications(
      String type, String status) async {
    try {
      final response = await _remoteClient.getNotifications(type, status);
      return right(response);
    } catch (e) {
      Utils.debugLog(e.toString());
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, dynamic>> markNotificationsAsSeen(String id) async {
    try {
      final response = await _remoteClient.markNotificationsAsSeen(id);
      return right(response);
    } catch (e) {
      Utils.debugLog(e.toString());
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, StepResponseModel>> updateStepsData(
      String id, StepRequestModel body) async {
    try {
      final response = await _remoteClient.updateStepCount(id, body);
      return right(response);
    } catch (e) {
      Utils.debugLog(e.toString());
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, WalletResponseModel>> getUserWallet(
      String userId, String walletId) async {
    try {
      final response = await _remoteClient.getWallet(userId, walletId);
      return right(response);
    } catch (e) {
      return left(ServerFailure());
    }
  }
}
