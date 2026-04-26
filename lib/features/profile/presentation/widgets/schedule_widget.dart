import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:athlorun/config/di/dependency_injection.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import 'package:athlorun/core/utils/utils.dart';
import 'package:athlorun/features/profile/data/models/response/get_schedule_response_model.dart';
import 'package:athlorun/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:athlorun/features/profile/presentation/skeleton/schedule_widget_skeleton.dart';
import '../../../../config/routes/routes.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';

class ScheduleWidgetWrapper extends StatelessWidget {
  const ScheduleWidgetWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      create: (context) => sl<ProfileCubit>(),
      child: const ScheduleWidget(),
    );
  }
}

class ScheduleWidget extends StatefulWidget {
  const ScheduleWidget({super.key});

  @override
  State<ScheduleWidget> createState() => _ScheduleWidgetState();
}

class _ScheduleWidgetState extends State<ScheduleWidget> {
  late List<GetScheduleResponseModelData> scheduleAllList = [];
  late final ProfileCubit _cubit;

  @override
  void initState() {
    _cubit = context.read<ProfileCubit>();
    _cubit.getSchedule();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        state.maybeWhen(
            loadingSchedule: (selectDate) {},
            loadedSchedule: (data, selectDate) {
              scheduleAllList = data;
            },
            loadScheduleError: (error, selectDate) {},
            orElse: () {});
      },
      builder: (context, state) {
        return state.maybeWhen(
          loadingSchedule: (selectedDate) {
            return const ScheduleWidgetSkeleton();
          },
          loadedSchedule: (data, selectedDate) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.schedule,
                      style: AppTextStyles.subtitleMedium
                          .copyWith(color: AppColors.neutral100),
                    ),
                    scheduleAllList.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                      context, AppRoutes.scheduleScreen)
                                  .then((_) {
                                _cubit.getSchedule();
                              });
                            },
                            child: Text(
                              AppStrings.sellAll,
                              style: AppTextStyles.bodyMedium
                                  .copyWith(color: AppColors.primaryBlue100),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
                SizedBox(height: Window.getVerticalSize(20)),

                // Schedule Items List
                scheduleAllList.isNotEmpty
                    ? SizedBox(
                        height: Window.getVerticalSize(80),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final schedule =
                                scheduleAllList.reversed.toList()[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: _buildScheduleItem(
                                title: schedule.name.toString(),
                                type: Utils.formatToDayMonth(
                                    schedule.scheduleAt.toString()),
                                imagePath: schedule.sport!.icon.toString(),
                              ),
                            );
                          },
                          itemCount: scheduleAllList.length,
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.scheduleScreen)
                              .then((_) {
                            _cubit.getSchedule();
                          });
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add_circle_outline,
                              size: 60,
                              color: Colors.grey.shade300,
                            ),
                            Text(
                              AppStrings.clickToCreateSchedule,
                              style: AppTextStyles.bodyBold
                                  .copyWith(color: AppColors.neutral60),
                            )
                          ],
                        ),
                      )
              ],
            );
          },
          loadScheduleError: (error, selectedDate) {
            return Utils.showError();
          },
          orElse: () {
            return Container();
          },
        );
      },
    );
  }

  Widget _buildScheduleItem({
    required String title,
    required String type,
    required String imagePath,
  }) {
    return Container(
      width: Window.getHorizontalSize(300),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.neutral30),
        borderRadius: BorderRadius.circular(Window.getRadiusSize(16)),
      ),
      child: Padding(
        padding: Window.getPadding(all: 16.0),
        child: Row(
          children: [
            // Circular Image Container
            CircleAvatar(
              radius: Window.getHorizontalSize(24),
              backgroundColor: AppColors.primaryBlue20,
              child: SvgPicture.network(
                imagePath,
                width: Window.getHorizontalSize(25),
                height: Window.getHorizontalSize(25),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: Window.getHorizontalSize(16)),

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyBold.copyWith(
                      color: AppColors.neutral100,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: Window.getVerticalSize(4)),
                  Row(
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
                        type,
                        style: AppTextStyles.captionRegular.copyWith(
                          color: AppColors.neutral60,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
