import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:athlorun/config/styles/app_colors.dart';

class ShowImageSourceDialog extends StatelessWidget {
  final Function(ImageSource) onPickImage;

  const ShowImageSourceDialog({
    super.key,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.neutral10,
      title: const Text(
        'Choose Image Source',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryBlue90,
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onPickImage(ImageSource.camera);
              },
              icon: Icon(
                Icons.camera_alt,
                size: 50,
                color: Colors.grey.shade600,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onPickImage(ImageSource.gallery);
              },
              icon: Icon(
                Icons.photo_library,
                size: 50,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
