import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:athlorun/config/di/dependency_injection.dart';
import 'package:athlorun/config/images/app_images.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import 'package:athlorun/core/utils/utils.dart';
import 'package:athlorun/features/home/data/models/request/step_request_model.dart';
import 'package:athlorun/features/home/data/models/response/step_response_model.dart';
import 'package:athlorun/features/home/presentation/bloc/home_page_cubit.dart';
import '../../../../../config/styles/app_colors.dart';
import '../../../../../config/styles/app_textstyles.dart';
import '../../../../../core/utils/windows.dart';

class StepCountWidgetWrapper extends StatelessWidget {
  const StepCountWidgetWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomePageCubit>(),
      child: const StepCountWidget(),
    );
  }
}

class StepCountWidget extends StatefulWidget {
  const StepCountWidget({super.key});

  @override
  _StepCountWidgetState createState() => _StepCountWidgetState();
}

class _StepCountWidgetState extends State<StepCountWidget> {
  final int stepGoal = 10000;
  final double metersPerStep = 0.8;
  Stream<StepCount>? _stepCountStream;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  StepResponseModel? _stepResponseModel;

  late HomePageCubit _cubit;

  int todaySteps = 0;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<HomePageCubit>();
    _loadSteps().then((value) {
      setState(() {
        todaySteps = value;
      });
    });
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    var status = await Permission.activityRecognition.request();
    if (status.isGranted) {
      _initStepTracker();
    } else {
      Utils.debugLog("Permission Denied for Activity Recognition");
    }
  }

  Future<void> _saveSteps(int steps) async {
    await _storage.write(key: 'todaySteps', value: steps.toString());
  }

  Future<int> _loadSteps() async {
    String? steps = await _storage.read(key: 'todaySteps');
    return steps != null ? int.parse(steps) : 0;
  }

  void _initStepTracker() {
    try {
      _stepCountStream = Pedometer.stepCountStream;
      _stepCountStream!.listen(
        (StepCount event) {
          setState(() {
            todaySteps = event.steps;
          });
          _cubit.updateStepData(
            StepRequestModel(
              count: event.steps,
              source: "pedometer",
              date: Utils.formatToYYYYMMDD(DateTime.now()),
            ),
          );
          _saveSteps(event.steps);
        },
        onError: (error) {
          Utils.debugLog("Pedometer error: $error");
        },
      );
    } catch (e) {
      Utils.debugLog("Error initializing pedometer: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double distanceInMeters = todaySteps * metersPerStep;
    String distanceText = distanceInMeters >= 1000
        ? "${(distanceInMeters / 1000).toStringAsFixed(2)} km"
        : "${distanceInMeters.toStringAsFixed(2)} meters";
    double progress = (todaySteps / stepGoal).clamp(0.0, 1.0);

    return BlocConsumer<HomePageCubit, HomePageState>(
      listener: (context, state) {
        state.maybeWhen(
          updatingStepData: () {},
          updatedStepData: (data) {
            _stepResponseModel = data;
          },
          updateStepDataError: (error) {},
          orElse: () {},
        );
      },
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            Text(
              "Daily Steps",
              style: AppTextStyles.heading4Bold.copyWith(
                color: AppColors.primaryBlue100,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Image.asset(
              AppImages.walkingGif,
              width: Window.getSize(100),
              height: Window.getSize(100),
              fit: BoxFit.contain,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              _stepResponseModel != null
                  ? "${_stepResponseModel!.data!.count} Steps"
                  : "Loading...",
              style: AppTextStyles.heading2Bold.copyWith(
                color: AppColors.neutral100,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              distanceText,
              style: AppTextStyles.bodyBold.copyWith(
                color: AppColors.primaryBlue100,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            _buildProgressButton(progress, todaySteps),
            const SizedBox(
              height: 30,
            ),
            _buildStatsRow(),
          ],
        );
      },
    );
  }

  Widget _buildProgressButton(double progress, int todaySteps) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 5),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 50,
              width: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [AppColors.primaryBlue70, AppColors.primaryBlue100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(3, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 50,
                  backgroundColor: AppColors.primaryBlue70.withOpacity(0.4),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primaryBlue100,
                  ),
                ),
              ),
            ),
            FittedBox(
              child: Text(
                "${_stepResponseModel != null ? "${_stepResponseModel!.data!.count} Steps" : "Loading..."} / $stepGoal Steps Completed",
                style: AppTextStyles.bodyBold.copyWith(
                  color: AppColors.neutral10,
                  fontSize: 16,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatContainer(
          AppStrings.distance,
          _stepResponseModel != null
              ? _stepResponseModel!.data!.distanceInMeter.toString()
              : "Loading",
          "KM",
          Icons.directions_walk,
        ),
        _buildStatContainer(
          AppStrings.coins,
          _stepResponseModel != null
              ? _stepResponseModel!.data!.coinsEarned.toString()
              : "Loading",
          "Coins",
          Icons.currency_bitcoin,
        ),
        _buildStatContainer(
          AppStrings.calories,
          _stepResponseModel != null
              ? _stepResponseModel!.data!.caloriesInCal.toString()
              : "Loading",
          "Cal",
          Icons.local_fire_department,
        ),
      ],
    );
  }

  Widget _buildStatContainer(
      String title, String value, String unit, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.primaryBlue100,
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          title,
          style: AppTextStyles.captionSemiBold.copyWith(
            fontSize: 10,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.subtitleBold.copyWith(
            fontSize: 14,
          ),
        ),
        Text(
          unit,
          style: AppTextStyles.captionRegular.copyWith(
            fontSize: 10,
            color: AppColors.neutral70,
          ),
        ),
      ],
    );
  }
}
