import 'dart:io';

import 'package:athlorun/core/firebase/data/datasources/remote/firestore_backend.dart';
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

class ProfileClient {
  ProfileClient(this._backend);

  final FirestoreBackend _backend;

  Future<ProfileTargetsResponseModel> getTargets() async {
    final targets = await _backend.getCollection(collection: 'targets');
    return ProfileTargetsResponseModel.fromJson({'statusCode': 200, 'message': 'Fetched', 'data': targets});
  }

  Future<GetSportsResponseModel> getSports() async {
    final sports = await _backend.getCollection(collection: 'sports');
    return GetSportsResponseModel.fromJson({'statusCode': 200, 'message': 'Fetched', 'data': sports});
  }

  Future<GetGearTypesResponseModel> getGearTypes() async {
    final gearTypes = await _backend.getCollection(collection: 'gear_types');
    return GetGearTypesResponseModel.fromJson({'statusCode': 200, 'message': 'Fetched', 'data': gearTypes});
  }

  Future<CreateGearRequestModel> createGear(String id, String typeId, String sportId, String brand, String model, String weight, File photoFile) async {
    final data = {
      'typeId': typeId,
      'sportId': sportId,
      'brand': brand,
      'model': model,
      'weight': weight,
      'photoPath': photoFile.path,
      'userId': id,
    };
    await _backend.upsertDocument(collection: 'gear', docId: '${id}_${DateTime.now().millisecondsSinceEpoch}', data: data);
    return CreateGearRequestModel.fromJson(data);
  }

  Future<GetGearResponseModel> getGear(String id) async {
    final gear = await _backend.getCollection(collection: 'gear', field: 'userId', isEqualTo: id);
    return GetGearResponseModel.fromJson({'statusCode': 200, 'message': 'Fetched', 'data': gear});
  }

  Future<DeleteGearResponseModel> deleteGear(String id, String gearid) async {
    await _backend.deleteDocument(collection: 'gear', docId: gearid);
    return DeleteGearResponseModel.fromJson({'statusCode': 200, 'message': 'Deleted'});
  }

  Future<CreateGearRequestModel> updateGear(String id, String gearid, String typeId, String sportId, String brand, String model, String weight, File photoFile) async {
    final data = {
      'typeId': typeId,
      'sportId': sportId,
      'brand': brand,
      'model': model,
      'weight': weight,
      'photoPath': photoFile.path,
      'userId': id,
    };
    await _backend.upsertDocument(collection: 'gear', docId: gearid, data: data);
    return CreateGearRequestModel.fromJson(data);
  }

  Future<CreateScheduleRequestModel> createSchedule(String id, CreateScheduleRequestModel body) async {
    final data = body.toJson()..['userId'] = id;
    await _backend.upsertDocument(collection: 'schedules', docId: '${id}_${DateTime.now().millisecondsSinceEpoch}', data: data);
    return CreateScheduleRequestModel.fromJson(data);
  }

  Future<GetScheduleResponseModel> getSchedule(String id) async {
    final schedules = await _backend.getCollection(collection: 'schedules', field: 'userId', isEqualTo: id);
    return GetScheduleResponseModel.fromJson({'statusCode': 200, 'message': 'Fetched', 'data': schedules});
  }

  Future<DeleteScheduleResponseModel> deleteSchedule(String id, String scheduleid) async {
    await _backend.deleteDocument(collection: 'schedules', docId: scheduleid);
    return DeleteScheduleResponseModel.fromJson({'statusCode': 200, 'message': 'Deleted'});
  }

  Future<CreateScheduleRequestModel> updateSchedule(String id, String scheduleid, CreateScheduleRequestModel body) async {
    final data = body.toJson()..['userId'] = id;
    await _backend.upsertDocument(collection: 'schedules', docId: scheduleid, data: data);
    return CreateScheduleRequestModel.fromJson(data);
  }

  Future<UserDataResponseModel> getUserData(String id) async {
    final user = await _backend.getDocument(collection: 'users', docId: id, fallback: {'statusCode': 200, 'data': {}});
    return UserDataResponseModel.fromJson(user);
  }

  Future<UserDataResponseModel> updateUserProfile(String id, UpdateUserProfileRequestModel body) async {
    final data = body.toJson();
    await _backend.upsertDocument(collection: 'users', docId: id, data: data);
    return UserDataResponseModel.fromJson({'statusCode': 200, 'message': 'Updated', 'data': data});
  }
}
