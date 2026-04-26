import 'package:flutter/material.dart';
import 'package:athlorun/config/styles/app_colors.dart';
import 'package:athlorun/config/styles/app_textstyles.dart';

class customAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final Color? arrowColor;
  final bool centerTitle;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final PreferredSizeWidget? bottom;

  const customAppBar({
    super.key,
    this.title = '',
    this.backgroundColor = Colors.white,
    this.centerTitle = false,
    this.actions,
    this.onBackPressed,
    this.bottom,
    this.arrowColor,
    this.titleWidget,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: onBackPressed != null
          ? IconButton(
              icon: Icon(
                Icons.chevron_left,
                color: arrowColor ?? Colors.black,
                size: 35,
              ),
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            )
          : null,
      title: titleWidget ??
          Text(title,
              style: AppTextStyles.heading5Bold
                  .copyWith(color: arrowColor ?? AppColors.neutral100)),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      elevation: 0,
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
