import 'package:dio/dio.dart';
import 'package:athlorun/core/constants/api_strings.dart';
import 'package:athlorun/features/home/data/models/request/step_request_model.dart';
import 'package:athlorun/features/home/data/models/response/step_response_model.dart';
import 'package:athlorun/features/home/data/models/response/wallet_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'home_remote_client.g.dart';

@RestApi()
abstract class HomeRemoteClient {
  factory HomeRemoteClient(Dio dio) = _HomeRemoteClient;

  @GET(ApiStrings.notifications)
  Future<dynamic> getNotifications(
    @Query("type") String type,
    @Query("status") String status,
  );

  @PATCH(ApiStrings.markNotificationsAsSeen)
  Future<dynamic> markNotificationsAsSeen(
    @Path("id") String id,
  );

  @PATCH(ApiStrings.postStepData)
  Future<StepResponseModel> updateStepCount(
    @Path("id") String id,
    @Body() StepRequestModel body,
  );

  @GET(ApiStrings.getUserWallet)
  Future<WalletResponseModel> getWallet(
    @Path("user_id") String userId,
    @Path("wallet_id") String walletId,
  );
}
