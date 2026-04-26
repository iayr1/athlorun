import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:athlorun/config/di/dependency_injection.dart';
import 'package:athlorun/config/styles/app_colors.dart';
import 'package:athlorun/config/styles/app_textstyles.dart';
import 'package:athlorun/core/global_store/cubit/global_store_cubit.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import 'package:athlorun/core/utils/utils.dart';
import 'package:athlorun/core/utils/windows.dart';
import 'package:athlorun/core/widgets/custom_action_button.dart';
import 'package:athlorun/core/widgets/custom_appbar.dart';
import 'package:athlorun/features/events/data/models/request/ticket_booking_request_model.dart';
import 'package:athlorun/features/events/data/models/response/get_events_response_model.dart';
import 'package:athlorun/features/events/presentation/bloc/events_page_cubit.dart';
import 'package:athlorun/features/events/presentation/widgets/apply_coupon_code_field.dart';

class ReviewBookingPageWrapper extends StatelessWidget {
  final Slot? slot;
  final int? ticketQuantity;
  final double totalAmount;
  final List<TicketHolder> ticketHolder;
  final GetEventsResponseModelData getEventsResponseModelData;

  const ReviewBookingPageWrapper({
    super.key,
    this.slot,
    this.ticketQuantity,
    required this.totalAmount,
    required this.ticketHolder,
    required this.getEventsResponseModelData,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<EventsPageCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<GlobalStoreCubit>(),
        ),
      ],
      child: ReviewBookingPage(
        slot: slot,
        ticketQuantity: ticketQuantity,
        totalAmount: totalAmount,
        ticketHolder: ticketHolder,
        getEventsResponseModelData: getEventsResponseModelData,
      ),
    );
  }
}

class ReviewBookingPage extends StatefulWidget {
  final Slot? slot;
  final int? ticketQuantity;
  final double totalAmount;
  final List<TicketHolder> ticketHolder;
  final GetEventsResponseModelData getEventsResponseModelData;
  const ReviewBookingPage({
    super.key,
    this.slot,
    this.ticketQuantity,
    required this.totalAmount,
    required this.ticketHolder,
    required this.getEventsResponseModelData,
  });

  @override
  State<ReviewBookingPage> createState() => _ReviewBookingPageState();
}

class _ReviewBookingPageState extends State<ReviewBookingPage> {
  late EventsPageCubit _eventsPageCubit;
  late GlobalStoreCubit _globalStoreCubit;
  @override
  void initState() {
    super.initState();
    _eventsPageCubit = context.read<EventsPageCubit>();
    _globalStoreCubit = context.read<GlobalStoreCubit>();
  }

  @override
  Widget build(BuildContext context) {
    double couponDeducatedAmount = 0.0;
    bool isAppliedCoupon = false;
    Utils.debugLog("CHECKING STATE");
    return Scaffold(
      backgroundColor: AppColors.neutral10,
      appBar: customAppBar(
        title: AppStrings.reviewYourBooking,
        centerTitle: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      bottomNavigationBar: Padding(
        padding: Window.getPadding(left: 16, right: 16, bottom: 16, top: 5),
        child: BlocListener<EventsPageCubit, EventsPageState>(
          listener: (context, state) {
            state.maybeWhen(
              bookingEventTicket: () {
                _eventsPageCubit.startLoading();
              },
              bookedEventTicket: (response) {
                _eventsPageCubit.stopLoading();
                Utils.debugLog("Order Id: ${response.data!.payment!.orderId!}");
                Utils.debugLog(
                    "Amount: ${isAppliedCoupon ? couponDeducatedAmount : widget.totalAmount}");
                Utils.debugLog(
                    "Payment Session Id: ${response.data!.payment!.paymentSessionId!}");
                _globalStoreCubit.payThroughPaymentGateway(
                  context,
                  response.data!.payment!.orderId!,
                  isAppliedCoupon ? couponDeducatedAmount : widget.totalAmount,
                  response.data!.payment!.paymentSessionId!,
                );
              },
              bookingEventTicketError: (error) {
                _eventsPageCubit.stopLoading();
                Utils.showCustomDialog(
                  context,
                  AppStrings.error,
                  error,
                );
              },
              orElse: () {},
            );
          },
          child: CustomActionButton(
            name: "Booked Now",
            isFormFilled: true,
            onTap: (startLoading, stopLoading, btnState) {
              _eventsPageCubit.assignLoadingFunction(startLoading, stopLoading);
              _eventsPageCubit.bookedEventTickets(
                TicketBookingRequestModel(
                  amountPaid: isAppliedCoupon
                      ? couponDeducatedAmount
                      : widget.totalAmount,
                  tickets: widget.ticketHolder,
                  coinsUsed: 0,
                  couponsApplied: (isAppliedCoupon &&
                          _eventsPageCubit.enterdCouponCode != null)
                      ? [_eventsPageCubit.enterdCouponCode!.id!]
                      : null,
                ),
                widget.getEventsResponseModelData.id!,
                widget.slot!.id!,
              );
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: Window.getPadding(all: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🧩 TGIR Event Preview
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    height: Window.getVerticalSize(70),
                    width: Window.getHorizontalSize(70),
                    imageUrl: widget.getEventsResponseModelData.banner!,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: Window.getHorizontalSize(12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.getEventsResponseModelData.title!,
                        style: AppTextStyles.bodyBold,
                      ),
                      SizedBox(height: Window.getVerticalSize(4)),
                      Text(
                        widget.getEventsResponseModelData.location!.address!,
                        style: AppTextStyles.captionRegular
                            .copyWith(color: AppColors.neutral60),
                      )
                    ],
                  ),
                )
              ],
            ),

            SizedBox(height: Window.getVerticalSize(24)),

            /// 🎟 Booking Info
            Container(
              padding: Window.getPadding(all: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.neutral20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${Utils.formatToDayMonth(widget.getEventsResponseModelData.date.toString())}  • ${Utils.formatTimeWithAMPM(widget.slot!.startTime!)}",
                    style: AppTextStyles.bodyBold,
                  ),
                  SizedBox(height: Window.getVerticalSize(16)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${widget.ticketQuantity} x ${widget.getEventsResponseModelData.title}",
                        style: AppTextStyles.bodyRegular,
                      ),
                      Text(
                        "${AppStrings.rupee} ${widget.totalAmount}",
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                  SizedBox(height: Window.getVerticalSize(4)),
                  Text(
                    widget.getEventsResponseModelData.obstacles!,
                    style: AppTextStyles.captionRegular.copyWith(
                      color: AppColors.neutral60,
                    ),
                  ),
                  Utils.dottedDivider(),
                  Row(
                    children: [
                      const Icon(
                        Icons.confirmation_num_outlined,
                        size: 20,
                      ),
                      SizedBox(width: Window.getHorizontalSize(8)),
                      const Expanded(
                        child: Text(
                          "Digital Ticket: Show your e-ticket at entry. Wear comfortable sportswear!",
                          style: AppTextStyles.captionRegular,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: Window.getVerticalSize(24)),

            /// 🎁 Coupons
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.getEventsResponseModelData.coupons!.map(
                (coupon) {
                  return _buildCoupons(
                    "Coupons",
                    coupon.description!,
                    coupon.code!,
                  );
                },
              ).toList(),
            ),

            /// 🎁 Offers
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.getEventsResponseModelData.coupons!.map(
                (coupon) {
                  return _buildOffers("Offers", "Flat 10% off for groups (5+)",
                      "10% cashback via PayNow");
                },
              ).toList(),
            ),

            SizedBox(height: Window.getVerticalSize(15)),

            /// 🔖 Coupon Code
            CouponCodeField(
              getEventsResponseModelData: widget.getEventsResponseModelData,
              totalAmount: widget.totalAmount,
            ),
            SizedBox(height: Window.getVerticalSize(24)),

            /// 💸 Payment Summary
            const Text("Payment summary", style: AppTextStyles.subtitleMedium),
            SizedBox(height: Window.getVerticalSize(12)),
            BlocConsumer<EventsPageCubit, EventsPageState>(
              builder: (context, state) {
                return Container(
                  padding: Window.getPadding(all: 16),
                  decoration: BoxDecoration(
                    color: AppColors.neutral20,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildPaymentRow("Ticket Price",
                          "${AppStrings.rupee} ${widget.getEventsResponseModelData.price}"),
                      SizedBox(height: Window.getVerticalSize(8)),
                      _buildPaymentRow(
                          "Ticket Quantity", "x ${widget.ticketQuantity}"),
                      // _buildPaymentRow("Booking Fee (incl. GST)", "₹120.00"),
                      _buildPaymentRow(
                        "Total Amount",
                        "${AppStrings.rupee} ${widget.totalAmount.toStringAsFixed(2)}",
                      ),

                      if (isAppliedCoupon)
                        _eventsPageCubit.discountType == "flat"
                            ? _buildPaymentRow(
                                "Coupon Discount (Flat)",
                                " - ${AppStrings.rupee} ${_eventsPageCubit.discountValue}",
                              )
                            : _buildPaymentRow(
                                "Coupon Discount (${_eventsPageCubit.discountValue}%)",
                                " - ${AppStrings.rupee} ${_eventsPageCubit.discountValue}",
                              ),
                      Utils.dottedDivider(),
                      isAppliedCoupon
                          ? _buildPaymentRow(
                              "Grand Total",
                              "${AppStrings.rupee} ${couponDeducatedAmount.toStringAsFixed(2)}",
                              isBold: true,
                            )
                          : _buildPaymentRow(
                              "Grand Total",
                              "${AppStrings.rupee} ${widget.totalAmount.toStringAsFixed(2)}",
                              isBold: true,
                            )
                    ],
                  ),
                );
              },
              listener: (BuildContext context, EventsPageState state) {
                state.maybeWhen(
                    isAppliedCoupon: (isApplied, amount) {
                      couponDeducatedAmount = amount;
                      isAppliedCoupon = isApplied;
                    },
                    orElse: () {});
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOffers(String heading, String title, String subTitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(heading, style: AppTextStyles.subtitleMedium),
        SizedBox(height: Window.getVerticalSize(4)),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.local_offer_outlined),
          title: Text(title, style: AppTextStyles.bodyRegular),
          subtitle: Text(subTitle, style: AppTextStyles.captionRegular),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildCoupons(String heading, String title, String subTitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(heading, style: AppTextStyles.subtitleMedium),
        SizedBox(height: Window.getVerticalSize(4)),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.local_offer_outlined),
          title: Text(title, style: AppTextStyles.bodyRegular),
          subtitle: Text(subTitle, style: AppTextStyles.captionRegular),
          // trailing: TextButton(
          //   onPressed: () {},
          //   child: Text(
          //     "Apply",
          //     style: AppTextStyles.bodyBold.copyWith(
          //       color: AppColors.primaryBlue100,
          //       fontSize: Window.getFontSize(12),
          //     ),
          //   ),
          // ),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildPaymentRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold ? AppTextStyles.bodyBold : AppTextStyles.bodyRegular,
        ),
        Text(
          value,
          style: isBold ? AppTextStyles.bodyBold : AppTextStyles.bodyRegular,
        ),
      ],
    );
  }
}
