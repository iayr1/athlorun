import 'package:flutter/material.dart';
import 'package:athlorun/config/styles/app_colors.dart';
import 'package:athlorun/config/styles/app_textstyles.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import 'package:athlorun/core/utils/utils.dart';
import 'package:athlorun/core/utils/windows.dart';
import 'package:athlorun/core/widgets/custom_action_button.dart';
import 'package:athlorun/features/events/data/models/response/get_events_response_model.dart';
import 'package:athlorun/features/events/presentation/pages/ticket_form_page.dart';

class TicketBookingBottomSheet {
  static void show({
    required BuildContext context,
    required GetEventsResponseModelData getEventsResponseModelData,
    required Slot? slot,
  }) {
    int quantity = 1;
    double totalAmount = double.parse(getEventsResponseModelData.price!);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.neutral10,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              void increaseQuantity() {
                final maxTickets =
                    getEventsResponseModelData.maxTicketsPerUser ?? 5;
                if (quantity < maxTickets) {
                  setState(() {
                    quantity++;
                    totalAmount = quantity *
                        double.parse(getEventsResponseModelData.price!);
                  });
                } else {
                  Utils.showCustomDialog(
                    context,
                    "Ticket Limit Exceed 🎟️!!",
                    "You can only buy up to $maxTickets tickets per event.",
                  );
                }
              }

              void decreaseQuantity() {
                if (quantity > 1) {
                  setState(() {
                    quantity--;
                    totalAmount = quantity *
                        double.parse(getEventsResponseModelData.price!);
                  });
                }
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag Handle
                  Container(
                    height: 5,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: AppColors.neutral30,
                    ),
                  ),
                  SizedBox(height: Window.getVerticalSize(15)),

                  const Text(
                    AppStrings.selectTicketQuantity,
                    style: AppTextStyles.heading5Bold,
                  ),
                  SizedBox(height: Window.getVerticalSize(16)),

                  // Quantity Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: decreaseQuantity,
                        icon: const Icon(Icons.remove_circle_outline,
                            size: 32, color: AppColors.primaryBlue80),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          quantity.toString(),
                          style: AppTextStyles.heading4Bold,
                        ),
                      ),
                      IconButton(
                        onPressed: increaseQuantity,
                        icon: const Icon(Icons.add_circle_outline,
                            size: 32, color: AppColors.primaryBlue80),
                      ),
                    ],
                  ),

                  SizedBox(height: Window.getVerticalSize(16)),

                  Text(
                    "Total: ₹${totalAmount.toStringAsFixed(2)}",
                    style: AppTextStyles.subtitleBold.copyWith(
                      color: AppColors.primaryBlue100,
                    ),
                  ),
                  SizedBox(height: Window.getVerticalSize(16)),

                  // Book Button
                  CustomActionButton(
                    onTap: (startLoading, stopLoading, state) {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TicketFormPageWrapper(
                            getEventsResponseModelData:
                                getEventsResponseModelData,
                            selectedTicketQuantity: quantity,
                            slot: slot,
                            amount: totalAmount,
                          ),
                        ),
                      );
                    },
                    name: "Book Now",
                    isFormFilled: true,
                  ),
                  SizedBox(height: Window.getVerticalSize(20)),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
