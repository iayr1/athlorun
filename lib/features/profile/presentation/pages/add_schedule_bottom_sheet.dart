import 'package:flutter/material.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/windows.dart';
import '../../../../core/widgets/custom_action_button.dart';

class AddScheduleBottomSheet extends StatefulWidget {
  const AddScheduleBottomSheet({super.key});

  @override
  State<AddScheduleBottomSheet> createState() =>
      _AddScheduleBottomSheetState();
}

class _AddScheduleBottomSheetState extends State<AddScheduleBottomSheet> {
  final TextEditingController controller = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  bool get isFilled =>
      controller.text.isNotEmpty &&
      selectedDate != null &&
      selectedTime != null;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Add Schedule", style: AppTextStyles.heading5Bold),

          const SizedBox(height: 20),

          TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Enter name"),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    selectedDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                      initialDate: DateTime.now(),
                    );
                    setState(() {});
                  },
                  child: Text(selectedDate == null
                      ? "Select Date"
                      : selectedDate.toString().split(" ")[0]),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    setState(() {});
                  },
                  child: Text(selectedTime == null
                      ? "Select Time"
                      : selectedTime!.format(context)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          CustomActionButton(
            name: "Save",
            isFormFilled: isFilled,
            onTap: (s, st, b) {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}