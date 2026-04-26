import 'package:flutter/material.dart';
import '../../config/styles/app_colors.dart';
import '../../config/styles/app_textstyles.dart';
import '../../core/utils/windows.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({Key? key}) : super(key: key);

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    Window().adaptDeviceScreenSize(view: View.of(context)); // Initialize Window

    return Scaffold(
      backgroundColor: AppColors.neutral30, // Light background color
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page Header
          Padding(
            padding: Window.getPadding(top: 50, left: 20, bottom: 20),
            child: Text(
              "Order History",
              style: AppTextStyles.heading4Bold.copyWith(
                color: AppColors.neutral80,
              ),
            ),
          ),

          // Order History List
          Expanded(
            child: ListView.builder(
              padding: Window.getPadding(left: 16, right:16 ),
              itemCount: 5, // Replace with actual data count
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: Window.getMargin(top: 10, bottom: 10),
                    padding: Window.getPadding(all: 16),
                    decoration: BoxDecoration(
                      color: AppColors.neutral10,
                      borderRadius:
                          BorderRadius.circular(Window.getRadiusSize(12)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.neutral60.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Event Name
                        Text(
                          "Sports Event #${index + 1}",
                          style: AppTextStyles.bodySemiBold.copyWith(
                            fontSize: Window.getFontSize(18),
                            color: AppColors.neutral90,
                          ),
                        ),
                        SizedBox(height: Window.getVerticalSize(8)),

                        // Event Details
                        Row(
                          children: [
                            Icon(Icons.calendar_today,
                                size: Window.getFontSize(16),
                                color: AppColors.neutral60),
                            SizedBox(width: Window.getHorizontalSize(8)),
                            Text(
                              "25th Jan 2025",
                              style: AppTextStyles.bodyRegular.copyWith(
                                color: AppColors.neutral60,
                                fontSize: Window.getFontSize(14),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Window.getVerticalSize(5)),
                        Row(
                          children: [
                            Icon(Icons.access_time,
                                size: Window.getFontSize(16),
                                color: AppColors.neutral60),
                            SizedBox(width: Window.getHorizontalSize(8)),
                            Text(
                              "6:00 PM",
                              style: AppTextStyles.bodyRegular.copyWith(
                                color: AppColors.neutral60,
                                fontSize: Window.getFontSize(14),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Window.getVerticalSize(5)),
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                size: Window.getFontSize(16),
                                color: AppColors.neutral60),
                            SizedBox(width: Window.getHorizontalSize(8)),
                            Expanded(
                              child: Text(
                                "National Stadium",
                                style: AppTextStyles.bodyRegular.copyWith(
                                  color: AppColors.neutral60,
                                  fontSize: Window.getFontSize(14),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (isExpanded) ...[
                          SizedBox(height: Window.getVerticalSize(10)),
                          Divider(color: AppColors.neutral30),
                          SizedBox(height: Window.getVerticalSize(10)),

                          // Expanded Details
                          Row(
                            children: [
                              Icon(Icons.confirmation_num,
                                  size: Window.getFontSize(16),
                                  color: AppColors.neutral60),
                              SizedBox(width: Window.getHorizontalSize(8)),
                              Text(
                                "Category: VIP",
                                style: AppTextStyles.bodyRegular.copyWith(
                                  color: AppColors.neutral60,
                                  fontSize: Window.getFontSize(14),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: Window.getVerticalSize(10)),
                          Container(
                            padding:
                                Window.getSymmetricPadding(vertical: 6, horizontal: 12),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.secondaryGreen100.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                  Window.getRadiusSize(8)),
                            ),
                            child: Text(
                              "Status: Confirmed",
                              style: AppTextStyles.bodyBold.copyWith(
                                fontSize: Window.getFontSize(14),
                                color: AppColors.secondaryGreen100,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
