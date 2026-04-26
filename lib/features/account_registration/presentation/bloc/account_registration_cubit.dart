import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:athlorun/core/global_store/data/models/user_auth_data_model.dart';
import 'package:athlorun/core/global_store/data/models/user_data_progress_model.dart';
import 'package:athlorun/core/global_store/data/models/user_data_response_model.dart';
import 'package:athlorun/core/global_store/domain/usecases/get_user_auth_data_usecase.dart';
import 'package:athlorun/core/global_store/domain/usecases/get_user_data_usecase.dart';
import 'package:athlorun/core/global_store/domain/usecases/set_onboarding_status_usecase.dart';
import 'package:athlorun/core/global_store/domain/usecases/set_user_auth_data_usecase.dart';
import 'package:athlorun/core/global_store/domain/usecases/set_user_data_progress_model_usecase.dart';
import 'package:athlorun/features/account_registration/data/models/send_otp_request_model.dart';
import 'package:athlorun/features/account_registration/data/models/send_otp_response_model.dart';
import 'package:athlorun/features/account_registration/data/models/targets_response_model.dart';
import 'package:athlorun/features/account_registration/data/models/upload_selfie_response_model.dart';
import 'package:athlorun/features/account_registration/data/models/verify_otp_request_model.dart';
import 'package:athlorun/features/account_registration/data/models/verify_otp_response_model.dart';
import 'package:athlorun/features/account_registration/domain/usecases/get_targets_usecase.dart';
import 'package:athlorun/features/account_registration/domain/usecases/patch_user_data_usecase.dart';
import 'package:athlorun/features/account_registration/domain/usecases/send_otp_usecase.dart';
import 'package:athlorun/features/account_registration/domain/usecases/upload_selfie_usecase.dart';
import 'package:athlorun/features/account_registration/domain/usecases/verify_otp_usecase.dart';

part 'account_registration_cubit.freezed.dart';
part 'account_registration_state.dart';

class AccountRegistrationCubit extends Cubit<AccountRegistrationState> {
  final SendOtpUsecase _sendOtpUsecase;
  final VerifyOtpUsecase _verifyOtpUsecase;
  final SetOnboardingStatusUsecase _setOnboardingStatusUsecase;
  final SetUserAuthDataUsecase _setUserAuthDataUsecase;
  final GetUserAuthDataUsecase _getUserAuthDataUsecase;
  final GetUserDataUsecase _getUserDataUsecase;
  final SetUserDataProgressModelUsecase _setUserDataProgressModelUsecase;
  final UploadSelfieUsecase _uploadSelfieUsecase;
  final PatchUserDataUsecase _patchUserDataUsecase;
  final GetTargetsUsecase _getTargetsUsecase;
  AccountRegistrationCubit(
    this._sendOtpUsecase,
    this._verifyOtpUsecase,
    this._setOnboardingStatusUsecase,
    this._setUserAuthDataUsecase,
    this._setUserDataProgressModelUsecase,
    this._uploadSelfieUsecase,
    this._getUserAuthDataUsecase,
    this._patchUserDataUsecase,
    this._getUserDataUsecase,
    this._getTargetsUsecase,
  ) : super(const AccountRegistrationState.comitial());

  Future<void> checkbox(bool valid) async {
    emit(const AccountRegistrationState.checkboxLoading());
    emit(AccountRegistrationState.checkboxLoaded(valid));
  }

  Future<void> validateTextField(String value, {int length = 1}) async {
    emit(const AccountRegistrationState.validatingTextField());
    if (value.isNotEmpty && value.length >= length) {
      emit(const AccountRegistrationState.validatedTextField(true));
    } else {
      emit(const AccountRegistrationState.validatedTextField(false));
    }
  }

  Future<void> selectCountry(BuildContext context) async {
    emit(const AccountRegistrationState.selectingCountry());
    showCountryPicker(
      context: context,
      onSelect: (Country country) {
        emit(AccountRegistrationState.selectedCountry(
          country.name,
          "+${country.phoneCode}",
        ));
      },
    );
  }

  Future<void> setUserDataProgreessModel(
      UserDataProgressModel progressData) async {
    emit(const AccountRegistrationState.settingUserProgressData());
    final response = await _setUserDataProgressModelUsecase(progressData);
    response.fold((failure) {
      emit(AccountRegistrationState.setUserProgressDataError(failure.message));
    }, (data) {
      emit(AccountRegistrationState.setUserProgressData(progressData));
    });
  }

  Future<void> setOnboardingStatus(bool status) async {
    emit(const AccountRegistrationState.settingOnboardingStatus());
    final response = await _setOnboardingStatusUsecase(status);
    response.fold((failure) {
      emit(AccountRegistrationState.setOnboardingStatusError(failure.message));
    }, (data) {
      emit(const AccountRegistrationState.setOnboardingStatus());
    });
  }

  Future<void> setAuthData(
      String id, String accessToken, String refreshToken) async {
    emit(const AccountRegistrationState.settingAuthData());
    final response = await _setUserAuthDataUsecase(UserAuthDataModel(
        id: id, accessToken: accessToken, refreshToken: refreshToken));
    response.fold((failure) {
      emit(AccountRegistrationState.setAuthDataError(failure.message));
    }, (data) {
      emit(AccountRegistrationState.setAuthData(UserAuthDataModel(
          id: id, accessToken: accessToken, refreshToken: refreshToken)));
    });
  }

  Future<void> getAuthData() async {
    emit(const AccountRegistrationState.gettingAuthData());
    final response = await _getUserAuthDataUsecase();
    response.fold((failure) {
      emit(AccountRegistrationState.getAuthDataError(failure.message));
    }, (authData) {
      emit(AccountRegistrationState.gotAuthData(authData));
    });
  }

  Future<void> getUserData(UserAuthDataModel authData) async {
    emit(const AccountRegistrationState.loadingUserData());
    final response = await _getUserDataUsecase.call(authData);
    response.fold((failure) {
      emit(AccountRegistrationState.loadUserDataError(failure.message));
    }, (userData) {
      emit(AccountRegistrationState.loadedUserData(authData, userData));
    });
  }

  Future<void> sendOtp(String number) async {
    emit(const AccountRegistrationState.sendingOtp());
    final response =
        await _sendOtpUsecase(SendOtpRequestModel(phoneNumber: number));
    response.fold((failure) {
      emit(AccountRegistrationState.sendOtpError(failure.message));
    }, (data) {
      emit(AccountRegistrationState.sentOtp(data));
    });
  }

  Future<void> verifyOtp(String number, String otp) async {
    emit(const AccountRegistrationState.verifyingOtp());
    final response = await _verifyOtpUsecase.call(
      VerifyOtpRequestModel(
        phoneNumber: number,
        otp: otp,
      ),
    );
    response.fold((failure) {
      emit(AccountRegistrationState.verifyOtpError(failure.message));
    }, (data) {
      emit(AccountRegistrationState.verifiedOtp(data));
    });
  }

  Future<void> uploadSelfie(String authToken, File file) async {
    emit(const AccountRegistrationState.uploadingSelfie());
    final response = await _uploadSelfieUsecase(
      authToken,
      file,
    );
    response.fold((failure) {
      emit(AccountRegistrationState.uploadSelfieError(failure.message));
    }, (res) {
      emit(AccountRegistrationState.uploadedSelfie(res));
    });
  }

  Future<void> patchUserData(
    String id,
    String token,
    UserDataProgressModel body,
  ) async {
    emit(const AccountRegistrationState.patchingUserData());
    final response = await _patchUserDataUsecase(id, token, body);
    response.fold((failure) {
      emit(AccountRegistrationState.patchUserDataError(failure.message));
    }, (userData) {
      emit(AccountRegistrationState.patchedUserData(userData));
    });
  }

  Future<void> updateState() async {
    emit(const AccountRegistrationState.updatingState());
    emit(const AccountRegistrationState.updatedState());
  }

  Future<void> detectFace(File image) async {
    emit(const AccountRegistrationState.detectingFace());
    try {
      final inputImage = InputImage.fromFile(image);
      final faceDetector = FaceDetector(
        options: FaceDetectorOptions(
          enableContours: true,
          enableClassification: true,
        ),
      );
      final faces = await faceDetector.processImage(inputImage);
      await faceDetector.close();
      emit(AccountRegistrationState.detectedFace(faces.length == 1, image));
    } catch (_) {
      emit(const AccountRegistrationState.patchUserDataError(
          "Something Went Wrong!"));
    }
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

  Future<void> getTargets() async {
    emit(const AccountRegistrationState.loadingTargets());
    final response = await _getTargetsUsecase();
    response.fold((failure) {
      emit(AccountRegistrationState.loadTargetsError(failure.message));
    }, (targets) {
      emit(AccountRegistrationState.loadedTargets(targets));
    });
  }
}
