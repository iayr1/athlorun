// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:athlorun/config/di/dependency_injection.dart';
// import 'package:athlorun/config/routes/routes.dart';
// import 'package:athlorun/core/global_store/data/models/user_data_progress_model.dart';
// import 'package:athlorun/features/account_registration/presentation/bloc/account_registration_cubit.dart';
// import '../../../../../core/utils/windows.dart';
// import '../../../../../core/widgets/linear_progress_indicator.dart';
// import 'package:athlorun/core/widgets/back_button_widget.dart';
// import 'package:athlorun/core/widgets/next_button_widget.dart';
// import '../../../../../config/styles/app_colors.dart';
// import '../../../../../config/styles/app_textstyles.dart';

// class SetupReminderScreenWrapper extends StatelessWidget {
//   const SetupReminderScreenWrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => sl<AccountRegistrationCubit>(),
//       child: const SetupReminderScreen(),
//     );
//   }
// }

// class SetupReminderScreen extends StatefulWidget {
//   const SetupReminderScreen({super.key});

//   @override
//   State<SetupReminderScreen> createState() => _SetupReminderScreenState();
// }

// class _SetupReminderScreenState extends State<SetupReminderScreen> {
//   FixedExtentScrollController hourController =
//       FixedExtentScrollController(initialItem: 10);
//   FixedExtentScrollController minuteController =
//       FixedExtentScrollController(initialItem: 20);
//   FixedExtentScrollController periodController =
//       FixedExtentScrollController(initialItem: 0);

//   late final AccountRegistrationCubit _cubit;
//   late UserDataProgressModel _userDataProgressModel;
//   @override
//   void initState() {
//     _cubit = context.read<AccountRegistrationCubit>();
//     super.comitState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     _userDataProgressModel =
//         ModalRoute.of(context)!.settings.arguments as UserDataProgressModel;
//     return PopScope(
//       canPop: false,
//       child: Scaffold(
//         backgroundColor: AppColors.neutral10,
//         body: Padding(
//           padding: Window.getSymmetricPadding(horizontal: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(height: Window.getVerticalSize(50)),
//               const ProgressBarWidget(
//                   currentScreen: 8, totalScreens: 8, stepText: "8 - "),
//               SizedBox(height: Window.getVerticalSize(30)),
//               Center(
//                 child: Text(
//                   'Set Reminder',
//                   style: AppTextStyles.heading4SemiBold.copyWith(
//                     fontSize: Window.getFontSize(22),
//                     color: AppColors.neutral100,
//                   ),
//                 ),
//               ),
//               SizedBox(height: Window.getVerticalSize(10)),
//               Center(
//                 child: Text(
//                   'Set your reminder to keep you still\non progress',
//                   textAlign: TextAlign.center,
//                   style: AppTextStyles.subtitleRegular.copyWith(
//                     fontSize: Window.getFontSize(16),
//                     color: AppColors.neutral70,
//                   ),
//                 ),
//               ),
//               // Time Picker
//               Expanded(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     _buildTimePicker(hourController, 12, "hour"),
//                     Text(
//                       ':',
//                       style: AppTextStyles.heading2Bold.copyWith(
//                         fontSize: Window.getFontSize(32),
//                         color: AppColors.neutral70,
//                       ),
//                     ),
//                     _buildTimePicker(minuteController, 60, "minute"),
//                     SizedBox(width: Window.getHorizontalSize(16)),
//                     _buildTimePicker(periodController, 2, "period"),
//                   ],
//                 ),
//               ),
//               BlocListener<AccountRegistrationCubit, AccountRegistrationState>(
//                 listener: (context, state) {
//                   state.maybeWhen(
//                     loadedUserData: (authData, userData) {
//                       _userDataProgressModel.phoneNumber =
//                           userData.phoneNumber ?? "";
//                       _userDataProgressModel.reminder = getTime();
//                       _cubit.patchUserData(authData.id, authData.accessToken,
//                           _userDataProgressModel);
//                     },
//                     loadUserDataError: (error) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(
//                             error,
//                             style: AppTextStyles.bodyRegular.copyWith(
//                               color: AppColors.neutral10,
//                             ),
//                           ),
//                           backgroundColor: AppColors.primaryBlue100,
//                         ),
//                       );
//                     },
//                     patchedUserData: (userData) {
//                       _cubit.setUserDataProgreessModel(_userDataProgressModel);
//                     },
//                     patchUserDataError: (error) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(
//                             error,
//                             style: AppTextStyles.bodyRegular.copyWith(
//                               color: AppColors.neutral10,
//                             ),
//                           ),
//                           backgroundColor: AppColors.primaryBlue100,
//                         ),
//                       );
//                     },
//                     gotAuthData: (authData) {
//                       _cubit.getUserData(authData);
//                     },
//                     getAuthDataError: (error) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(
//                             error,
//                             style: AppTextStyles.bodyRegular.copyWith(
//                               color: AppColors.neutral10,
//                             ),
//                           ),
//                           backgroundColor: AppColors.primaryBlue100,
//                         ),
//                       );
//                     },
//                     setUserProgressData: (progressData) {
//                       Navigator.pushNamedAndRemoveUntil(
//                         context,
//                         AppRoutes.dashboardScreen,
//                         (route) => false,
//                       );
//                     },
//                     setUserProgressDataError: (error) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(
//                             error,
//                             style: AppTextStyles.bodyRegular.copyWith(
//                               color: AppColors.neutral10,
//                             ),
//                           ),
//                           backgroundColor: AppColors.primaryBlue100,
//                         ),
//                       );
//                     },
//                     orElse: () {},
//                   );
//                 },
//                 child: SizedBox(
//                   height: Window.getVerticalSize(100),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       BackButtonWidget(onPressed: () {
//                         Navigator.pushNamedAndRemoveUntil(
//                           context,
//                           AppRoutes.setupProfilePhotoScreen,
//                           (routes) => false,
//                           arguments: _userDataProgressModel,
//                         );
//                       }),
//                       NextButtonWidget(
//                         text: "Let's Start",
//                         onPressed: () {
//                           _cubit.getAuthData();
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTimePicker(
//       FixedExtentScrollController controller, int itemCount, String type) {
//     return SizedBox(
//       width: Window.getHorizontalSize(70),
//       height: Window.getVerticalSize(150),
//       child: ListWheelScrollView.useDelegate(
//         controller: controller,
//         itemExtent: Window.getVerticalSize(60),
//         physics: const FixedExtentScrollPhysics(),
//         perspective: 0.003,
//         onSelectedItemChanged: (index) {
//           setState(() {});
//         },
//         childDelegate: ListWheelChildBuilderDelegate(
//           builder: (context, index) {
//             final displayValue = _getDisplayValue(index, itemCount, type);
//             final isSelected = controller.selectedItem == index;
//             return Center(
//               child: Text(
//                 displayValue,
//                 style: AppTextStyles.heading4SemiBold.copyWith(
//                   fontSize: Window.getFontSize(isSelected ? 36 : 20),
//                   color: isSelected
//                       ? AppColors.primaryBlue100
//                       : AppColors.neutral30,
//                 ),
//               ),
//             );
//           },
//           childCount: itemCount,
//         ),
//       ),
//     );
//   }

//   String _getDisplayValue(int index, int itemCount, String type) {
//     if (type == "hour") {
//       return (index % 12 == 0 ? 12 : index % 12).toString().padLeft(2, '0');
//     } else if (type == "minute") {
//       return index.toString().padLeft(2, '0');
//     } else if (type == "period") {
//       return index == 0 ? "AM" : "PM";
//     }
//     return "";
//   }

//   String getTime() {
//     String hour = (hourController.selectedItem % 12 == 0
//             ? 12
//             : hourController.selectedItem % 12)
//         .toString()
//         .padLeft(2, '0');
//     String minute = minuteController.selectedItem.toString().padLeft(2, '0');
//     String meridian = periodController.selectedItem == 0 ? "AM" : "PM";
//     DateFormat inputFormat = DateFormat("hh:mm:a");
//     DateFormat format24Hour = DateFormat("HH:mm");
//     String time24Hour = format24Hour
//         .format(inputFormat.parse("$hour:$minute:$meridian").toLocal());
//     return "$time24Hour:00";
//   }

//   @override
//   void dispose() {
//     hourController.dispose();
//     minuteController.dispose();
//     periodController.dispose();
//     super.dispose();
//   }
// }
