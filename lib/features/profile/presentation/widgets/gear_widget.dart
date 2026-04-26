import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:athlorun/config/di/dependency_injection.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import 'package:athlorun/features/profile/data/models/get_gear_response_model.dart';
import 'package:athlorun/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:athlorun/features/profile/presentation/skeleton/gear_widget_skeleton.dart';
import '../../../../config/routes/routes.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';

class GearWidgetWrapper extends StatelessWidget {
  const GearWidgetWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      create: (context) => sl<ProfileCubit>(),
      child: const GearWidget(),
    );
  }
}

class GearWidget extends StatefulWidget {
  const GearWidget({super.key});

  @override
  State<GearWidget> createState() => _GearWidgetState();
}

class _GearWidgetState extends State<GearWidget> {
  late List<GetGearResponseModelData> gearAllList = [];
  late final ProfileCubit _cubit;
  String authid = "";

  @override
  void initState() {
    _cubit = context.read<ProfileCubit>();
    _cubit.getAuthData();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit.getAllGear(authid);
    _cubit.getAuthData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        state.maybeWhen(
          loadingGear: () {},
          loadedGear: (response) {
            gearAllList = response.data ?? [];
          },
          loadGearError: (error) {},
          gettingAuthData: () {},
          gotAuthData: (authData) {
            authid = authData.id;
            _cubit.getAllGear(authData.id);
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        return state.maybeWhen(
          loadingGear: () {
            return const GearWidgetSkeleton();
          },
          loadedGear: (response) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.myGear,
                      style: AppTextStyles.subtitleMedium
                          .copyWith(color: AppColors.neutral100),
                    ),
                    gearAllList.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.allGear)
                                  .then((_) {
                                _cubit.getAllGear(authid);
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

                // Gear Items List
                gearAllList.isNotEmpty
                    ? SizedBox(
                        height: Window.getVerticalSize(
                            80), // Provide a fixed height
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: _buildGearItem(
                                title: gearAllList[index].brand.toString(),
                                type: gearAllList[index].type!.name.toString(),
                                imagePath: gearAllList[index].photo.toString(),
                              ),
                            );
                          },
                          itemCount: gearAllList.length,
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.addNewGear)
                              .then((_) {
                            _cubit.getAllGear(authid);
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
                              AppStrings.clickToCreateGear,
                              style: AppTextStyles.bodyBold
                                  .copyWith(color: AppColors.neutral60),
                            )
                          ],
                        ),
                      )
              ],
            );
          },
          loadGearError: (error) {
            // return Utils.showError();
            return Container();
          },
          orElse: () {
            return Container();
          },
        );
      },
    );
  }

  Widget _buildGearItem({
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
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(
                imageUrl: imagePath,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 50,
                  height: 50,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: AppColors.neutral20,
                    shape: BoxShape.circle,
                  ),
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: AppColors.neutral20,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.error, color: Colors.red, size: 24),
                ),
              ),
            ),
            SizedBox(width: Window.getHorizontalSize(16)),

            // Text Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyBold
                      .copyWith(color: AppColors.neutral100),
                ),
                SizedBox(height: Window.getVerticalSize(4)),
                Text(
                  type,
                  style: AppTextStyles.captionRegular
                      .copyWith(color: AppColors.neutral60),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
