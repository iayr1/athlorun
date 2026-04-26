import 'package:flutter/material.dart';
import 'package:athlorun/config/styles/app_colors.dart';
import 'package:athlorun/config/styles/app_textstyles.dart';

class ExpansionTileWidget extends StatelessWidget {
  final String id;
  final String title;
  final IconData icon;
  final String? expandedTile;
  final Function(bool) onExpansionChanged;
  final List<Widget> children;

  const ExpansionTileWidget({
    super.key,
    required this.id,
    required this.title,
    required this.icon,
    required this.expandedTile,
    required this.onExpansionChanged,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final isExpanded = expandedTile == id;
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.neutral20.withOpacity(.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ExpansionTile(
          onExpansionChanged: onExpansionChanged,
          leading: Icon(
            icon,
            size: 20,
            color: isExpanded ? AppColors.primaryBlue100 : AppColors.neutral70,
          ),
          title: Text(title, style: AppTextStyles.bodyRegular),
          children: children,
        ),
      ),
    );
  }
}
