import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:athlorun/core/exceptions/custom_exceptions.dart';
import 'package:athlorun/core/global_store/data/models/user_auth_data_model.dart';
import 'package:athlorun/core/global_store/data/models/user_data_response_model.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/core/utils/utils.dart';
import 'package:athlorun/features/profile/data/datasources/remote/profile_client.dart';
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
import 'package:athlorun/features/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileClient _client;
  const ProfileRepositoryImpl(this._client);

  @override
  Future<Either<Failure, GetGearTypesResponseModel>> getGearTypes() async {
    try {
      final response = await _client.getGearTypes();
      return right(response);
    } catch (e) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, GetSportsResponseModel>> getSports() async {
    try {
      final response = await _client.getSports();
      return right(response);
    } catch (e) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, CreateGearRequestModel>> createGear(
    String id,
    String typeId,
    String sportId,
    String brand,
    String model,
    String weight,
    File photoFile,
  ) async {
    try {
      final response = await _client.createGear(
        id,
        typeId,
        sportId,
        brand,
        model,
        weight,
        photoFile,
      );
      return right(response);
    } catch (e) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, GetGearResponseModel>> getGear(String id) async {
    try {
      final response = await _client.getGear(id);
      return right(response);
    } catch (e) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, DeleteGearResponseModel>> deleteGear(
      String id, String gearId) async {
    try {
      final response = await _client.deleteGear(id, gearId);
      return right(response);
    } catch (e) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, CreateScheduleRequestModel>> createSchedule(
      String id, CreateScheduleRequestModel body) async {
    try {
      final response = await _client.createSchedule(id, body);
      return right(response);
    } on SocketException catch (_) {
      return left(ConnectionFailure());
    } on TimeoutException catch (_) {
      return left(TimeoutFailure());
    } on ServerException catch (_) {
      return left(ServerFailure());
    } catch (e) {
      Utils.debugLog(e.toString());
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<Failure, GetScheduleResponseModel>> getSchedule(
      String id) async {
    try {
      final response = await _client.getSchedule(id);
      return right(response);
    } on SocketException catch (_) {
      return left(ConnectionFailure());
    } on TimeoutException catch (_) {
      return left(TimeoutFailure());
    } on ServerException catch (_) {
      return left(ServerFailure());
    } catch (e) {
      Utils.debugLog(e.toString());
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<Failure, DeleteScheduleResponseModel>> deleteSchedule(
      String id, String scheduleId) async {
    try {
      final response = await _client.deleteSchedule(id, scheduleId);
      return right(response);
    } on SocketException catch (_) {
      return left(ConnectionFailure());
    } on TimeoutException catch (_) {
      return left(TimeoutFailure());
    } on ServerException catch (_) {
      return left(ServerFailure());
    } catch (e) {
      Utils.debugLog(e.toString());
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<Failure, CreateScheduleRequestModel>> updateSchedule(
      String id, String scheduleId, CreateScheduleRequestModel body) async {
    try {
      final response = await _client.updateSchedule(id, scheduleId, body);
      return right(response);
    } on SocketException catch (_) {
      return left(ConnectionFailure());
    } on TimeoutException catch (_) {
      return left(TimeoutFailure());
    } on ServerException catch (_) {
      return left(ServerFailure());
    } catch (e) {
      Utils.debugLog(e.toString());
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<Failure, CreateGearRequestModel>> updateGear(
      String id,
      String gearId,
      String typeId,
      String sportId,
      String brand,
      String model,
      String weight,
      File photoFile) async {
    try {
      final response = await _client.updateGear(
        id,
        gearId,
        typeId,
        sportId,
        brand,
        model,
        weight,
        photoFile,
      );
      return right(response);
    } on SocketException catch (_) {
      return left(ConnectionFailure());
    } on TimeoutException catch (_) {
      return left(TimeoutFailure());
    } on ServerException catch (_) {
      return left(ServerFailure());
    } catch (e) {
      Utils.debugLog(e.toString());
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<Failure, UserDataResponseModel>> getUserData(
      String authId) async {
    try {
      final result = await _client.getUserData(
        authId,
      );
      return right(result);
    } on SocketException catch (_) {
      return left(ConnectionFailure());
    } on TimeoutException catch (_) {
      return left(TimeoutFailure());
    } on ServerException catch (_) {
      return left(ServerFailure());
    } catch (e) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, ProfileTargetsResponseModel>> getTargets() async {
    try {
      final response = await _client.getTargets();
      return right(response);
    } catch (_) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, UserDataResponseModel>> updateUserProfile(
      String authId, UpdateUserProfileRequestModel body) async {
    try {
      final result = await _client.updateUserProfile(authId, body);
      return right(result);
    } on SocketException catch (_) {
      return left(ConnectionFailure());
    } on TimeoutException catch (_) {
      return left(TimeoutFailure());
    } on ServerException catch (_) {
      return left(ServerFailure());
    } catch (e) {
      return left(ServerFailure());
    }
  }
}
