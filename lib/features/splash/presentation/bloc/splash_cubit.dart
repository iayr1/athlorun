import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:athlorun/core/global_store/data/models/user_auth_data_model.dart';
import 'package:athlorun/core/global_store/data/models/user_data_progress_model.dart';
import 'package:athlorun/core/global_store/data/models/user_data_response_model.dart';
import 'package:athlorun/core/global_store/domain/usecases/get_onboarding_status_usecase.dart';
import 'package:athlorun/core/global_store/domain/usecases/get_user_auth_data_usecase.dart';
import 'package:athlorun/core/global_store/domain/usecases/get_user_data_progress_model_usecase.dart';
import 'package:athlorun/core/global_store/domain/usecases/get_user_data_usecase.dart';

part 'splash_state.dart';
part 'splash_cubit.freezed.dart';

class SplashCubit extends Cubit<SplashState> {
  final GetUserAuthDataUsecase _getAuthDataUsecase;
  final GetOnboardingStatusUsecase _getOnboardingStatusUsecase;
  final GetUserDataUsecase _getUserDataUsecase;
  final GetUserDataProgressModelUsecase _getUserDataProgressModelUsecase;
  SplashCubit(
    this._getAuthDataUsecase,
    this._getOnboardingStatusUsecase,
    this._getUserDataUsecase,
    this._getUserDataProgressModelUsecase,
  ) : super(const SplashState.comitial());

  Future<void> getAuthData() async {
    emit(const SplashState.loadingAuthData());
    final result = await _getAuthDataUsecase();
    result.fold((failure) {
      emit(SplashState.loadAuthDataError(failure.message));
    }, (authData) {
      emit(SplashState.loadedAuthData(authData));
    });
  }

  Future<void> getUserData(
      String id, String accessToken, String refreshToken) async {
    emit(const SplashState.loadingUserData());
    final result = await _getUserDataUsecase.call(UserAuthDataModel(
        id: id, accessToken: accessToken, refreshToken: refreshToken));
    result.fold((failure) {
      emit(SplashState.loadUserDataError(failure.message));
    }, (userData) {
      emit(SplashState.loadedUserData(userData));
    });
  }

  Future<void> getOnboardingStatus() async {
    emit(const SplashState.loadingOnboardingStatus());
    final result = await _getOnboardingStatusUsecase();
    result.fold((failure) {
      emit(SplashState.loadOnboardingStatusError(failure.message));
    }, (_) {
      emit(const SplashState.loadedOnboardingStatus());
    });
  }

  Future<void> getUserDataProgress(UserData userData) async {
    emit(const SplashState.loadingUserProgressData());
    final result = await _getUserDataProgressModelUsecase();
    result.fold((failure) {
      emit(SplashState.loadUserProgressDataError(userData, failure.message));
    }, (progressData) {
      emit(SplashState.loadedUserProgressData(userData, progressData));
    });
  }
}
