import 'package:flutter/material.dart';
import 'package:athlorun/config/images/app_images.dart';
import 'package:athlorun/config/routes/routes.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';

class CustomProfileWidget extends StatefulWidget {
  const CustomProfileWidget({super.key});

  @override
  State<CustomProfileWidget> createState() => _CustomProfileWidgetState();
}

class _CustomProfileWidgetState extends State<CustomProfileWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ClipOval(
              child: Image.asset(
                AppImages.profileImagePlaceHolder,
                height: Window.getVerticalSize(80),
                width: Window.getVerticalSize(80),
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(width: Window.getHorizontalSize(16)),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Guest User",
                        style: AppTextStyles.titleBold
                            .copyWith(color: AppColors.neutral100),
                      ),

                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.profileUpdateScreen,
                              );
                            },
                            child: const Icon(
                              Icons.edit,
                              color: AppColors.primaryBlue70,
                              size: 20,
                            ),
                          ),

                          const SizedBox(width: 10),

                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.settingsPage);
                            },
                            child: const Icon(
                              Icons.settings,
                              color: AppColors.neutral80,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  Text(
                    "BEGINNER",
                    style: AppTextStyles.subtitleRegular
                        .copyWith(color: AppColors.neutral80),
                  ),

                  SizedBox(height: Window.getVerticalSize(8)),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),

        Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            dividerColor: Colors.transparent,
          ),
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            trailing: const SizedBox.shrink(),
            onExpansionChanged: (expanded) {
              setState(() {
                _isExpanded = expanded;
              });
            },
            title: Row(
              children: [
                Text(
                  AppStrings.viewMoreDetails,
                  style: AppTextStyles.captionRegular.copyWith(
                    color: AppColors.primaryBlue100,
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  _isExpanded
                      ? Icons.expand_less
                      : Icons.expand_more,
                ),
              ],
            ),
            children: const [
              _InfoTile(title: "Email", value: "example@email.com"),
              _InfoTile(title: "Phone", value: "+91 9876543210"),
              _InfoTile(title: "Height", value: "170 Cm"),
              _InfoTile(title: "Weight", value: "70 Kg"),
              _InfoTile(title: "Gender", value: "Male"),
              _InfoTile(title: "Age", value: "25"),
              _InfoTile(title: "Target", value: "Stay Fit"),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String title;
  final String value;

  const _InfoTile({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minTileHeight: 10,
      title: Text(
        title,
        style: AppTextStyles.bodyBold
            .copyWith(color: AppColors.neutral100),
      ),
      subtitle: Text(
        value,
        style: AppTextStyles.captionRegular
            .copyWith(color: AppColors.neutral60),
      ),
    );
  }
}