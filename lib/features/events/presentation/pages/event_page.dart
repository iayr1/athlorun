import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:athlorun/config/di/dependency_injection.dart';
import 'package:athlorun/config/images/app_images.dart';
import 'package:athlorun/config/routes/routes.dart';
import 'package:athlorun/config/styles/app_colors.dart';
import 'package:athlorun/config/styles/app_textstyles.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import 'package:athlorun/core/utils/utils.dart';
import 'package:athlorun/core/utils/windows.dart';
import 'package:athlorun/features/events/data/models/response/get_events_response_model.dart';
import 'package:athlorun/features/events/presentation/bloc/events_page_cubit.dart';
import 'package:athlorun/features/settings/presentation/pages/notification_setting_screen.dart';
import 'package:shimmer/shimmer.dart';

class EventPageWrapper extends StatelessWidget {
  const EventPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<EventsPageCubit>(),
      child: const EventPage(),
    );
  }
}

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final TextEditingController _searchController = TextEditingController();
  late EventsPageCubit _eventsPageCubit;
  final FocusNode _searchFocusNode = FocusNode();

  final List<Map<String, dynamic>> allEvents = [
    {
      "eventName": "TGIR Mumbai Edition",
      "eventDate": "09 Mar 2025",
      "eventLocation": "Mumbai",
      "isSoldOut": true,
      "isUpcoming": false,
    },
    {
      "eventName": "TGIR Ahmedabad Edition",
      "eventDate": "23 Mar 2025",
      "eventLocation": "Ahmedabad",
      "isSoldOut": false,
      "isUpcoming": false,
    },
    {
      "eventName": "TGIR Satara Edition",
      "eventDate": "30 Mar 2025",
      "eventLocation": "Satara",
      "isSoldOut": false,
      "isUpcoming": true,
    },
    {
      "eventName": "TGIR Bengaluru Edition",
      "eventDate": "06 Apr 2025",
      "eventLocation": "Bengaluru",
      "isSoldOut": false,
      "isUpcoming": true,
    },
  ];

  List<Widget> items = [
    Image.asset(AppImages.event1),
    Image.asset(AppImages.event1),
    Image.asset(AppImages.event1),
  ];

  List<GetEventsResponseModelData>? eventsList = [];

  @override
  void initState() {
    super.initState();
    _eventsPageCubit = context.read<EventsPageCubit>();
    _eventsPageCubit.getEvents();

    _searchController.addListener(() {
      setState(() {});
    });
  }

  List<GetEventsResponseModelData>? get _filteredList {
    return eventsList!.where((event) {
      final query = _searchController.text.toLowerCase();
      return event.title!.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral10,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location Row
                // Row(
                //   children: [
                //     const Icon(Icons.location_on_outlined, color: Colors.red),
                //     SizedBox(width: Window.getHorizontalSize(8)),
                //     Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Row(
                //           children: [
                //             Text("Saidham Nagar",
                //                 style: AppTextStyles.subtitleBold),
                //             const Icon(Icons.arrow_drop_down),
                //           ],
                //         ),
                //         Text("Parel, Mumbai",
                //             style: AppTextStyles.captionRegular
                //                 .copyWith(color: AppColors.neutral60)),
                //       ],
                //     ),
                //     const Spacer(),
                //     const CircleAvatar(
                //       backgroundColor: AppColors.neutral50,
                //       child: Icon(Icons.person_4_rounded, color: Colors.white),
                //     )
                //   ],
                // ),
                SizedBox(height: Window.getVerticalSize(16)),

                // Search Bar
                Padding(
                  padding: Window.getPadding(left: 16, right: 16),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    decoration: InputDecoration(
                      hintText: 'Search events...',
                      hintStyle: AppTextStyles.bodyRegular.copyWith(
                          color: AppColors.neutral50), // Custom hint text style
                      prefixIcon:
                          const Icon(Icons.search, color: AppColors.neutral100),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(Window.getRadiusSize(10)),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor:
                          AppColors.neutral20, // Use color from AppColors
                      contentPadding: Window.getMarginOrPadding(
                          all: 12), // Add responsive padding
                    ),
                  ),
                ),
                SizedBox(height: Window.getVerticalSize(16)),

                // Banner
                CarouselSlider(
                  items: items.map((item) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: item,
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 220,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.2,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                SizedBox(height: Window.getVerticalSize(24)),

                // Tickets Section
                Padding(
                  padding: Window.getPadding(left: 16, right: 16),
                  child: const Text(AppStrings.allEvents,
                      style: AppTextStyles.subtitleMedium),
                ),
                SizedBox(height: Window.getVerticalSize(12)),

                BlocBuilder<EventsPageCubit, EventsPageState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      loadingEvents: () {
                        return Padding(
                          padding: Window.getPadding(left: 16, right: 16),
                          child: const TicketRowSkeleton(),
                        );
                      },
                      loadedEvents: (events) {
                        final eventData = events;
                        eventsList = List.from(eventData.data!);

                        if (_filteredList!.isEmpty) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset(AppImages.noScheduleLottie,
                                      width: 150, height: 150),
                                  const SizedBox(height: 16),
                                  Text(
                                    AppStrings.noEventsAvailable,
                                    style: AppTextStyles.bodyRegular
                                        .copyWith(color: AppColors.neutral60),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return Padding(
                          padding: Window.getPadding(left: 16, right: 16),
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _filteredList!.length,
                            itemBuilder: (context, index) {
                              final event = _filteredList![index];

                              return SizedBox(
                                width: double.infinity,
                                child: TicketRowWidget(
                                  getEventsResponseModelData: event,
                                  eventName: event.title.toString(),
                                  eventDate:
                                      Utils.formatToDDMMMYYYY(event.date!),
                                  eventTime: event.startTime!,
                                  eventLocation: event.location!.address!,
                                  isSoldOut:
                                      event.slots!.isNotEmpty ? false : true,
                                  isUpcoming: false,
                                ),
                              );
                            },
                          ),
                        );
                      },
                      orElse: () {
                        return Container();
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TicketRowWidget extends StatelessWidget {
  final String eventName;
  final String eventDate;
  final String eventTime;
  final String eventLocation;
  final bool isSoldOut;
  final bool isUpcoming;
  final GetEventsResponseModelData getEventsResponseModelData;

  const TicketRowWidget({
    super.key,
    required this.eventName,
    required this.eventDate,
    required this.eventTime,
    required this.eventLocation,
    this.isSoldOut = false,
    this.isUpcoming = false,
    required this.getEventsResponseModelData,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.matchDetailsPage,
            arguments: getEventsResponseModelData);
      },
      child: Container(
        margin: Window.getMarginOrPadding(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(12),
            bottom: Radius.circular(12),
          ),
          color: AppColors.neutral10,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image with overlay text
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                    bottom: Radius.circular(12),
                  ),
                  child: CachedNetworkImage(
                    height: Window.getVerticalSize(250),
                    width: double.infinity,
                    fit: BoxFit.cover,
                    imageUrl: getEventsResponseModelData.banner!,
                  ),
                ),

                // Gradient overlay (bottom fade)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 220,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                        bottom: Radius.circular(12),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // Text Overlay
                Positioned(
                  bottom: 80,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eventName.toCapitalized,
                        style: AppTextStyles.bodyBold.copyWith(
                          color: Colors.white,
                          fontSize: 20,
                          shadows: [
                            const Shadow(color: Colors.black54, blurRadius: 4),
                          ],
                        ),
                      ),
                      SizedBox(height: Window.getVerticalSize(2)),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 14, color: Colors.white70),
                          SizedBox(width: Window.getHorizontalSize(6)),
                          Text(
                            "$eventDate | ${Utils.formatTimeWithAMPM(eventTime)}",
                            style: AppTextStyles.captionRegular.copyWith(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Window.getVerticalSize(2)),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 14, color: Colors.white70),
                          SizedBox(width: Window.getHorizontalSize(6)),
                          Text(
                            eventLocation,
                            style: AppTextStyles.captionRegular.copyWith(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Positioned(
                  bottom: 10,
                  left: 16,
                  right: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.neutral10,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Price
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 16),
                            child: Text(
                              "₹ ${getEventsResponseModelData.price!}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        // Divider
                        Container(
                          height: 30,
                          width: 1,
                          color: AppColors.neutral40,
                        ),

                        // Book Now Button
                        Expanded(
                          child: InkWell(
                            onTap: isSoldOut
                                ? null
                                : () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.matchDetailsPage,
                                      arguments: getEventsResponseModelData,
                                    );
                                  },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              alignment: Alignment.center,
                              child: Text(
                                isSoldOut ? "Sold Out" : "Book Now",
                                style: AppTextStyles.bodyBold.copyWith(
                                  color: AppColors.primaryBlue100,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Price and Book Now Button
          ],
        ),
      ),
    );
  }
}

class TicketRowSkeleton extends StatelessWidget {
  const TicketRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: EdgeInsets.only(bottom: Window.getVerticalSize(16)),
        padding: Window.getPadding(all: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Window.getRadiusSize(12)),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Title
            Row(
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(width: Window.getHorizontalSize(8)),
                Expanded(
                  child: Container(
                    height: 16,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
            SizedBox(height: Window.getVerticalSize(8)),

            // Location
            Container(
              height: 14,
              width: 100,
              color: Colors.grey[400],
            ),
            SizedBox(height: Window.getVerticalSize(4)),
            Container(
              height: 14,
              width: 120,
              color: Colors.grey[400],
            ),
            SizedBox(height: Window.getVerticalSize(4)),
            Container(
              height: 14,
              width: 80,
              color: Colors.grey[400],
            ),
            SizedBox(height: Window.getVerticalSize(12)),

            // Action Button
            Row(
              children: [
                Container(
                  width: 80,
                  height: 16,
                  color: Colors.grey[400],
                ),
                const Spacer(),
                Container(
                  width: 130,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius:
                        BorderRadius.circular(Window.getRadiusSize(12)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
