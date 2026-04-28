import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:athlorun/config/images/app_images.dart';
import 'package:athlorun/config/styles/app_colors.dart';
import 'package:athlorun/config/styles/app_textstyles.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import 'package:athlorun/core/utils/windows.dart';
import 'package:styled_divider/styled_divider.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static Future<void> debugLog(String string) async {
    if (kDebugMode) {
      log("DEBUG: $string");
    }
  }

  static Future<void> showCustomDialog(
    BuildContext context,
    String title,
    String? body, {
    void Function()? onOkay,
  }) async {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return ClipRRect(
          child: Container(
            width: Window.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Window.getHorizontalSize(40)),
                  topRight: Radius.circular(Window.getHorizontalSize(40))),
            ),
            child: Padding(
              padding: Window.getPadding(left: 20, right: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Window.getVerticalSize(30)),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: Window.getFontSize(20),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: Window.getVerticalSize(20)),
                  Text(
                    body!,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: Window.getVerticalSize(20)),
                  GestureDetector(
                    onTap: onOkay ??
                        () {
                          Navigator.pop(context);
                        },
                    child: Container(
                      width: Window.width,
                      height: Window.getVerticalSize(50),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text("Close",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  SizedBox(height: Window.getVerticalSize(15)),
                ],
              ),
            ),
          ),
        );
      },
    );
    HapticFeedback.vibrate();
  }

  // showCustomDatePicker
  static Future<DateTime?> showCustomDatePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    return await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(2000),
      lastDate: lastDate ?? DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.neutral30,
              onPrimary: Colors.black,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
            ),
            indicatorColor: AppColors.neutral30,
          ),
          child: child!,
        );
      },
    );
  }

  // showCustomTimePicker
  static Future<TimeOfDay?> showCustomTimePicker({
    required BuildContext context,
    TimeOfDay? initialTime,
  }) async {
    final TimeOfDay now = TimeOfDay.now();

    return await showTimePicker(
      context: context,
      initialTime: initialTime ?? now,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.neutral30,
              onPrimary: Colors.black,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  static Future<void> showCustomDeleteDialog(
    BuildContext context,
    String title,
    String content,
    VoidCallback onConfirm,
  ) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                AppStrings.cancel,
                style: TextStyle(color: AppColors.primaryBlue100),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onConfirm();
              },
              child: const Text(AppStrings.delete,
                  style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmText,
    required VoidCallback onConfirm,
    Color confirmColor = AppColors.primaryBlue100,
  }) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.neutral10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            title,
            style: AppTextStyles.heading5Bold,
          ),
          content: Text(
            message,
            style:
                AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral60),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: confirmColor,
              ),
              onPressed: () {
                Navigator.pop(context); // Close dialog
                onConfirm(); // Trigger action
              },
              child: Text(
                confirmText,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showLeaveChallengeDialog({
    required BuildContext context,
    required VoidCallback onConfirm,
  }) async {
    showModalBottomSheet(
      backgroundColor: AppColors.neutral10,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: Window.getVerticalSize(12),
              ),
              Container(
                height: 5,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: AppColors.neutral30,
                ),
              ),
              SizedBox(height: Window.getVerticalSize(18)),
              CircleAvatar(
                backgroundColor: Colors.red.shade300,
                child: const Icon(
                  Icons.logout_outlined,
                  color: AppColors.neutral10,
                ),
              ),
              SizedBox(height: Window.getVerticalSize(18)),
              const Text(AppStrings.leaveChallenege,
                  style: AppTextStyles.heading5Bold),
              SizedBox(
                height: Window.getVerticalSize(18),
              ),
              const Text(
                AppStrings.areYouSureWantToLeaveChallenge,
                style: AppTextStyles.bodyRegular,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: Window.getVerticalSize(20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: Window.getHorizontalSize(150),
                    height: Window.getVerticalSize(48),
                    decoration: BoxDecoration(
                        color: AppColors.neutral30,
                        borderRadius: BorderRadius.circular(50)),
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(AppStrings.stayIn,
                          style: AppTextStyles.subtitleBold.copyWith(
                            color: AppColors.neutral70,
                          )),
                    ),
                  ),
                  Container(
                    width: Window.getHorizontalSize(150),
                    height: Window.getVerticalSize(48),
                    decoration: BoxDecoration(
                        color: AppColors.primaryBlue100,
                        borderRadius: BorderRadius.circular(50)),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onConfirm();
                      },
                      child: Text(AppStrings.leave,
                          style: AppTextStyles.subtitleBold
                              .copyWith(color: AppColors.neutral10)),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: Window.getVerticalSize(20),
              ),
            ],
          ),
        );
      },
    );
  }

  // Format date to 'EEEE, dd MMM' (e.g., "Monday, 05 Feb")
  static String formatToDayMonth(String? date) {
    if (date == null) return '';
    return DateFormat('EEEE, dd MMM').format(DateTime.parse(date));
  }

  // Format date to 'yyyy-MM-dd' (for API requests or filtering)
  static String formatToYYYYMMDD(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // Format date to 'dd/MM/yyyy' (for display purposes)
  static String formatToDDMMYYYY(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  // Format date to 'dd/MMM/yyyy'
  static String formatToDDMMMYYYY(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String formatTimeWithAMPM(String timeIn24HrFormat) {
    try {
      // Parse the 24-hour format string into a DateTime object
      final DateTime time = DateFormat("HH:mm:ss").parse(timeIn24HrFormat);
      // Format it into 12-hour format with AM/PM
      return DateFormat("hh:mm a").format(time);
    } catch (e) {
      // Return the original time in case of any error (e.g., invalid format)
      return timeIn24HrFormat;
    }
  }

  static String calculateEventDuration(String startTime, String endTime) {
    try {
      // Parse the 24-hour format strings into DateTime objects
      final DateTime start = DateFormat("HH:mm:ss").parse(startTime);
      final DateTime end = DateFormat("HH:mm:ss").parse(endTime);

      // Calculate the duration
      Duration duration = end.difference(start);

      // Format duration as hours and minutes
      int hours = duration.inHours;
      int minutes = duration.inMinutes.remainder(60);

      // Return formatted duration
      return '${hours}h ${minutes}m';
    } catch (e) {
      return 'Invalid time format';
    }
  }

  //formatting date into Mar 01 - 31
  static String formatChallengeDate(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) return '';

    String startMonth = Utils.formatToDDMMMYYYY(startDate).split(" ")[1];
    String startDay = Utils.formatToDDMMMYYYY(startDate).split(" ")[0];
    String endDay = Utils.formatToDDMMMYYYY(endDate).split(" ")[0];

    return "$startMonth $startDay - $endDay";
  }

  static int calculateDaysLeft(DateTime? endDate) {
    if (endDate == null) return -1; // Use -1 to represent "Expired"

    DateTime currentDate = DateTime.now();
    int daysLeft = endDate.difference(currentDate).inDays;

    if (daysLeft == 0) return 0; // Represent "Last day" with 0
    return daysLeft > 0 ? daysLeft + 1 : -1; // -1 for "Expired"
  }

  //show error if some error occurs
  static Widget showError({String? errorMsg}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Image.asset(
              AppImages.somethingWentWrong,
              color: AppColors.primaryBlue80,
              width: 150,
            ),
            Text(
              AppStrings.errorLoadingChallenges,
              style: AppTextStyles.bodySemiBold.copyWith(
                color: AppColors.neutral50,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  static buildTextField({
    required String label,
    required String hintlabel,
    required String initialValue,
    required void Function(String) onChanged,
    required void Function(String?) onSaved,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:
              AppTextStyles.subtitleBold.copyWith(color: AppColors.neutral80),
        ),
        SizedBox(height: Window.getVerticalSize(5)),
        TextFormField(
          initialValue: initialValue,
          decoration: InputDecoration(
            hintText: hintlabel,
            hintStyle:
                AppTextStyles.bodyRegular.copyWith(color: AppColors.neutral50),
            filled: true,
            fillColor: AppColors.neutral20,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(
                Window.getRadiusSize(8.0),
              ),
            ),
          ),
          onChanged: onChanged,
          onSaved: onSaved,
          validator: validator,
          keyboardType: keyboardType,
        ),
      ],
    );
  }

  static Future<void> openMap(double latitude, double longitude) async {
    final Uri mapUri =
        Uri.parse('geo:$latitude,$longitude?q=$latitude,$longitude');

    if (await canLaunchUrl(mapUri)) {
      await launchUrl(mapUri);
    } else {
      // Fallback to Google Maps URL
      final Uri googleMapsUri = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');

      if (await canLaunchUrl(googleMapsUri)) {
        await launchUrl(googleMapsUri);
      } else {
        throw 'Could not open the map.';
      }
    }
  }

  static dottedDivider() {
    return const StyledDivider(
      color: AppColors.neutral40,
      height: 15,
      thickness: 2,
      lineStyle: DividerLineStyle.dotted,
    );
  }
}
