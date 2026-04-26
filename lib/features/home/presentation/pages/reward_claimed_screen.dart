import 'dart:io';
import 'package:argon_buttons_flutter_fix/argon_buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:athlorun/config/images/app_images.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import 'package:athlorun/core/utils/utils.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';
import '../../../../core/widgets/custom_action_button.dart';

class RewardClaimedScreen extends StatelessWidget {
  const RewardClaimedScreen({super.key});

  Future<File> _getTemporaryFileFromAsset(
      String assetPath, String filename) async {
    final byteData = await rootBundle.load(assetPath);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$filename');
    return file.writeAsBytes(byteData.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.all(Window.getHorizontalSize(12)),
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: AppColors.neutral100,
                    size: Window.getFontSize(30),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    AppImages.congratulations,
                    width: Window.getHorizontalSize(300),
                    height: Window.getHorizontalSize(300),
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: Window.getVerticalSize(20)),
                Text(
                  AppStrings.congratulations,
                  style: AppTextStyles.heading3Bold.copyWith(
                    color: AppColors.neutral100,
                    fontSize: Window.getFontSize(24),
                  ),
                ),
                SizedBox(height: Window.getVerticalSize(10)),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Window.getHorizontalSize(20),
                  ),
                  child: Text(
                    AppStrings.yourRewarSuccessfullyClaimed,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyRegular.copyWith(
                      color: AppColors.neutral50,
                      fontSize: Window.getFontSize(16),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Window.getHorizontalSize(16),
                ),
                child: CustomActionButton(
                  name: AppStrings.share,
                  isFormFilled: true,
                  onTap: (startLoading, stopLoading, btnState) async {
                    if (btnState == ButtonState.Idle) {
                      startLoading();
                      try {
                        final tempFile = await _getTemporaryFileFromAsset(
                          AppImages.congratulations,
                          'congratulations.png',
                        );

                        final box = context.findRenderObject() as RenderBox?;
                        await Share.shareXFiles(
                          [XFile(tempFile.path)],
                          text: AppStrings
                              .congratulationsYourRewardSuccessfulyyClaimed,
                          sharePositionOrigin:
                              box!.localToGlobal(Offset.zero) & box.size,
                        );
                        stopLoading();
                      } catch (e) {
                        stopLoading();
                        Utils.showCustomDialog(context, AppStrings.error,
                            AppStrings.failedToShare);
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
