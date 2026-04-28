import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../data/models/choose_sport_response_model.dart';

class ChooseSportBottomSheet extends StatelessWidget {
  final List<SportsList> sports;
  final Function(SportsList) onSportSelected;

  const ChooseSportBottomSheet({
    super.key,
    required this.sports,
    required this.onSportSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (sports.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Choose a Sport',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),

          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: sports.map((sport) {
              return _SportOption(
                iconUrl: sport.icon ?? "",
                label: sport.name ?? "",
                color: Colors.blueAccent,
                isSelected: false, // UI only
                onTap: () {
                  Navigator.pop(context);
                  onSportSelected(sport);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _SportOption extends StatelessWidget {
  final String iconUrl;
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _SportOption({
    required this.iconUrl,
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  bool get isSvg => iconUrl.toLowerCase().endsWith(".svg");

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: isSelected ? color : Colors.grey.shade200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: isSvg
                  ? SvgPicture.network(
                      iconUrl,
                      width: 28,
                      height: 28,
                      placeholderBuilder: (_) =>
                          const CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Image.network(
                      iconUrl,
                      width: 28,
                      height: 28,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.sports),
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      },
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? color : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}