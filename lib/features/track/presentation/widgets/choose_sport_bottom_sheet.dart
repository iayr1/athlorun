import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:athlorun/features/track/presentation/bloc/track_page_cubit.dart';
import '../../data/models/choose_sport_response_model.dart';

class ChooseSportBottomSheet extends StatelessWidget {
  final Function(SportsList) onSportSelected;

  const ChooseSportBottomSheet({super.key, required this.onSportSelected});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TrackPageCubit>();
    debugPrint(
        '[BottomSheet] Cubit: ${cubit.hashCode} | State: ${cubit.state}');
    cubit.loadAvailableSports();

    return BlocBuilder<TrackPageCubit, TrackPageState>(
      builder: (context, state) {
        debugPrint('[BottomSheet] BlocBuilder State: $state');

        return state.maybeWhen(
          loadingSports: () {
            return const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          },
          loadSportsError: (message) {
            return SizedBox(
              height: 200,
              child: Center(child: Text(message)),
            );
          },
          loadedSports: (sports) {
            final selected = cubit.selectedSport ?? '';

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Choose a Sport',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: sports.map((sport) {
                      debugPrint('[BottomSheet] ➜ Sport: ${sport.name}');
                      debugPrint('[BottomSheet] ➜ Sport ID: ${sport.id}');
                      debugPrint('[BottomSheet] ➜ Icon URL: ${sport.icon}');

                      return _SportOption(
                        iconUrl: sport.icon,
                        label: sport.name,
                        color: Colors.blueAccent,
                        isSelected: selected == sport.name,
                        onTap: () {
                          debugPrint(
                              '[BottomSheet] ✅ Selected Sport ID: ${sport.id}');
                          cubit.setSport(sport);
                          cubit.startTracking();
                          Future.delayed(const Duration(milliseconds: 200), () {
                            Navigator.pop(context);
                            onSportSelected(sport);
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          },
          orElse: () {
            return const SizedBox(
              height: 200,
              child: Center(child: Text('Loading...')),
            );
          },
        );
      },
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
    debugPrint('🏞 Rendering Icon: $iconUrl');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: isSelected ? color : Colors.grey[200],
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: isSvg
                  ? SvgPicture.network(
                      iconUrl,
                      width: 28,
                      height: 28,
                      placeholderBuilder: (context) =>
                          const CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Image.network(
                      iconUrl,
                      width: 28,
                      height: 28,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(Icons.sports),
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const CircularProgressIndicator(strokeWidth: 2);
                      },
                    ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? color : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
