import 'package:flutter/material.dart';
import '../../../../core/utils/windows.dart';

class KeepWalkingWidget extends StatelessWidget {
  const KeepWalkingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          "assets/keepwalking.png",
          height: Window.getVerticalSize(100),
          width: Window.getVerticalSize(200),
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}
