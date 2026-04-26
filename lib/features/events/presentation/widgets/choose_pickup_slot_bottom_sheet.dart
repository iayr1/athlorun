// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:athlorun/config/di/dependency_injection.dart';
// import 'package:athlorun/config/styles/app_colors.dart';
// import 'package:athlorun/config/styles/app_textstyles.dart';
// import 'package:athlorun/core/global_store/domain/usecases/get_user_auth_data_usecase.dart';
// import 'package:athlorun/core/utils/utils.dart';
// import 'package:athlorun/core/utils/windows.dart';
// import 'package:athlorun/core/widgets/custom_action_button.dart';
// import 'package:athlorun/features/events/data/models/response/get_events_response_model.dart';
// import 'package:athlorun/features/events/domain/usecases/booked_event_ticket_usecase.dart';
// import 'package:athlorun/features/events/domain/usecases/get_events_usecase.dart';
// import 'package:athlorun/features/events/presentation/bloc/events_page_cubit.dart';

// void showPickupSlotBottomSheet(
//   BuildContext context,
//   GetEventsResponseModelData getEventsResponseModelData,
// ) {
//   Slot? selectedSlot;

//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: AppColors.neutral10,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     builder: (context) {
//       return BlocProvider(
//         create: (context) => EventsPageCubit(
//           sl<GetEventsUsecase>(),
//           sl<GetUserAuthDataUsecase>(),
//           sl<BookedEventTicketUsecase>(),
//         ),
//         child: BlocBuilder<EventsPageCubit, EventsPageState>(
//           builder: (context, state) {
//             return Padding(
//               padding: MediaQuery.of(context).viewInsets,
//               child: StatefulBuilder(
//                 builder: (context, setState) {
//                   return Padding(
//                     padding: Window.getPadding(
//                         left: 16, right: 16, top: 20, bottom: 16),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         /// Header
//                         Row(
//                           children: [
//                             const Expanded(
//                               child: Text(
//                                 'Choose Slot ',
//                                 style: AppTextStyles.subtitleBold,
//                               ),
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.close),
//                               onPressed: () => Navigator.pop(context),
//                             ),
//                           ],
//                         ),

//                         Row(
//                           children:
//                               getEventsResponseModelData.slots!.map((slot) {
//                             final isSelected =
//                                 selectedSlot?.startTime == slot.startTime;
//                             return Expanded(
//                               child: GestureDetector(
//                                 onTap: () =>
//                                     setState(() => selectedSlot = slot),
//                                 child: Container(
//                                   margin: const EdgeInsets.only(right: 12),
//                                   padding:
//                                       const EdgeInsets.symmetric(vertical: 14),
//                                   alignment: Alignment.center,
//                                   decoration: BoxDecoration(
//                                     color: isSelected
//                                         ? AppColors.neutral100
//                                         : AppColors.neutral30,
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   child: Text(
//                                     "${Utils.formatTimeWithAMPM(slot.startTime!)} - ${Utils.formatTimeWithAMPM(slot.endTime!)}",
//                                     style: AppTextStyles.bodyBold.copyWith(
//                                       color: isSelected
//                                           ? Colors.white
//                                           : AppColors.neutral90,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                         ),

//                         SizedBox(height: Window.getVerticalSize(24)),

//                         /// Proceed Button
//                         CustomActionButton(
//                           name: "Continue",
//                           isFormFilled: selectedSlot != null,
//                           onTap: selectedSlot != null
//                               ? (start, stop, state) {
//                                   context
//                                       .read<EventsPageCubit>()
//                                       .addSlot(selectedSlot!);
//                                   Navigator.pop(context);
//                                   Utils.showTicketBookingBottomSheet(
//                                     context,
//                                     getEventsResponseModelData,
//                                   );
//                                 }
//                               : (start, stop, state) {},
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             );
//           },
//         ),
//       );
//     },
//   );
// }
