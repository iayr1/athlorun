import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:athlorun/config/di/dependency_injection.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import 'package:athlorun/core/utils/utils.dart';
import 'package:athlorun/core/widgets/custom_appbar.dart';
import 'package:athlorun/features/profile/data/models/get_gear_response_model.dart';
import 'package:athlorun/features/profile/presentation/bloc/profile_cubit.dart';
import '../../../../config/routes/routes.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';

class AllGearPageWrapper extends StatelessWidget {
  const AllGearPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileCubit>(),
      child: const AllGearPage(),
    );
  }
}

class AllGearPage extends StatefulWidget {
  const AllGearPage({super.key});

  @override
  State<AllGearPage> createState() => _AllGearPageState();
}

class _AllGearPageState extends State<AllGearPage> {
  late final ProfileCubit _cubit;
  late List<GetGearResponseModelData> gearAllList = [];
  String authId = "";

  @override
  void initState() {
    _cubit = context.read<ProfileCubit>();
    _cubit.getAuthData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: AppStrings.allGear,
        centerTitle: true,
        actions: [
          IconButton(
            icon:
                const Icon(Icons.add_box_outlined, color: AppColors.neutral100),
            tooltip: AppStrings.addNewGear,
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.addNewGear).then(
                (_) {
                  _cubit.getAllGear(authId);
                },
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return state.maybeWhen(
            loadingGear: () => const Center(
              child: CircularProgressIndicator(),
            ),
            loadedGear: (response) {
              gearAllList = response.data ?? [];

              if (gearAllList.isEmpty) {
                return Center(
                  child: Text(AppStrings.noGearAvailable,
                      style: AppTextStyles.bodyRegular
                          .copyWith(color: AppColors.neutral60)),
                );
              }

              // Grouping items by category
              Map<String, List<GetGearResponseModelData>> categorizedGear = {};
              for (var gear in gearAllList) {
                String category = gear.type?.name ?? "Unknown";
                categorizedGear.putIfAbsent(category, () => []).add(gear);
              }

              return Padding(
                padding: Window.getSymmetricPadding(horizontal: 16.0),
                child: ListView(
                  children: categorizedGear.entries.map((entry) {
                    String category = entry.key;
                    List<GetGearResponseModelData> items = entry.value;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: Window.getVerticalSize(20)),
                        SectionHeader(title: category, itemCount: items.length),
                        SizedBox(height: Window.getVerticalSize(10)),
                        ...items.map((data) => GearItem(
                              imagePath: data.photo ?? "",
                              title: data.brand ?? "Unknown",
                              subtitle: data.sport?.name ?? "Unknown",
                              onPressedUpdate: () {
                                Navigator.pushNamed(
                                    context, AppRoutes.addNewGear,
                                    arguments: data);
                              },
                              onPressedDelete: () {
                                _cubit.deleteGear(authId, data.id.toString());
                              },
                            )),
                      ],
                    );
                  }).toList(),
                ),
              );
            },
            orElse: () => Center(
              child: Text("Something went wrong.",
                  style: AppTextStyles.bodyBold
                      .copyWith(color: AppColors.neutral60)), // Fallback UI
            ),
          );
        },
        listener: (context, state) {
          state.maybeWhen(
            gettingAuthData: () {},
            gotAuthData: (authData) {
              authId = authData.id;
              _cubit.getAllGear(authData.id);
            },
            deletingGear: () {},
            deleteGear: () {
              _cubit.getAllGear(authId);
            },
            deleteGearError: (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Delete Error: $error")),
              );
            },
            loadGearError: (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Load Error: $error")),
              );
            },
            orElse: () {},
          );
        },
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final int itemCount;

  const SectionHeader({
    super.key,
    required this.title,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.subtitleBold,
        ),
        Text(
          '$itemCount',
          style:
              AppTextStyles.captionRegular.copyWith(color: AppColors.neutral60),
        ),
      ],
    );
  }
}

class GearItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final VoidCallback onPressedUpdate;
  final VoidCallback onPressedDelete;

  const GearItem(
      {super.key,
      required this.imagePath,
      required this.title,
      required this.subtitle,
      required this.onPressedUpdate,
      required this.onPressedDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.neutral30),
        borderRadius: BorderRadius.circular(Window.getRadiusSize(16)),
      ),
      child: ListTile(
        leading: ClipRRect(
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
        title: Text(
          title,
          style:
              AppTextStyles.bodyBold.copyWith(fontSize: Window.getFontSize(16)),
        ),
        subtitle: Text(
          subtitle,
          style:
              AppTextStyles.captionRegular.copyWith(color: AppColors.neutral60),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: onPressedUpdate),
            IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () {
                  Utils.showCustomDeleteDialog(
                    context,
                    AppStrings.deleteGear,
                    AppStrings.areYouSureWantTodeleteGear,
                    () {
                      onPressedDelete();
                    },
                  );
                }),
          ],
        ),
      ),
    );
  }
}
