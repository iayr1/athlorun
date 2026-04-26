import 'package:dio/dio.dart';
import 'package:athlorun/core/constants/api_strings.dart';
import 'package:athlorun/core/global_store/data/models/user_data_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'global_store_client.g.dart';

@RestApi()
abstract class GlobalStoreClient {
  factory GlobalStoreClient(Dio dio) = _GlobalStoreClient;

  @GET(ApiStrings.users)
  Future<UserDataResponseModel> getUserData(
    @Path("id") String id,
  );
}
