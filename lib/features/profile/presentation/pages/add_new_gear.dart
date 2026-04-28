import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';
import '../../../../core/widgets/custom_action_button.dart';

class AddGearScreen extends StatefulWidget {
  const AddGearScreen({super.key});

  @override
  State<AddGearScreen> createState() => _AddGearScreenState();
}

class _AddGearScreenState extends State<AddGearScreen> {
  final _formKey = GlobalKey<FormState>();

  String? selectedGearType;
  String? selectedSport;

  String brand = "";
  String model = "";
  String weight = "";

  File? gearImage;

  final List<String> gearTypes = ["Shoes", "Cycle", "Watch"];
  final List<String> sports = ["Running", "Cycling", "Gym"];

  bool get isFormFilled =>
      selectedGearType != null &&
      selectedSport != null &&
      brand.isNotEmpty &&
      model.isNotEmpty &&
      weight.isNotEmpty &&
      gearImage != null;

  Future<void> pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked != null) {
      setState(() {
        gearImage = File(picked.path);
      });
    }
  }

  void showImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text("Camera"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void saveGear() {
    if (_formKey.currentState!.validate() && isFormFilled) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral10,
      appBar: AppBar(
        title: const Text("Add Gear"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: Window.getSymmetricPadding(horizontal: 16),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      SizedBox(height: Window.getVerticalSize(20)),

                      /// Gear Type
                      _dropdown("Gear Type", gearTypes, selectedGearType,
                          (val) {
                        setState(() => selectedGearType = val);
                      }),

                      SizedBox(height: Window.getVerticalSize(16)),

                      /// Sport
                      _dropdown("Sport", sports, selectedSport, (val) {
                        setState(() => selectedSport = val);
                      }),

                      SizedBox(height: Window.getVerticalSize(16)),

                      _textField("Brand", (val) => brand = val),
                      _textField("Model", (val) => model = val),
                      _textField("Weight", (val) => weight = val,
                          isNumber: true),

                      SizedBox(height: Window.getVerticalSize(24)),

                      /// Image Picker
                      GestureDetector(
                        onTap: showImagePicker,
                        child: Container(
                          height: 180,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: gearImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    gearImage!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.image, size: 40),
                                    Text("Select Image"),
                                  ],
                                ),
                        ),
                      ),

                      SizedBox(height: Window.getVerticalSize(80)),
                    ],
                  ),
                ),
              ),
            ),

            /// Button
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: Window.getPadding(all: 16),
                child: CustomActionButton(
                  name: "Save Gear",
                  isFormFilled: isFormFilled,
                  onTap: (s, st, b) => saveGear(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textField(String label, Function(String) onChanged,
      {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: TextFormField(
        keyboardType:
            isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: onChanged,
        validator: (val) =>
            val == null || val.isEmpty ? "Required" : null,
      ),
    );
  }

  Widget _dropdown(String label, List<String> items, String? value,
      Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.subtitleMedium),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.neutral100),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            hint: const Text("Select"),
            underline: const SizedBox(),
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}