import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:athlorun/config/styles/app_colors.dart';
import 'package:athlorun/config/styles/app_textstyles.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import 'package:athlorun/core/utils/utils.dart';
import 'package:athlorun/core/utils/windows.dart';
import 'package:athlorun/features/events/data/models/response/get_events_response_model.dart';
import 'package:athlorun/features/events/presentation/bloc/events_page_cubit.dart';

// class CouponCodeFieldWrapper extends StatelessWidget {
//   final GetEventsResponseModelData getEventsResponseModelData;
//   final double totalAmount;
//   const CouponCodeFieldWrapper({
//     super.key,
//     required this.getEventsResponseModelData,
//     required this.totalAmount,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => sl<EventsPageCubit>(),
//       child: CouponCodeField(
//         getEventsResponseModelData: getEventsResponseModelData,
//         totalAmount: totalAmount,
//       ),
//     );
//   }
// }

class CouponCodeField extends StatefulWidget {
  final GetEventsResponseModelData getEventsResponseModelData;
  final double totalAmount;
  const CouponCodeField({
    super.key,
    required this.getEventsResponseModelData,
    required this.totalAmount,
  });

  @override
  State<CouponCodeField> createState() => _CouponCodeFieldState();
}

class _CouponCodeFieldState extends State<CouponCodeField> {
  final TextEditingController _couponCodecontroller = TextEditingController();
  late EventsPageCubit _eventsPageCubit;

  @override
  void initState() {
    super.initState();
    _eventsPageCubit = context.read<EventsPageCubit>();
  }

  void applyCoupon() {
    if (_couponCodecontroller.text.trim().isNotEmpty) {
      _eventsPageCubit.applyCouponCode(
        context,
        widget.getEventsResponseModelData,
        _couponCodecontroller,
        widget.totalAmount,
      );
    } else {
      Utils.showCustomDialog(
        context,
        AppStrings.error,
        "Please Enter Coupon Code.",
      );
    }
  }

  void clearCoupon() {
    _couponCodecontroller.clear();
    _eventsPageCubit.clearCoupon(widget.totalAmount);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsPageCubit, EventsPageState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Apply Coupon", style: AppTextStyles.subtitleMedium),
            SizedBox(height: Window.getVerticalSize(8)),
            Container(
              height: Window.getVerticalSize(48),
              decoration: BoxDecoration(
                color: AppColors.neutral10,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.neutral30, width: 1.5),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _couponCodecontroller,
                      enabled: !_eventsPageCubit.isApplied,
                      style: AppTextStyles.bodyRegular.copyWith(
                        fontSize: Window.getFontSize(16),
                        color: AppColors.neutral100,
                      ),
                      onSubmitted: (_) => applyCoupon(),
                      decoration: InputDecoration(
                        hintText: "Enter coupon code",
                        hintStyle: AppTextStyles.bodyRegular.copyWith(
                          fontSize: Window.getFontSize(16),
                          color: AppColors.neutral50,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: _eventsPageCubit.isApplied
                        ? IconButton(
                            key: const ValueKey("clear"),
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: clearCoupon,
                          )
                        : TextButton(
                            key: const ValueKey("apply"),
                            onPressed: () {
                              applyCoupon();
                            },
                            child: Text(
                              "Apply",
                              style: AppTextStyles.bodyBold.copyWith(
                                color: AppColors.primaryBlue100,
                                fontSize: Window.getFontSize(14),
                              ),
                            ),
                          ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
