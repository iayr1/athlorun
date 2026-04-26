import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/di/dependency_injection.dart';
import '../../../../config/routes/routes.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../profile/data/models/get_gear_response_model.dart';
import '../../../profile/presentation/bloc/profile_cubit.dart';
import '../../../profile/presentation/skeleton/gear_widget_skeleton.dart';

class GearSelectionBottomSheetWrapper extends StatelessWidget {
  const GearSelectionBottomSheetWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, controller) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Material(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocProvider<ProfileCubit>(
              create: (context) => sl<ProfileCubit>()..getAuthData(),
              child: _GearWidgetContent(scrollController: controller),
            ),
          ),
        ),
      ),
    );
  }
}

class _GearWidgetContent extends StatefulWidget {
  final ScrollController scrollController;
  const _GearWidgetContent({required this.scrollController});

  @override
  State<_GearWidgetContent> createState() => _GearWidgetContentState();
}

class _GearWidgetContentState extends State<_GearWidgetContent> {
  late List<GetGearResponseModelData> gearAllList = [];
  late final ProfileCubit _cubit;
  String authid = "";

  @override
  void initState() {
    super.initState();
    _cubit = context.read<ProfileCubit>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit.getAuthData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        state.maybeWhen(
          loadedGear: (response) {
            gearAllList = response.data ?? [];
          },
          gotAuthData: (authData) {
            authid = authData.id;
            _cubit.getAllGear(authData.id);
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        return state.maybeWhen(
          loadingGear: () => const GearWidgetSkeleton(),
          loadedGear: (_) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.myGear, style: AppTextStyles.heading5Bold),
              const SizedBox(height: 16),
              Expanded(
                child: gearAllList.isNotEmpty
                    ? ListView.builder(
                        controller: widget.scrollController,
                        itemCount: gearAllList.length,
                        itemBuilder: (context, index) {
                          final gear = gearAllList[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pop(context, {
                                'id': gear.id,
                                'name': gear.brand ?? '',
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _buildGearItem(
                                title: gear.brand ?? '',
                                type: gear.type?.name ?? '',
                                imagePath: gear.photo ?? '',
                              ),
                            ),
                          );
                        },
                      )
                    : GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.addNewGear,
                        ).then((_) => _cubit.getAllGear(authid)),
                        child: Column(
                          children: [
                            Icon(Icons.add_circle_outline,
                                size: 60, color: Colors.grey.shade300),
                            Text(AppStrings.clickToCreateGear,
                                style: AppTextStyles.bodyBold
                                    .copyWith(color: AppColors.neutral60)),
                          ],
                        ),
                      ),
              ),
            ],
          ),
          orElse: () => const SizedBox(),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.neutral30),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: CachedNetworkImage(
              imageUrl: imagePath,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              placeholder: (_, __) => const CircularProgressIndicator(),
              errorWidget: (_, __, ___) => const Icon(Icons.error),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: AppTextStyles.bodyBold
                      .copyWith(color: AppColors.neutral100)),
              const SizedBox(height: 4),
              Text(type,
                  style: AppTextStyles.captionRegular
                      .copyWith(color: AppColors.neutral60)),
            ],
          ),
        ],
      ),
    );
  }
}
