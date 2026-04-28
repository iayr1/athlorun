import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../config/routes/routes.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/windows.dart';

class AllGearPage extends StatelessWidget {
  const AllGearPage({super.key});

  @override
  Widget build(BuildContext context) {

    /// Dummy grouped data (UI only)
    final Map<String, List<Map<String, String>>> gearData = {
      "Running Shoes": [
        {
          "title": "Nike Pegasus",
          "subtitle": "Running",
          "image":
              "https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/pegasus.png"
        },
        {
          "title": "Adidas Boost",
          "subtitle": "Running",
          "image":
              "https://assets.adidas.com/images/boost.png"
        },
      ],
      "Cycling Gear": [
        {
          "title": "Helmet Pro",
          "subtitle": "Cycling",
          "image":
              "https://cdn-icons-png.flaticon.com/512/2972/2972185.png"
        }
      ]
    };

    return Scaffold(
      backgroundColor: AppColors.neutral10,
      appBar: AppBar(
        title: Text(AppStrings.allGear),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.addNewGear);
            },
          ),
        ],
      ),

      body: gearData.isEmpty
          ? Center(
              child: Text(
                AppStrings.noGearAvailable,
                style: AppTextStyles.bodyRegular
                    .copyWith(color: AppColors.neutral60),
              ),
            )
          : Padding(
              padding: Window.getSymmetricPadding(horizontal: 16),
              child: ListView(
                children: gearData.entries.map((entry) {
                  final category = entry.key;
                  final items = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: Window.getVerticalSize(20)),

                      /// Section Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            category,
                            style: AppTextStyles.subtitleBold,
                          ),
                          Text(
                            "${items.length}",
                            style: AppTextStyles.captionRegular
                                .copyWith(color: AppColors.neutral60),
                          ),
                        ],
                      ),

                      SizedBox(height: Window.getVerticalSize(10)),

                      /// Items
                      ...items.map((item) {
                        return _GearItem(
                          imagePath: item["image"]!,
                          title: item["title"]!,
                          subtitle: item["subtitle"]!,
                          onEdit: () {
                            Navigator.pushNamed(
                                context, AppRoutes.addNewGear);
                          },
                          onDelete: () {
                            // UI only
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Deleted")),
                            );
                          },
                        );
                      }),
                    ],
                  );
                }).toList(),
              ),
            ),
    );
  }
}

class _GearItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _GearItem({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.neutral30),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: CachedNetworkImage(
            imageUrl: imagePath,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            placeholder: (_, __) => const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            errorWidget: (_, __, ___) =>
                const Icon(Icons.image_not_supported),
          ),
        ),

        title: Text(
          title,
          style: AppTextStyles.bodyBold,
        ),

        subtitle: Text(
          subtitle,
          style: AppTextStyles.captionRegular
              .copyWith(color: AppColors.neutral60),
        ),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}