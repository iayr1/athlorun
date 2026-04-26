import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:athlorun/config/di/dependency_injection.dart';
import 'package:athlorun/config/images/app_images.dart';
import 'package:athlorun/config/styles/app_colors.dart';
import 'package:athlorun/config/styles/app_textstyles.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import 'package:athlorun/core/utils/utils.dart';
import 'package:athlorun/core/utils/windows.dart';
import 'package:athlorun/core/widgets/custom_action_button.dart';
import 'package:athlorun/features/events/data/models/response/get_events_response_model.dart';
import 'package:athlorun/features/events/presentation/bloc/events_page_cubit.dart';
import 'package:athlorun/features/events/presentation/widgets/expansion_tile_widget.dart';
import 'package:athlorun/features/events/presentation/widgets/ticket_booking_bottomsheet.dart';
import 'package:athlorun/features/settings/presentation/pages/notification_setting_screen.dart';

class EventDetailsPageWrapper extends StatefulWidget {
  final GetEventsResponseModelData getEventsResponseModelData;

  const EventDetailsPageWrapper(
      {super.key, required this.getEventsResponseModelData});

  @override
  State<EventDetailsPageWrapper> createState() =>
      _EventDetailsPageWrapperState();
}

class _EventDetailsPageWrapperState extends State<EventDetailsPageWrapper> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<EventsPageCubit>(),
      child: EventDetailsPage(
          getEventsResponseModelData: widget.getEventsResponseModelData),
    );
  }
}

class EventDetailsPage extends StatefulWidget {
  final GetEventsResponseModelData getEventsResponseModelData;
  const EventDetailsPage({super.key, required this.getEventsResponseModelData});

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  String? expandedTile = "";
  Slot? selectedSlot;
  late EventsPageCubit _eventsPageCubit;

  @override
  void initState() {
    _eventsPageCubit = context.read<EventsPageCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final eventsData = widget.getEventsResponseModelData;
    final latitude = eventsData.location!.coordinate!.coordinates!.first;
    final longitude = eventsData.location!.coordinate!.coordinates!.last;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.neutral10,
        bottomNavigationBar: Container(
          padding: Window.getSymmetricPadding(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: AppColors.neutral10,
            border: Border(top: BorderSide(color: AppColors.neutral30)),
          ),
          child: Row(
            children: [
              Text(
                "${AppStrings.rupee} ${eventsData.price.toString()}",
                style: AppTextStyles.subtitleSemiBold,
              ),
              const Spacer(),
              SizedBox(
                width: Window.getHorizontalSize(150),
                height: Window.getVerticalSize(48),
                child: CustomActionButton(
                  onTap: selectedSlot != null
                      ? (startLoading, stopLoading, btnState) {
                          TicketBookingBottomSheet.show(
                            context: context,
                            getEventsResponseModelData:
                                widget.getEventsResponseModelData,
                            slot: selectedSlot,
                          );
                        }
                      : (startLoading, stopLoading, btnState) {
                          Utils.showCustomDialog(
                            context,
                            AppStrings.error,
                            "Please select your preferred slot.",
                          );
                        },
                  name: AppStrings.bookTickets,
                  isFormFilled: selectedSlot != null,
                ),
              )
            ],
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🎈 Banner
                  ClipRRect(
                    child: CachedNetworkImage(
                      height: Window.getVerticalSize(350),
                      width: double.infinity,
                      imageUrl: eventsData.banner.toString(),
                      fit: BoxFit.cover,
                    ),
                  ),

                  Padding(
                    padding: Window.getPadding(all: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 🏷 Title
                        Text(
                          eventsData.title.toString().toCapitalized,
                          style: AppTextStyles.heading5Bold,
                        ),

                        SizedBox(height: Window.getVerticalSize(16)),

                        /// 📅 Date and Time
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined, size: 18),
                            SizedBox(width: Window.getHorizontalSize(8)),
                            // "Sun, 09 Mar • 7:00 AM onwards"
                            Text(
                              "${Utils.formatToDayMonth(eventsData.date.toString())} • ${Utils.formatTimeWithAMPM(eventsData.startTime.toString())} Onwords",
                              style: AppTextStyles.bodyRegular,
                            ),
                          ],
                        ),

                        SizedBox(height: Window.getVerticalSize(12)),

                        /// 📍 Location
                        GestureDetector(
                          onTap: () {
                            Utils.openMap(latitude, longitude);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 18,
                                  ),
                                  SizedBox(width: Window.getHorizontalSize(8)),
                                  Text(
                                    eventsData.location!.address.toString(),
                                    style: AppTextStyles.bodyRegular,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  SvgPicture.asset(
                                    AppImages.googleMap,
                                    width: 18,
                                  ),
                                  const Text(
                                    "Get Directions",
                                    style: AppTextStyles.overlineRegular,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        // SizedBox(height: Window.getVerticalSize(4)),
                        // Padding(
                        //   padding: EdgeInsets.only(left: Window.getHorizontalSize(28)),
                        //   child: Text("Just 5 km from your location",
                        //       style: AppTextStyles.captionRegular
                        //           .copyWith(color: AppColors.neutral50)),
                        // ),

                        SizedBox(height: Window.getVerticalSize(10)),

                        Container(
                          padding: Window.getPadding(all: 12),
                          decoration: BoxDecoration(
                            color: AppColors.neutral20.withOpacity(.7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// 📘 About Event
                              const Text(
                                "About the event",
                                style: AppTextStyles.subtitleBold,
                              ),
                              SizedBox(height: Window.getVerticalSize(5)),
                              Text(
                                eventsData.description.toString(),
                                style: AppTextStyles.bodyRegular
                                    .copyWith(color: AppColors.neutral90),
                              ),
                              // TextButton(
                              //   onPressed: () {},
                              //   child: Text("Read more",
                              //       style: AppTextStyles.captionBold
                              //           .copyWith(decoration: TextDecoration.underline)),
                              // ),

                              SizedBox(height: Window.getVerticalSize(16)),

                              /// 🔍 Key Info
                              _buildDetailRow(
                                  Icons.schedule_outlined,
                                  "Duration",
                                  Utils.calculateEventDuration(
                                      eventsData.startTime!,
                                      eventsData.endTime!)),
                              SizedBox(height: Window.getVerticalSize(12)),
                              _buildDetailRow(Icons.confirmation_num_outlined,
                                  "Participation", eventsData.participation!),
                              SizedBox(height: Window.getVerticalSize(12)),
                              _buildDetailRow(Icons.directions_run_outlined,
                                  "Obstacles", eventsData.obstacles!),
                              SizedBox(height: Window.getVerticalSize(12)),
                              _buildDetailRow(
                                  Icons.grade_outlined,
                                  "Endurance Level",
                                  eventsData.enduranceLevel!),
                            ],
                          ),
                        ),
                        SizedBox(height: Window.getVerticalSize(12)),

                        if (widget
                                .getEventsResponseModelData.slots?.isNotEmpty ??
                            false) ...[
                          const Text(
                            "Choose your preferred slot",
                            style: AppTextStyles.subtitleMedium,
                          ),
                          SizedBox(height: Window.getVerticalSize(8)),
                          Row(
                            children:
                                widget.getEventsResponseModelData.slots!.map(
                              (slot) {
                                final isSelected =
                                    selectedSlot?.startTime == slot.startTime;
                                return Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(
                                        () {
                                          selectedSlot = slot;
                                          debugPrint(
                                              "Selected slot: ${selectedSlot?.startTime} - ${selectedSlot?.endTime}");
                                        },
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 12),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.neutral100
                                            : AppColors.neutral30,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        "${Utils.formatTimeWithAMPM(slot.startTime!)} - ${Utils.formatTimeWithAMPM(slot.endTime!)}",
                                        style: AppTextStyles.bodyBold.copyWith(
                                          color: isSelected
                                              ? Colors.white
                                              : AppColors.neutral90,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        ],

                        SizedBox(height: Window.getVerticalSize(12)),
                        const Text("More", style: AppTextStyles.subtitleMedium),
                        SizedBox(height: Window.getVerticalSize(8)),

                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              ExpansionTileWidget(
                                id: 'faq',
                                title: "Frequently asked questions",
                                icon: Icons.help_outline,
                                expandedTile: expandedTile,
                                onExpansionChanged: (value) {
                                  setState(() {
                                    expandedTile = value ? 'faq' : null;
                                  });
                                },
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 4),
                                    child: Text(
                                      "• What should I bring?\n• Are pets allowed?\n• What’s the refund policy?",
                                      style: AppTextStyles.captionRegular,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: Window.getVerticalSize(8)),
                              ExpansionTileWidget(
                                id: 'terms',
                                title: "Terms and conditions",
                                icon: Icons.description_outlined,
                                expandedTile: expandedTile,
                                onExpansionChanged: (value) {
                                  setState(() {
                                    expandedTile = value ? 'terms' : null;
                                  });
                                },
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8),
                                    child: Text(
                                      "By purchasing a ticket, you agree to comply with event rules and safety guidelines...",
                                      style: AppTextStyles.captionRegular,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: Window.getVerticalSize(16)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 56,
              left: 16,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.neutral90,
          size: 18,
        ),
        SizedBox(width: Window.getHorizontalSize(8)),
        Text(
          "$label: ",
          style: AppTextStyles.bodyRegular,
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium,
        ),
      ],
    );
  }
}
