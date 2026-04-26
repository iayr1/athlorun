import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:athlorun/config/di/dependency_injection.dart';
import 'package:athlorun/config/images/app_images.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import 'package:athlorun/core/utils/utils.dart';
import 'package:athlorun/core/widgets/custom_appbar.dart';
import 'package:athlorun/features/profile/data/models/get_sports_response_model.dart';
import 'package:athlorun/features/profile/data/models/request/create_schedule_request_model.dart';
import 'package:athlorun/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:athlorun/features/profile/presentation/skeleton/schedule_widget_skeleton.dart';
import 'package:athlorun/features/profile/presentation/widgets/custom_drop_down_widget.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';
import '../../../../core/widgets/custom_action_button.dart';
import '../../data/models/response/get_schedule_response_model.dart';

enum ScheduleType { upcoming, missed, completed }

class ScheduleScreenWrapper extends StatelessWidget {
  const ScheduleScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileCubit>(),
      child: const ScheduleScreen(),
    );
  }
}

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with SingleTickerProviderStateMixin {
  late final ProfileCubit _cubit;
  late List<Sport> _defaultSports = [];
  late TabController _tabController;

  @override
  void initState() {
    _cubit = context.read<ProfileCubit>();
    _cubit.getSports();
    _cubit.getSchedule();
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  void _editSchedule(GetScheduleResponseModelData schedule) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AddScheduleBottomSheet(
        cubit: _cubit,
        defaultSport: _defaultSports,
        scheduleList: schedule,
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await Utils.showCustomDatePicker(context: context);

    if (picked != null) {
      _cubit.selectDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral10,
      appBar: customAppBar(
        title: AppStrings.schedule,
        centerTitle: true,
        onBackPressed: () => Navigator.pop(context),
        actions: [
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              return state.maybeWhen(
                loadedSchedule: (_, selectedDate) => selectedDate != null
                    ? IconButton(
                        onPressed: () {
                          _cubit.getSchedule();
                        },
                        icon: const Icon(Icons.restart_alt_rounded,
                            size: 28, color: AppColors.neutral100),
                      )
                    : const SizedBox.shrink(),
                orElse: () => const SizedBox.shrink(),
              );
            },
          ),
          IconButton(
            onPressed: () => _selectDate(context),
            icon: const Icon(Icons.calendar_today_outlined,
                size: 24, color: AppColors.neutral100),
          )
        ],
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                return state.maybeWhen(
                  loadedSchedule: (_, selectedDate) => selectedDate != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.calendar_month, size: 16),
                                const SizedBox(width: 2),
                                Text(
                                    Utils.formatToDayMonth(
                                        selectedDate.toString()),
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () => _cubit.getSchedule(),
                                  child: const Icon(Icons.close,
                                      size: 16, color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  orElse: () => const SizedBox.shrink(),
                );
              },
            ),
            _buildTabBar(),
            const SizedBox(height: 10),
            Expanded(
              child: state.maybeWhen(
                loadingSchedule: (selectDate) {
                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 5),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return const ScheduleWidgetSkeleton();
                    },
                  );
                },
                loadScheduleError: (error, selectDate) {
                  return const Center(
                    child: Text(AppStrings.somethingWentWrong),
                  );
                },
                loadedSchedule: (data, selectDate) {
                  final _scheduleList = data;
                  final displayList = selectDate != null
                      ? _cubit.filteredSchedules
                      : _scheduleList;

                  return TabBarView(controller: _tabController, children: [
                    _buildScheduleList(displayList, ScheduleType.upcoming),
                    _buildScheduleList(displayList, ScheduleType.missed),
                    _buildScheduleList(displayList, ScheduleType.completed)
                  ]);
                },
                orElse: () => Container(),
              ),
            )
          ],
        );
      }, listener: (context, state) {
        state.maybeWhen(
            loadingSports: () {},
            loadedSports: (data) {
              _defaultSports = data.data as List<Sport>;
            },
            loadSportsError: (error) {
              Utils.showCustomDialog(
                  context, AppStrings.error, error.toString());
            },
            createdSchedule: (response) {
              _cubit.getSchedule();
            },
            createScheduleError: (er) {
              Utils.showCustomDialog(context, AppStrings.error, er.toString());
            },
            deletingSchedule: () {},
            deleteSchedule: () {
              _cubit.getSchedule();
            },
            deleteScheduleError: (error) {
              Utils.showCustomDialog(
                  context, AppStrings.error, error.toString());
            },
            updatingSchedule: () {},
            updatedSchedule: (response) {
              _cubit.getSchedule();
            },
            updateScheduleError: (error) {
              Utils.showCustomDialog(
                  context, AppStrings.error, error.toString());
            },
            orElse: () {});
      }),
      bottomNavigationBar: Padding(
        padding: Window.getPadding(left: 16.0, right: 16.0, bottom: 16.0),
        child: CustomActionButton(
          name: AppStrings.addSchedule,
          isFormFilled: true,
          onTap: (startLoading, stopLoading, btnState) {
            startLoading();
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) => AddScheduleBottomSheet(
                  cubit: _cubit, defaultSport: _defaultSports),
            ).whenComplete(() {
              stopLoading();
            });
          },
        ),
      ),
    );
  }

  Widget _buildScheduleList(
      List<GetScheduleResponseModelData> schedules, ScheduleType type) {
    List<GetScheduleResponseModelData> filteredSchedules =
        schedules.where((schedule) {
      final DateTime? scheduleDate = DateTime.tryParse(schedule.scheduleAt!);
      if (scheduleDate == null) return false;

      final bool isCompleted = schedule.isCompleted ?? false;
      final bool isPast = scheduleDate.isBefore(DateTime.now());

      switch (type) {
        case ScheduleType.upcoming:
          return !isPast && !isCompleted;
        case ScheduleType.missed:
          return isPast && !isCompleted;
        case ScheduleType.completed:
          return isCompleted;
      }
    }).toList();

    filteredSchedules = filteredSchedules.reversed.toList();

    if (filteredSchedules.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(AppImages.noScheduleLottie, width: 150, height: 150),
            Text(
              type == ScheduleType.upcoming
                  ? AppStrings.noUpcomingSchedulefound
                  : type == ScheduleType.missed
                      ? AppStrings.noMissedSchedulefound
                      : AppStrings.noCompletedSchedulefound,
              style: AppTextStyles.bodyRegular
                  .copyWith(color: AppColors.neutral60),
            ),
          ],
        ),
      );
    }

    return SlidableAutoCloseBehavior(
      closeWhenOpened: true,
      closeWhenTapped: true,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: filteredSchedules.length,
        physics: const BouncingScrollPhysics(),
        padding: Window.getSymmetricPadding(horizontal: 16),
        itemBuilder: (context, index) {
          final schedule = filteredSchedules[index];
          final formattedDate = Utils.formatToDayMonth(schedule.scheduleAt!);

          return type == ScheduleType.completed
              ? Container(
                  margin: Window.getMargin(bottom: 8),
                  padding: Window.getPadding(all: 4),
                  decoration: BoxDecoration(
                    color: AppColors.neutral10,
                    borderRadius:
                        BorderRadius.circular(Window.getRadiusSize(12)),
                    border: Border.all(color: AppColors.neutral30),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: Window.getHorizontalSize(24),
                      backgroundColor: AppColors.primaryBlue20,
                      child: SvgPicture.network(
                        schedule.sport!.icon.toString(),
                        width: Window.getHorizontalSize(25),
                        height: Window.getHorizontalSize(25),
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      schedule.name.toString(),
                      style: AppTextStyles.bodyBold
                          .copyWith(color: AppColors.neutral100),
                    ),
                    subtitle: Row(
                      children: [
                        Text(
                          "${AppStrings.schedule} • ",
                          style: AppTextStyles.captionBold.copyWith(
                            color: AppColors.neutral70,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          formattedDate,
                          style: AppTextStyles.captionRegular
                              .copyWith(color: AppColors.neutral60),
                        ),
                      ],
                    ),
                  ),
                )
              : Slidable(
                  key: Key(schedule.id.toString()),
                  startActionPane: ActionPane(
                    motion: const StretchMotion(),
                    dismissible: DismissiblePane(onDismissed: () {
                      final reqBody =
                          CreateScheduleRequestModel(isCompleted: true);
                      _cubit.updateSchedule(schedule.id.toString(), reqBody);
                    }),
                    children: [
                      SlidableAction(
                        backgroundColor: AppColors.primaryBlue100,
                        icon: Icons.check,
                        label: "Swipe to Complete",
                        onPressed: (context) {
                          final reqBody =
                              CreateScheduleRequestModel(isCompleted: true);
                          _cubit.updateSchedule(
                              schedule.id.toString(), reqBody);
                        },
                      ),
                    ],
                  ),
                  child: Container(
                    margin: Window.getMargin(bottom: 8),
                    padding: Window.getPadding(all: 4),
                    decoration: BoxDecoration(
                      color: AppColors.neutral10,
                      border: Border.all(color: AppColors.neutral30),
                      borderRadius:
                          BorderRadius.circular(Window.getRadiusSize(12)),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: Window.getHorizontalSize(24),
                        backgroundColor: AppColors.primaryBlue20,
                        child: SvgPicture.network(
                          schedule.sport!.icon.toString(),
                          width: Window.getHorizontalSize(25),
                          height: Window.getHorizontalSize(25),
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        schedule.name.toString(),
                        style: AppTextStyles.bodyBold
                            .copyWith(color: AppColors.neutral100),
                      ),
                      subtitle: Row(
                        children: [
                          Text(
                            "${AppStrings.schedule} • ",
                            style: AppTextStyles.captionBold.copyWith(
                              color: AppColors.neutral70,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            formattedDate,
                            style: AppTextStyles.captionRegular.copyWith(
                                color: AppColors.neutral60, fontSize: 10),
                          ),
                        ],
                      ),
                      trailing: type == ScheduleType.completed
                          ? null
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                type == ScheduleType.missed
                                    ? const SizedBox.shrink()
                                    : IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () {
                                          _editSchedule(schedule);
                                        },
                                      ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    Utils.showCustomDeleteDialog(
                                      context,
                                      AppStrings.deleteSchedule,
                                      AppStrings.areYouSureWantTodeleteSchedule,
                                      () {
                                        _cubit.deleteSchedule(schedule.id!);
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                    ),
                  ),
                );
        },
      ),
    );
  }

  Widget _buildTabBar() {
    return DefaultTabController(
      length: 3,
      child: TabBar(
        physics: const BouncingScrollPhysics(),
        controller: _tabController,
        labelStyle:
            AppTextStyles.bodyRegular.copyWith(color: AppColors.neutral60),
        labelColor: Colors.black,
        splashFactory: NoSplash.splashFactory,
        unselectedLabelColor: AppColors.neutral60,
        dividerColor: Colors.white,
        indicator: const UnderlineTabIndicator(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(
            width: 4,
            color: AppColors.primaryBlue100,
          ),
        ),
        tabs: const [
          Tab(text: AppStrings.upcoming),
          Tab(text: AppStrings.missed),
          Tab(text: AppStrings.completed),
        ],
      ),
    );
  }
}

class AddScheduleBottomSheet extends StatefulWidget {
  final ProfileCubit cubit;
  final List<Sport> defaultSport;
  final GetScheduleResponseModelData? scheduleList;
  const AddScheduleBottomSheet(
      {super.key,
      required this.defaultSport,
      required this.cubit,
      this.scheduleList});

  @override
  State<AddScheduleBottomSheet> createState() => _AddScheduleBottomSheetState();
}

class _AddScheduleBottomSheetState extends State<AddScheduleBottomSheet> {
  final TextEditingController _scheduleNameController = TextEditingController();
  Sport? selectedSport;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? formattedDateTime;
  late List<Sport> _defaultSportList = [];

  bool get _isFormFilled =>
      _scheduleNameController.text.isNotEmpty &&
      selectedDate != null &&
      selectedTime != null;

  void dataFormat() {
    if (selectedDate != null && selectedTime != null) {
      // Combine selected date and time into a DateTime object (assumed IST)
      final DateTime istDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );

      // IST Offset (UTC +5:30)
      const Duration istOffset = Duration(hours: 5, minutes: 30);

      // Convert to UTC by subtracting IST offset
      final DateTime utcDateTime = istDateTime.subtract(istOffset);

      // Format in ISO 8601 format
      formattedDateTime = utcDateTime.toIso8601String().split('.').first;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime? picked = await Utils.showCustomDatePicker(context: context);

    if (picked != null) {
      final DateTime pickedDate =
          DateTime(picked.year, picked.month, picked.day);

      if (pickedDate.isAfter(today) || pickedDate.isAtSameMomentAs(today)) {
        setState(() {
          selectedDate = picked;
        });
      } else {
        Utils.showCustomDialog(
          context,
          AppStrings.error,
          AppStrings.youCantSelectAPastDate,
        );
      }
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked =
        await Utils.showCustomTimePicker(context: context);

    if (picked != null) {
      final TimeOfDay now = TimeOfDay.now();

      // Convert both current and picked times to minutes for easier comparison.
      final nowInMinutes = now.hour * 60 + now.minute;
      final pickedInMinutes = picked.hour * 60 + picked.minute;

      if (pickedInMinutes >= nowInMinutes) {
        setState(() {
          selectedTime = picked;
        });
      } else {
        Utils.showCustomDialog(
          context,
          AppStrings.error,
          AppStrings.youCantSelectAPastTime,
        );
      }
    }
  }

  void _saveSchedule() {
    try {
      if (selectedSport == null ||
          selectedDate == null ||
          selectedTime == null) {
        Utils.showCustomDialog(
            context, AppStrings.error, AppStrings.pleaseFillAllTheFields);
      } else {
        dataFormat();

        final reqBody = CreateScheduleRequestModel(
          scheduleName: _scheduleNameController.text,
          scheduleAt: formattedDateTime.toString(),
          sportId: selectedSport?.id.toString(),
        );

        widget.cubit.createSchedule(reqBody).then((r) {
          if (mounted) {
            Utils.showCustomDialog(
              context,
              AppStrings.woww,
              AppStrings.yourScheduleHasBeenSavedSuccessfully,
            );
          }
        }).onError((error, stackTrace) {
          if (mounted) {
            Utils.showCustomDialog(context, AppStrings.error, error.toString());
          }
        });
      }
    } catch (e) {
      Utils.showCustomDialog(context, AppStrings.error, e.toString());
    }
  }

  void _updateSchedule() {
    try {
      if (selectedSport == null ||
          selectedDate == null ||
          selectedTime == null) {
        Utils.showCustomDialog(
            context, AppStrings.error, AppStrings.pleaseFillAllTheFields);
        return;
      }

      // Convert selectedDate and selectedTime to DateTime
      final DateTime now = DateTime.now();
      final DateTime selectedDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );

      if (selectedDateTime.isBefore(now)) {
        Future.delayed(Duration.zero, () {
          Utils.showCustomDialog(
            context,
            AppStrings.error,
            AppStrings.youCantSelectAPastTime,
          );
        });
        return;
      }

      dataFormat();

      final reqBody = CreateScheduleRequestModel(
        scheduleName: _scheduleNameController.text,
        scheduleAt: formattedDateTime.toString(),
        sportId: selectedSport?.id.toString(),
      );

      widget.cubit.updateSchedule(widget.scheduleList!.id!, reqBody).then((r) {
        if (mounted) {
          Utils.showCustomDialog(
            context,
            AppStrings.woww,
            AppStrings.yourScheduleHasBeenUpdatedSuccessfully,
          );
        }
      }).onError((error, stackTrace) {
        if (mounted) {
          Utils.showCustomDialog(context, AppStrings.error, error.toString());
        }
      });
    } catch (e) {
      Utils.showCustomDialog(context, AppStrings.error, e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _defaultSportList = widget.defaultSport;
    if (widget.scheduleList != null) {
      _scheduleNameController.text = widget.scheduleList!.name!;
      selectedSport = _defaultSportList.firstWhere(
        (sport) => sport.id == widget.scheduleList!.sport!.id,
        orElse: () => _defaultSportList.first,
      );
      DateTime utcDateTime = DateTime.parse(widget.scheduleList!.scheduleAt!);
      DateTime istDateTime =
          utcDateTime.add(const Duration(hours: 5, minutes: 30));
      selectedDate =
          DateTime(istDateTime.year, istDateTime.month, istDateTime.day);
      selectedTime = TimeOfDay.fromDateTime(istDateTime);
      dataFormat();
    } else {
      selectedSport = _defaultSportList.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.neutral10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: Window.getVerticalSize(16),
          left: Window.getHorizontalSize(16),
          right: Window.getHorizontalSize(16),
          bottom: MediaQuery.of(context).viewInsets.bottom +
              Window.getVerticalSize(16),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 5,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: AppColors.neutral30,
                  ),
                ),
              ),
              SizedBox(
                height: Window.getVerticalSize(15),
              ),
              Text(
                AppStrings.addNewSchedule,
                style: AppTextStyles.heading5Bold
                    .copyWith(color: AppColors.neutral100),
              ),
              SizedBox(
                height: Window.getVerticalSize(20),
              ),

              // Schedule Name Input
              Text(
                "Schedule Name",
                style: AppTextStyles.subtitleBold
                    .copyWith(color: AppColors.neutral80),
              ),
              SizedBox(
                height: Window.getVerticalSize(5),
              ),
              TextField(
                controller: _scheduleNameController,
                decoration: InputDecoration(
                  hintText: AppStrings.enterName,
                  hintStyle: AppTextStyles.bodyRegular
                      .copyWith(color: AppColors.neutral50),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius:
                        BorderRadius.circular(Window.getRadiusSize(12)),
                  ),
                  filled: true,
                  fillColor: AppColors.neutral20,
                ),
              ),
              SizedBox(
                height: Window.getVerticalSize(16),
              ),

              // Sport Selection Dropdown
              CustomDropDownWidget<Sport>(
                bottomTitle: AppStrings.chooseaSport,
                label: AppStrings.defaultSport,
                value: selectedSport,
                items: _defaultSportList,
                onChanged: (value) {
                  setState(() {
                    selectedSport = value;
                  });
                },
                getLabel: (sport) => sport.name.toString(),
                iconBuilder: (sport) => SvgPicture.network(
                  sport.icon ?? '',
                  width: 24,
                  height: 24,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.sports,
                    size: 24,
                  ),
                ),
              ),

              SizedBox(height: Window.getVerticalSize(16)),

              // Date and Time Pickers
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Select Date",
                          style: AppTextStyles.subtitleBold
                              .copyWith(color: AppColors.neutral80),
                        ),
                        SizedBox(
                          height: Window.getVerticalSize(5),
                        ),
                        GestureDetector(
                          onTap: () {
                            _selectDate(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: Window.getVerticalSize(14),
                                horizontal: Window.getHorizontalSize(12)),
                            decoration: BoxDecoration(
                              color: AppColors.neutral20,
                              borderRadius: BorderRadius.circular(
                                  Window.getRadiusSize(12)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  selectedDate == null
                                      ? AppStrings.selectDate
                                      : "${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}",
                                  style: AppTextStyles.bodyRegular
                                      .copyWith(color: AppColors.neutral100),
                                ),
                                const Icon(Icons.calendar_today,
                                    color: Colors.blue),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: Window.getHorizontalSize(12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Select Time",
                          style: AppTextStyles.subtitleBold
                              .copyWith(color: AppColors.neutral80),
                        ),
                        SizedBox(
                          height: Window.getVerticalSize(5),
                        ),
                        GestureDetector(
                          onTap: _selectTime,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: Window.getVerticalSize(14),
                                horizontal: Window.getHorizontalSize(12)),
                            decoration: BoxDecoration(
                              color: AppColors.neutral20,
                              borderRadius: BorderRadius.circular(
                                  Window.getRadiusSize(12)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  selectedTime == null
                                      ? AppStrings.selectTime
                                      : selectedTime!.format(context),
                                  style: AppTextStyles.bodyRegular
                                      .copyWith(color: AppColors.neutral100),
                                ),
                                const Icon(Icons.access_time,
                                    color: Colors.blue),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: Window.getVerticalSize(20)),

              // Add Button
              CustomActionButton(
                name: widget.scheduleList != null
                    ? AppStrings.updateSchedule
                    : AppStrings.saveSchedule,
                isFormFilled: _isFormFilled,
                onTap: (startLoading, stopLoading, btnState) {
                  if (_isFormFilled) {
                    if (widget.scheduleList != null) {
                      _updateSchedule();
                    } else {
                      _saveSchedule();
                    }
                    Navigator.pop(context);
                  } else {
                    Utils.showCustomDialog(context, AppStrings.error,
                        AppStrings.pleaseFillAllTheFields);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
