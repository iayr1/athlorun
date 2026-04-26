import 'package:flutter/material.dart';
import 'package:athlorun/config/styles/app_colors.dart';
import 'package:athlorun/config/styles/app_textstyles.dart';
import 'package:athlorun/core/utils/windows.dart';

class CustomDropDownWidget<T> extends StatelessWidget {
  final String bottomTitle;
  final String? label;
  final T? value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;
  final String Function(T)? getLabel;
  final Widget Function(T)? iconBuilder;

  const CustomDropDownWidget({
    super.key,
    required this.bottomTitle,
    this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.getLabel,
    this.iconBuilder,
  });

  void _showBottomSheetSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.neutral10,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: Window.getVerticalSize(12)),
              Container(
                height: 5,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: AppColors.neutral30,
                ),
              ),
              SizedBox(height: Window.getVerticalSize(15)),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  bottomTitle,
                  style: AppTextStyles.heading5Bold
                      .copyWith(color: AppColors.neutral100),
                ),
              ),
              SizedBox(height: Window.getVerticalSize(8)),
              SingleChildScrollView(
                child: Column(
                  children: [
                    for (int index = 0; index < items.length; index++) ...[
                      _buildListItem(items[index], context),
                      if (index < items.length - 1)
                        const Divider(
                          color: AppColors.neutral20,
                          thickness: 1,
                          height: 1,
                        ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListItem(T item, BuildContext context) {
    final isSelected = item == value;

    return ListTile(
      leading: iconBuilder != null ? iconBuilder!(item) : null,
      title: Text(
        getLabel != null ? getLabel!(item) : item.toString(),
        style: AppTextStyles.bodyRegular.copyWith(
          color: isSelected ? AppColors.primaryBlue90 : AppColors.neutral100,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? const Icon(
              Icons.check,
              color: AppColors.primaryBlue90,
            )
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Window.getRadiusSize(8)),
      ),
      onTap: () {
        onChanged(item);
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label != null
            ? Text(
                label ?? "",
                style: AppTextStyles.subtitleBold.copyWith(
                  color: AppColors.neutral80,
                ),
              )
            : const SizedBox.shrink(),
        SizedBox(height: Window.getVerticalSize(5)),
        GestureDetector(
          onTap: () => _showBottomSheetSelection(context),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.neutral20,
              borderRadius: BorderRadius.circular(Window.getRadiusSize(8.0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (value != null && iconBuilder != null)
                      iconBuilder!(value!),
                    SizedBox(width: Window.getHorizontalSize(8)),
                    Text(
                      value != null
                          ? (getLabel != null
                              ? getLabel!(value!)
                              : value.toString())
                          : label ?? "",
                      style: AppTextStyles.bodyRegular.copyWith(
                        color: AppColors.neutral100,
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.arrow_drop_down_outlined,
                  color: AppColors.neutral100,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
