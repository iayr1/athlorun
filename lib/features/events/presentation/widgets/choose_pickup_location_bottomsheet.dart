import 'package:flutter/material.dart';
import 'package:athlorun/config/styles/app_colors.dart';
import 'package:athlorun/config/styles/app_textstyles.dart';
import 'package:athlorun/core/utils/windows.dart';
import 'package:athlorun/core/widgets/custom_action_button.dart';

void showPickupLocationBottomSheet(BuildContext context) {
  String? selectedLocation;

  final List<Map<String, String>> locations = [
    {
      'title': 'Indira Priyadarshini Outdoor stadium',
      'address':
          'No 26-14-119, Raja Rammohan Roy Rd, Opposite P&T Office, Near Head Post Office, Velampeta, Visakhapatnam, Andhra Pradesh 530001'
    },
    {
      'title': 'Opposite MVV City',
      'address':
          'Pothinamallayya Palem, Visakhapatnam, Andhra Pradesh 530041, India'
    },
  ];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.neutral10,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Padding(
              padding:
                  Window.getPadding(left: 16, top: 20, right: 16, bottom: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Header
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Select pick-up location',
                          style: AppTextStyles.subtitleBold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),

                  SizedBox(height: Window.getVerticalSize(4)),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Ticket pickup',
                      style: AppTextStyles.bodyBold,
                    ),
                  ),

                  SizedBox(height: Window.getVerticalSize(4)),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Collect physical tickets prior to the event at the designated location',
                      style: AppTextStyles.captionRegular
                          .copyWith(color: AppColors.neutral60),
                    ),
                  ),

                  SizedBox(height: Window.getVerticalSize(20)),

                  /// Location Options
                  ...locations.map((location) {
                    bool isSelected = selectedLocation == location['title'];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedLocation = location['title'];
                        });
                      },
                      child: Container(
                        margin: Window.getMargin(bottom: 16),
                        padding: Window.getPadding(all: 16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.neutral20
                              : AppColors.neutral10,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.neutral100
                                : AppColors.neutral30,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Radio<String>(
                              value: location['title']!,
                              groupValue: selectedLocation,
                              onChanged: (value) {
                                setState(() {
                                  selectedLocation = value;
                                });
                              },
                              activeColor: AppColors.neutral100,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    location['title']!,
                                    style: AppTextStyles.bodyBold,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    location['address']!,
                                    style: AppTextStyles.captionRegular
                                        .copyWith(color: AppColors.neutral60),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'View on maps',
                                    style: AppTextStyles.captionSemiBold
                                        .copyWith(color: Colors.blue),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),

                  SizedBox(height: Window.getVerticalSize(10)),

                  /// Custom Proceed Button
                  CustomActionButton(
                    name: "Proceed",
                    isFormFilled: selectedLocation != null,
                    onTap: (startLoading, stopLoading, btnState) {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
