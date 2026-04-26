import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:athlorun/core/global_store/data/models/user_auth_data_model.dart';
import 'package:athlorun/core/global_store/data/models/user_data_response_model.dart';
import 'package:athlorun/core/global_store/domain/usecases/get_user_auth_data_usecase.dart';
import 'package:athlorun/features/profile/data/models/create_gear_request_model.dart';
import 'package:athlorun/features/profile/data/models/get_gear_response_model.dart';
import 'package:athlorun/features/profile/data/models/get_gear_types_response_model.dart';
import 'package:athlorun/features/profile/data/models/get_sports_response_model.dart';
import 'package:athlorun/features/profile/data/models/request/create_schedule_request_model.dart';
import 'package:athlorun/features/profile/data/models/request/update_user_profile_request_model.dart';
import 'package:athlorun/features/profile/data/models/response/get_schedule_response_model.dart';
import 'package:athlorun/features/profile/data/models/response/profile_targets_response_model.dart';
import 'package:athlorun/features/profile/domain/usecases/create_gear_usecase.dart';
import 'package:athlorun/features/profile/domain/usecases/delete_gear_usecase.dart';
import 'package:athlorun/features/profile/domain/usecases/get_gear_all_usecase.dart';
import 'package:athlorun/features/profile/domain/usecases/get_gear_types_usecase.dart';
import 'package:athlorun/features/profile/domain/usecases/get_sports_usecase.dart';
import 'package:athlorun/features/profile/domain/usecases/get_user_data_profile_usecase.dart';
import 'package:athlorun/features/profile/domain/usecases/profile_get_targets_usecase.dart';
import 'package:athlorun/features/profile/domain/usecases/schedule/create_schedule_usecase.dart';
import 'package:athlorun/features/profile/domain/usecases/schedule/delete_schedule_usecase.dart';
import 'package:athlorun/features/profile/domain/usecases/schedule/get_schedule_usecase.dart';
import 'package:athlorun/features/profile/domain/usecases/schedule/update_schedule_usecase.dart';
import 'package:athlorun/features/profile/domain/usecases/update_gear_usecase.dart';
import 'package:athlorun/features/profile/domain/usecases/update_user_profile_usecase.dart';

part 'profile_state.dart';
part 'profile_cubit.freezed.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetGearTypesUsecase _getGearTypesUsecase;
  final GetSportsUsecase _getSportsUsecase;
  final GetGearAllUsecase _getGearAllUsecase;
  final CreateGearUsecase _createGearUsecase;
  final GetUserAuthDataUsecase _getUserAuthDataUsecase;
  final DeleteGearUsecase _deleteGearUsecase;
  final CreateScheduleUsecase _createScheduleUsecase;
  final GetScheduleUsecase _getScheduleUsecase;
  final DeleteScheduleUsecase _deleteScheduleUsecase;
  final UpdateScheduleUsecase _updateScheduleUsecase;
  final UpdateGearUsecase _updateGearUsecase;
  final GetUserDataProfileUsecase _getUserDataProfileUsecase;
  final ProfileGetTargetsUsecase _getTargetsUsecase;
  final UpdateUserProfileUsecase _updateUserProfileUsecase;

  DateTime? _selectedDate;
  File? _selectedImage;
  List<GetScheduleResponseModelData> _filteredSchedules = [];
  List<GetScheduleResponseModelData> _scheduleList = [];

  File? get selectedImage => _selectedImage;
  DateTime? get selectedDate => _selectedDate;
  List<GetScheduleResponseModelData> get filteredSchedules =>
      _filteredSchedules;
  List<GetScheduleResponseModelData> get scheduleList => _scheduleList;

  ProfileCubit(
      this._getGearTypesUsecase,
      this._getSportsUsecase,
      this._getGearAllUsecase,
      this._createGearUsecase,
      this._getUserAuthDataUsecase,
      this._deleteGearUsecase,
      this._createScheduleUsecase,
      this._getScheduleUsecase,
      this._deleteScheduleUsecase,
      this._updateScheduleUsecase,
      this._updateGearUsecase,
      this._getUserDataProfileUsecase,
      this._getTargetsUsecase,
      this._updateUserProfileUsecase)
      : super(const ProfileState.comitial());

  void selectDate(DateTime date) {
    _selectedDate = date;
    filterSchedulesByDate(date);
  }

  void filterSchedulesByDate(DateTime date) {
    if (_scheduleList.isEmpty) return;

    final formattedDate = DateFormat('yyyy-MM-dd').format(date);

    _filteredSchedules = _scheduleList.where((schedule) {
      final scheduleDate = DateTime.parse(schedule.scheduleAt!);
      return DateFormat('yyyy-MM-dd').format(scheduleDate) == formattedDate;
    }).toList();

    emit(ProfileState.loadedSchedule(filteredSchedules,
        selectedDate: _selectedDate));
  }

  Future<void> getAuthData() async {
    emit(const ProfileState.gettingAuthData());
    final response = await _getUserAuthDataUsecase();
    response.fold((failure) {
      emit(ProfileState.getAuthDataError(failure.message));
    }, (authData) {
      emit(ProfileState.gotAuthData(authData));
    });
  }

  Future<void> getUserProfileData() async {
    emit(const ProfileState.gettingUserProfile());
    final authData = await _getUserAuthDataUsecase();

    authData.fold((l) {
      emit(ProfileState.getUserProfileError(l.errorMessage));
    }, (authData) async {
      final response = await _getUserDataProfileUsecase.call(authData.id);
      response.fold((l) {
        emit(ProfileState.getUserProfileError(l.message));
      }, (r) {
        emit(ProfileState.gotUserProfile(r));
      });
    });
  }

  Future<void> updateUserProfileData(UpdateUserProfileRequestModel body) async {
    emit(const ProfileState.updatingUserProfile());
    final authData = await _getUserAuthDataUsecase();

    authData.fold((l) {
      emit(ProfileState.updateUserProfileError(l.errorMessage));
    }, (authData) async {
      final response = await _updateUserProfileUsecase.call(authData.id, body);
      response.fold((l) {
        emit(ProfileState.updateUserProfileError(l.message));
      }, (r) {
        emit(ProfileState.updatedUserProfile(r));
      });
    });
  }

  Future<void> getGearTypes() async {
    emit(const ProfileState.loadingGearTypes());
    final response = await _getGearTypesUsecase();
    response.fold((l) {
      emit(ProfileState.loadGearTypesError(l.message));
    }, (r) {
      emit(ProfileState.loadedGearTypes(r));
    });
  }

  Future<void> getSports() async {
    emit(const ProfileState.loadingSports());
    final response = await _getSportsUsecase();
    response.fold((l) {
      emit(ProfileState.loadSportsError(l.message));
    }, (r) {
      emit(ProfileState.loadedSports(r));
    });
  }

  Future<void> createGear(String id, String typeId, String sportId,
      String brand, String model, String weight, File photoFile) async {
    emit(const ProfileState.creatingGear());
    final response = await _createGearUsecase.call(
        id, typeId, sportId, brand, model, weight, photoFile);
    response.fold((l) {
      emit(ProfileState.createGearError(l.message));
    }, (r) {
      emit(ProfileState.createdGear(r));
    });
  }

  Future<void> updateGear(
    String id,
    String gearId,
    String typeId,
    String sportId,
    String brand,
    String model,
    String weight,
    File photoFile,
  ) async {
    emit(const ProfileState.updatingGear());
    final authData = await _getUserAuthDataUsecase();
    authData.fold((l) {
      emit(ProfileState.updateGearError(l.errorMessage));
    }, (authData) async {
      final response = await _updateGearUsecase.call(
        authData.id,
        gearId,
        typeId,
        sportId,
        brand,
        model,
        weight,
        photoFile,
      );
      response.fold((l) {
        emit(ProfileState.updateGearError(l.message));
      }, (r) {
        emit(ProfileState.updatedGear(r));
      });
    });
  }

  Future<void> createSchedule(CreateScheduleRequestModel body) async {
    emit(const ProfileState.creatingSchedule());
    final authData = await _getUserAuthDataUsecase();
    authData.fold((l) {
      emit(ProfileState.createScheduleError(l.message));
    }, (authData) async {
      final response = await _createScheduleUsecase.call(authData.id, body);
      response.fold((l) {
        emit(ProfileState.createScheduleError(l.message));
      }, (r) {
        emit(ProfileState.createdSchedule(r));
      });
    });
  }

  Future<void> getSchedule() async {
    emit(const ProfileState.loadingSchedule());

    final authData = await _getUserAuthDataUsecase();

    authData.fold((l) {
      emit(ProfileState.loadScheduleError(l.errorMessage));
    }, (authData) async {
      final response = await _getScheduleUsecase.call(authData.id);
      response.fold((l) {
        emit(ProfileState.loadScheduleError(l.message));
      }, (r) {
        _scheduleList = r.data ?? [];
        _filteredSchedules = List.from(_scheduleList);
        emit(ProfileState.loadedSchedule(_filteredSchedules));
      });
    });
  }

  Future<void> deleteSchedule(String scheduleId) async {
    emit(const ProfileState.deletingSchedule());
    final authData = await _getUserAuthDataUsecase();

    authData.fold((l) {
      emit(ProfileState.deleteScheduleError(l.errorMessage));
    }, (authData) async {
      final response =
          await _deleteScheduleUsecase.call(authData.id, scheduleId);
      response.fold((l) {
        emit(ProfileState.deleteScheduleError(l.message));
      }, (r) {
        emit(const ProfileState.deleteSchedule());
      });
    });
  }

  Future<void> updateSchedule(
      String scheduleId, CreateScheduleRequestModel body) async {
    emit(const ProfileState.updatingSchedule());
    final authData = await _getUserAuthDataUsecase();
    authData.fold((l) {
      emit(ProfileState.updateScheduleError(l.errorMessage));
    }, (authData) async {
      final response =
          await _updateScheduleUsecase.call(authData.id, scheduleId, body);
      response.fold((l) {
        emit(ProfileState.updateScheduleError(l.message));
      }, (r) {
        emit(ProfileState.updatedSchedule(r));
      });
    });
  }

  // Function to pick an Gearimage
  Future<void> pickPanImage(ImageSource source) async {
    try {
      final _picker = ImagePicker();
      emit(const ProfileState.pickingImage());

      final XFile? pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        final path = pickedFile.path.split("File: ").last;
        _selectedImage = File(path);
        emit(ProfileState.pickedImage(_selectedImage));
      } else {
        emit(const ProfileState.pickedImageError('No image selected.'));
      }
    } catch (e) {
      emit(ProfileState.pickedImageError('Failed to pick image: $e'));
    }
  }

  Future<void> getAllGear(String id) async {
    emit(const ProfileState.loadingGear());
    final response = await _getGearAllUsecase.call(id);
    response.fold((l) {
      emit(ProfileState.loadGearError(l.message));
    }, (r) {
      emit(ProfileState.loadedGear(r));
    });
  }

  Future<void> deleteGear(String id, String gearId) async {
    emit(const ProfileState.deletingGear());
    final response = await _deleteGearUsecase.call(id, gearId);
    response.fold((l) {
      emit(ProfileState.deleteGearError(l.message));
    }, (r) {
      emit(const ProfileState.deleteGear());
    });
  }

  Future<void> getTargets() async {
    emit(const ProfileState.loadingTargets());
    final response = await _getTargetsUsecase();
    response.fold((failure) {
      emit(ProfileState.loadTargetsError(failure.message));
    }, (targets) {
      emit(ProfileState.loadedTargets(targets));
    });
  }

  Function? _startLoading;
  Function? _stopLoading;

  Future<void> assignLoadingFunction(
      Function startLoading, Function stopLoading) async {
    _startLoading = startLoading;
    _stopLoading = stopLoading;
    return await null;
  }

  Future<void> startLoading() async {
    await _startLoading!();
  }

  Future<void> stopLoading() async {
    await _stopLoading!();
  }
}
