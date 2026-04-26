import 'dart:io';

import 'package:dio/dio.dart';
import 'package:athlorun/core/constants/api_strings.dart';
import 'package:athlorun/core/global_store/data/models/user_data_response_model.dart';
import 'package:athlorun/features/profile/data/models/create_gear_request_model.dart';
import 'package:athlorun/features/profile/data/models/delete_gear_response_model.dart';
import 'package:athlorun/features/profile/data/models/get_gear_response_model.dart';
import 'package:athlorun/features/profile/data/models/get_gear_types_response_model.dart';
import 'package:athlorun/features/profile/data/models/get_sports_response_model.dart';
import 'package:athlorun/features/profile/data/models/request/create_schedule_request_model.dart';
import 'package:athlorun/features/profile/data/models/request/update_user_profile_request_model.dart';
import 'package:athlorun/features/profile/data/models/response/delete_schedule_response_model.dart';
import 'package:athlorun/features/profile/data/models/response/get_schedule_response_model.dart';
import 'package:athlorun/features/profile/data/models/response/profile_targets_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'profile_client.g.dart';

@RestApi()
abstract class ProfileClient {
  factory ProfileClient(Dio dio) = _ProfileClient;

  @GET(ApiStrings.targets)
  Future<ProfileTargetsResponseModel> getTargets();

  //Gear client
  @GET(ApiStrings.getSports)
  Future<GetSportsResponseModel> getSports();

  @GET(ApiStrings.getGearTypes)
  Future<GetGearTypesResponseModel> getGearTypes();

  @POST(ApiStrings.gear)
  @MultiPart()
  Future<CreateGearRequestModel> createGear(
    @Path("id") String id,
    @Part(name: "typeId") String typeId,
    @Part(name: "sportId") String sportId,
    @Part(name: "brand") String brand,
    @Part(name: "model") String model,
    @Part(name: "weight") String weight,
    @Part(name: "photoFile") File photoFile,
  );

  @GET(ApiStrings.gear)
  Future<GetGearResponseModel> getGear(
    @Path("id") String id,
  );

  @DELETE(ApiStrings.deleteGear)
  Future<DeleteGearResponseModel> deleteGear(
    @Path("id") String id,
    @Path("gearId") String gearid,
  );

  @PATCH(ApiStrings.updateGear)
  @MultiPart()
  Future<CreateGearRequestModel> updateGear(
    @Path("id") String id,
    @Path("gearId") String gearid,
    @Part(name: "typeId") String typeId,
    @Part(name: "sportId") String sportId,
    @Part(name: "brand") String brand,
    @Part(name: "model") String model,
    @Part(name: "weight") String weight,
    @Part(name: "photoFile") File photoFile,
  );

  //schedule client
  @POST(ApiStrings.schedule)
  Future<CreateScheduleRequestModel> createSchedule(
    @Path('id') String id,
    @Body() CreateScheduleRequestModel body,
  );

  @GET(ApiStrings.schedule)
  Future<GetScheduleResponseModel> getSchedule(
    @Path("id") String id,
  );

  @DELETE(ApiStrings.deleteschedule)
  Future<DeleteScheduleResponseModel> deleteSchedule(
    @Path("id") String id,
    @Path("scheduleId") String scheduleid,
  );

  @PATCH(ApiStrings.updateschedule)
  Future<CreateScheduleRequestModel> updateSchedule(
      @Path("id") String id,
      @Path("scheduleId") String scheduleid,
      @Body() CreateScheduleRequestModel body);

  @GET(ApiStrings.users)
  Future<UserDataResponseModel> getUserData(
    @Path("id") String id,
  );

  @PATCH(ApiStrings.users)
  Future<UserDataResponseModel> updateUserProfile(
      @Path("id") String id, @Body() UpdateUserProfileRequestModel body);
}
