import 'package:flutter/material.dart';

class ExertionSlider extends StatefulWidget {
  final String label;
  final ValueChanged<double> onChanged;

  const ExertionSlider({
    super.key,
    required this.label,
    required this.onChanged,
  });

  @override
  State<ExertionSlider> createState() => _ExertionSliderState();
}

class _ExertionSliderState extends State<ExertionSlider> {
  late double value;

  @override
  void initState() {
    super.initState();
    value = _mapLabelToValue(widget.label);
  }

  double _mapLabelToValue(String label) {
    switch (label.toLowerCase()) {
      case 'easy':
        return 0.2;
      case 'moderate':
        return 0.5;
      case 'max_effort':
        return 1.0;
      default:
        return 0.5; // default to moderate if unknown
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.blue,
            inactiveTrackColor: Colors.grey.shade300,
            trackHeight: 8,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
            thumbColor: Colors.blue,
          ),
          child: Slider(
            value: value,
            min: 0,
            max: 1,
            divisions: 100,
            onChanged: (val) {
              setState(() => value = val);
              widget.onChanged(val);
            },
          ),
        ),
        const SizedBox(height: 4),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Easy', style: TextStyle(fontSize: 14, color: Colors.grey)),
              Text('Moderate',
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
              Text('Max Effort',
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }
}
