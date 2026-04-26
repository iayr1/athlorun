import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:athlorun/core/global_store/data/models/user_data_response_model.dart';
import 'package:athlorun/core/status/failures.dart';
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

abstract class ProfileRepository {
  //profile
  Future<Either<Failure, UserDataResponseModel>> getUserData(String authId);
  Future<Either<Failure, UserDataResponseModel>> updateUserProfile(
      String authId, UpdateUserProfileRequestModel body);

  //gear
  Future<Either<Failure, GetGearTypesResponseModel>> getGearTypes();
  Future<Either<Failure, GetGearResponseModel>> getGear(String id);
  Future<Either<Failure, DeleteGearResponseModel>> deleteGear(
      String id, String gearId);
  Future<Either<Failure, GetSportsResponseModel>> getSports();
  Future<Either<Failure, CreateGearRequestModel>> createGear(
    String id,
    String typeId,
    String sportId,
    String brand,
    String model,
    String weight,
    File photoFile,
  );
  Future<Either<Failure, CreateGearRequestModel>> updateGear(
    String id,
    String gearId,
    String typeId,
    String sportId,
    String brand,
    String model,
    String weight,
    File photoFile,
  );

  //schedule
  Future<Either<Failure, CreateScheduleRequestModel>> createSchedule(
      String id, CreateScheduleRequestModel body);

  Future<Either<Failure, GetScheduleResponseModel>> getSchedule(String id);
  Future<Either<Failure, DeleteScheduleResponseModel>> deleteSchedule(
      String id, String scheduleId);
  Future<Either<Failure, CreateScheduleRequestModel>> updateSchedule(
      String id, String scheduleId, CreateScheduleRequestModel body);

  Future<Either<Failure, ProfileTargetsResponseModel>> getTargets();
}
