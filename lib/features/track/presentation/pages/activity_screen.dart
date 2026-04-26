import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:athlorun/config/styles/app_colors.dart';
import 'package:athlorun/config/styles/app_textstyles.dart';
import 'package:athlorun/core/utils/windows.dart';
import 'package:athlorun/core/widgets/custom_action_button.dart';
import 'package:athlorun/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:athlorun/features/track/presentation/bloc/track_page_cubit.dart';
import 'package:athlorun/features/track/presentation/widgets/exertion_slider.dart';
import '../../../../config/di/dependency_injection.dart';
import '../../../../core/global_store/domain/usecases/get_user_auth_data_usecase.dart';
import '../../../profile/data/models/get_gear_response_model.dart';
import '../widgets/gear_bottomsheet.dart';

class ActivityScreenWrapper extends StatelessWidget {
  const ActivityScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TrackPageCubit>(
          create: (_) => sl<TrackPageCubit>(),
        ),
        BlocProvider<ProfileCubit>(
          create: (_) => sl<ProfileCubit>(),
        )
      ],
      child: ActivityScreen(),
    );
  }
}

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  int currentStep = 0;
  String? selectedRunType = 'Race';
  String? selectedGear = 'Nike Revolution 7';
  String? hiddenStat = 'Avg Pace';
  String exertionLevel = 'moderate';
  List<XFile>? images = [];
  String? distance;
  String? duration;
  String? calories;
  String? avgPace;
  String? polylineString;
  String? sportId;
  String? selectedSportItem;
  String? selectedGearName;
  String? selectedGearId;
  List<GetGearResponseModelData> gearList = [];
  final runTypes = ['Long Run', 'Race', 'Commute', 'Workout'];
  final gearOptions = ['Nike Revolution 7', 'Nike Pegasus Trail 4'];
  final statOptions = ['Avg Pace', 'Calories'];
  TextEditingController activityNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  LatLng mapCenter = const LatLng(19.0760, 72.8777);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map?;

      if (args != null) {
        try {
          setState(() {
            polylineString = args['polylineString']?.toString();
            distance = args['distance']?.toString();
            duration = args['duration']?.toString();
            calories = args['calories']?.toString();
            avgPace = args['avgPace']?.toString();
            selectedSportItem = args['selectedSport']?.toString();
            sportId = args['sportId']?.toString();

            debugPrint('📍 polylineString: $polylineString');
            debugPrint('📏 distance: $distance');
            debugPrint('⏱️ duration: $duration');
            debugPrint('🔥 calories: $calories');
            debugPrint('⚡ avgPace: $avgPace');
            debugPrint('🏃‍♂️ selectedSport: $selectedSportItem');
            debugPrint('🆔 sportId: $sportId');

            if (polylineString != null && polylineString!.isNotEmpty) {
              final last = polylineString!.split('|').last.split(',');
              mapCenter = LatLng(double.parse(last[0]), double.parse(last[1]));
              debugPrint('🗺️ mapCenter updated to: $mapCenter');
            }
          });
        } catch (e) {
          debugPrint('❌ [ActivityScreen] Error parsing arguments: $e');
        }
      }
    });
  }

  String _getValidDistance(String? distanceStr) {
    final distance = double.tryParse(distanceStr ?? '') ?? 0;
    return distance > 0 ? distance.toStringAsFixed(2) : '1.00';
  }

  String _getValidDuration(String? durationStr) {
    final duration = int.tryParse(durationStr ?? '') ?? 0;
    return duration > 0 ? duration.toString() : '1';
  }

  String _getValidSteps(String? distanceStr) {
    final distance = double.tryParse(distanceStr ?? '') ?? 0;
    final steps = (distance * 1300).round();
    return steps > 0 ? steps.toString() : '1';
  }

  void pickImages() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    if (picked != null) {
      setState(() => images = picked);
    }
  }

  void _showBottomSheet(
      String title, List<String> options, Function(String) onSelected) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: Window.getPadding(all: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: AppTextStyles.heading5Bold),
            const SizedBox(height: 16),
            ...options.map((opt) => ListTile(
                  title: Text(opt, style: AppTextStyles.bodySemiBold),
                  onTap: () {
                    onSelected(opt);
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TrackPageCubit>();
    return BlocConsumer<TrackPageCubit, TrackPageState>(
      listener: (context, state) {
        state.maybeWhen(
          activitySaved: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Activity Saved Successfully')),
            );
            Navigator.pop(context);
          },
          saveActivityError: (msg) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $msg')),
            );
          },
          orElse: () {},
        );
      },
      builder: (context, state) => Scaffold(
        backgroundColor: AppColors.neutral10,
        appBar: AppBar(
          backgroundColor: AppColors.neutral10,
          title: const Text('Save Activity', style: AppTextStyles.titleBold),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.chevron_left, color: AppColors.neutral100),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Column(
          children: [
            _buildStepIndicator(),
            Expanded(
              child: currentStep == 0
                  ? activityDetails()
                  : activitySettings(cubit),
            ),
          ],
        ),
      ),
    );
  }

  Widget activityDetails() {
    return SingleChildScrollView(
      child: Padding(
        padding: Window.getPadding(all: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _activityInfoCard(
              selectedSport: selectedSportItem,
              distance: distance,
              duration: duration,
              avgPace: avgPace,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: activityNameController,
              decoration: InputDecoration(
                labelText: 'Activity Name',
                labelStyle: const TextStyle(color: AppColors.neutral100),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.neutral100),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.neutral100),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.neutral100, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Colors.redAccent, width: 2),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: const TextStyle(color: AppColors.neutral100),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.neutral100),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.neutral100),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.neutral100, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Colors.redAccent, width: 2),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
            const SizedBox(height: 10),
            _buildPhotoUploadSection(),
            const SizedBox(height: 50),
            CustomActionButton(
                name: 'Continue',
                isFormFilled: activityNameController.text.isNotEmpty,
                onTap: (start, stop, state) => setState(() => currentStep = 1)),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => setState(() => currentStep = 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: currentStep > 0
                      ? AppColors.neutral50
                      : AppColors.primaryBlue100,
                  child: currentStep > 0
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : const Text('1',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14)),
                ),
                const SizedBox(width: 4),
                Text("Activity Details",
                    style: TextStyle(
                        color: currentStep == 0
                            ? AppColors.primaryBlue100
                            : AppColors.neutral50,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(height: 2, width: 50, color: Colors.grey[300]),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => setState(() => currentStep = 1),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor:
                      currentStep == 1 ? AppColors.primaryBlue100 : Colors.grey,
                  child: const Text('2',
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                ),
                const SizedBox(width: 4),
                Text("Activity Settings",
                    style: TextStyle(
                        color: currentStep == 1
                            ? AppColors.primaryBlue100
                            : Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget activitySettings(TrackPageCubit cubit) {
    return SingleChildScrollView(
      child: Padding(
        padding: Window.getPadding(all: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Map Preview', style: AppTextStyles.bodySemiBold),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: mapCenter,
                    initialZoom: 14,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.none,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: mapCenter,
                          child: const Icon(Icons.place,
                              color: Colors.red, size: 32),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Run Type
            _buildBottomSheetPicker("Type of Run", selectedRunType!, runTypes,
                (v) => setState(() => selectedRunType = v)),
            const SizedBox(height: 16),

            // Gear Picker (Open Gear BottomSheet)
            GestureDetector(
              onTap: () async {
                final selectedGear =
                    await showModalBottomSheet<Map<String, dynamic>>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  builder: (context) => const GearSelectionBottomSheetWrapper(),
                );

                if (selectedGear != null) {
                  final gearId = selectedGear['id'];
                  final gearName = selectedGear['name'];
                  print("Selected Gear ➝ ID: $gearId, Name: $gearName");

                  setState(() {
                    selectedGearName = gearName;
                  });
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedGearName ?? 'Select Your Gear',
                      style: AppTextStyles.bodySemiBold,
                    ),
                    const Icon(Icons.arrow_drop_down,
                        color: AppColors.neutral100),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            _buildBottomSheetPicker("Hide Stat", hiddenStat!, statOptions,
                (v) => setState(() => hiddenStat = v)),

            const SizedBox(height: 24),

            // Exertion Slider
            ExertionSlider(
              label: exertionLevel,
              onChanged: (val) {
                exertionLevel = val.toString();
                setState(() {});
              },
            ),

            const SizedBox(height: 32),

            // Save Button
            Center(
              child: CustomActionButton(
                name: 'Save Activity',
                isFormFilled: true,
                onTap: (startLoading, stopLoading, btnState) async {
                  startLoading();

                  final imageFile = images != null && images!.isNotEmpty
                      ? File(images!.first.path)
                      : File('');

                  final authResult = await sl<GetUserAuthDataUsecase>().call();

                  await authResult.fold(
                    (failure) {
                      stopLoading();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Failed to get user ID")),
                      );
                    },
                    (authData) async {
                      debugPrint('[ActivityScreen] ✅ Saving Activity');

                      await cubit.saveActivity(
                        id: authData.id,
                        polyline: polylineString ?? '',
                        sportId: sportId ?? '',
                        completedAt: DateTime.now().toIso8601String(),
                        distanceInKm: _getValidDistance(distance),
                        durationInSeconds: _getValidDuration(duration),
                        stepsCount: _getValidSteps(distance),
                        name: activityNameController.text,
                        description: descriptionController.text,
                        mapType: 'standard',
                        gearId: selectedGearId ?? '',
                        hideStatistics: hiddenStat ?? '',
                        exertion: exertionLevel,
                        mediaFile: imageFile,
                      );
                      stopLoading();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Photo or Video', style: AppTextStyles.bodySemiBold),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: pickImages,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.add_a_photo, color: Colors.blueAccent),
          ),
        ),
        const SizedBox(height: 8),
        images == null || images!.isEmpty
            ? const Text('No images added', style: AppTextStyles.bodyRegular)
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: images!.length,
                itemBuilder: (_, index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(images![index].path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }

  Widget _buildBottomSheetPicker(String label, String selectedValue,
      List<String> options, Function(String) onSelected) {
    return GestureDetector(
      onTap: () => _showBottomSheet(label, options, onSelected),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(selectedValue, style: AppTextStyles.bodySemiBold),
            const Icon(Icons.arrow_drop_down, color: AppColors.neutral100),
          ],
        ),
      ),
    );
  }
}

String formatDuration(String? durationInSeconds) {
  if (durationInSeconds == null || durationInSeconds == '0') return '00:00';
  final int seconds = int.tryParse(durationInSeconds) ?? 0;
  final Duration duration = Duration(seconds: seconds);
  final String minutes =
      duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final String secondsStr =
      duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$secondsStr';
}

Widget _activityInfoCard({
  required String? selectedSport,
  required String? distance,
  required String? duration,
  required String? avgPace,
}) {
  final bool showDistance =
      distance != null && distance != '0' && distance.trim().isNotEmpty;
  final String paceFormatted =
      (avgPace == null || avgPace == '0' || avgPace.trim().isEmpty)
          ? '0 min/km'
          : '$avgPace min/km';

  return Container(
    padding: Window.getPadding(all: 12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.neutral100, width: 1.5),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.directions_run, color: Colors.black54, size: 20),
            const SizedBox(width: 6),
            Text(selectedSport ?? "Unknown Sport",
                style: AppTextStyles.heading5Bold),
          ],
        ),
        const SizedBox(height: 4),
        Text(DateFormat('EEE MMM d, yyyy  hh:mm a').format(DateTime.now()),
            style: AppTextStyles.bodyRegular),
        const SizedBox(height: 8),

        // ⏱️ Duration (always visible)
        Row(
          children: [
            const Icon(Icons.timer, color: Colors.black54, size: 20),
            const SizedBox(width: 6),
            Text('Duration: ${formatDuration(duration)}',
                style: AppTextStyles.bodySemiBold),
          ],
        ),

        const SizedBox(height: 4),

        // 📏 Distance (only if present)
        if (showDistance)
          Row(
            children: [
              const Icon(Icons.straighten, color: Colors.black54, size: 20),
              const SizedBox(width: 6),
              Text('Distance: $distance km', style: AppTextStyles.bodySemiBold),
            ],
          ),

        const SizedBox(height: 4),

        // ⚡ Avg Pace (always visible)
        Row(
          children: [
            const Icon(Icons.speed, color: Colors.black54, size: 20),
            const SizedBox(width: 6),
            Text('Avg Pace: $paceFormatted', style: AppTextStyles.bodySemiBold),
          ],
        ),
      ],
    ),
  );
}

class SelectedGearResult {
  final String id;
  final String name;

  SelectedGearResult({
    required this.id,
    required this.name,
  });
}
