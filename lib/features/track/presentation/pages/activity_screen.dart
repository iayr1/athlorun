import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────
//  Entry point – wrap in your own BlocProviders / DI as needed
// ─────────────────────────────────────────────────────────────────
class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  // ── Step state ──────────────────────────────────────────────────
  int _currentStep = 0;

  // ── Mock display values (replace with real args) ─────────────────
  final String _sport = 'Running';
  final String _date = 'Mon May 5, 2025   08:32 AM';
  final String _duration = '42:18';
  final String _distance = '6.24 km';
  final String _avgPace = '6:46 min/km';

  // ── Picker selections ───────────────────────────────────────────
  String _selectedRunType = 'Race';
  String _selectedGear = 'Select your gear';
  String _hiddenStat = 'Avg Pace';
  double _exertion = 5;

  // ── Controllers ─────────────────────────────────────────────────
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();

  // ── Photo list (UI only, no actual picking) ──────────────────────
  final List<String> _photos = [];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildStepIndicator(),
          Expanded(
            child: _currentStep == 0
                ? _buildDetailsStep()
                : _buildSettingsStep(),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  //  APP BAR
  // ─────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFF5F5F5),
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.chevron_left, color: Color(0xFF1A1A1A), size: 28),
        onPressed: () => Navigator.maybePop(context),
      ),
      title: const Text(
        'Save Activity',
        style: TextStyle(
          color: Color(0xFF1A1A1A),
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  //  STEP INDICATOR
  // ─────────────────────────────────────────────────────────────────
  Widget _buildStepIndicator() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _stepChip(
            index: 0,
            label: 'Activity Details',
            isActive: _currentStep == 0,
            isDone: _currentStep > 0,
          ),
          Container(
            width: 48,
            height: 2,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            color: Colors.grey.shade300,
          ),
          _stepChip(
            index: 1,
            label: 'Activity Settings',
            isActive: _currentStep == 1,
            isDone: false,
          ),
        ],
      ),
    );
  }

  Widget _stepChip({
    required int index,
    required String label,
    required bool isActive,
    required bool isDone,
  }) {
    const blue = Color(0xFF2563EB);
    const green = Color(0xFF16A34A);
    const grey = Color(0xFF9CA3AF);

    final Color circleColor =
        isDone ? green : (isActive ? blue : grey);
    final Color labelColor =
        isDone ? grey : (isActive ? blue : grey);

    return GestureDetector(
      onTap: () => setState(() => _currentStep = index),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isDone
                  ? const Icon(Icons.check, color: Colors.white, size: 15)
                  : Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: labelColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  //  STEP 1 – ACTIVITY DETAILS
  // ─────────────────────────────────────────────────────────────────
  Widget _buildDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _nameCtrl,
            label: 'Activity Name',
            hint: 'e.g. Morning Run',
            maxLines: 1,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _descCtrl,
            label: 'Description',
            hint: 'How did it go?',
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          _buildPhotoSection(),
          const SizedBox(height: 24),
          _buildPrimaryButton(
            label: 'Continue',
            onTap: () => setState(() => _currentStep = 1),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Activity info card ───────────────────────────────────────────
  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.directions_run,
                  color: Color(0xFF2563EB),
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                _sport,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _date,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _statItem(Icons.timer_outlined, 'Duration', _duration)),
              const SizedBox(width: 12),
              Expanded(child: _statItem(Icons.straighten, 'Distance', _distance)),
              const SizedBox(width: 12),
              Expanded(child: _statItem(Icons.speed, 'Avg Pace', _avgPace)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: const Color(0xFF6B7280)),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }

  // ── Text field ───────────────────────────────────────────────────
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Color(0xFF6B7280), fontSize: 14),
        hintStyle: const TextStyle(color: Color(0xFFD1D5DB), fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
        ),
      ),
    );
  }

  // ── Photo section ────────────────────────────────────────────────
  Widget _buildPhotoSection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Photo or Video',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              // Add button
              GestureDetector(
                onTap: () {
                  // UI only – wire up image picker here
                },
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFF2563EB),
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo_outlined,
                          color: Color(0xFF2563EB), size: 24),
                      SizedBox(height: 4),
                      Text(
                        'Add',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF2563EB),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              if (_photos.isEmpty)
                const Text(
                  'No photos added yet',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  //  STEP 2 – ACTIVITY SETTINGS
  // ─────────────────────────────────────────────────────────────────
  Widget _buildSettingsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Map Preview',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 10),
          _buildMapPlaceholder(),
          const SizedBox(height: 16),
          _buildPickerTile(
            label: 'Type of Run',
            value: _selectedRunType,
            options: const ['Long Run', 'Race', 'Commute', 'Workout'],
            onSelected: (v) => setState(() => _selectedRunType = v),
          ),
          const SizedBox(height: 12),
          _buildPickerTile(
            label: 'Gear',
            value: _selectedGear,
            options: const ['Nike Revolution 7', 'Nike Pegasus Trail 4'],
            onSelected: (v) => setState(() => _selectedGear = v),
          ),
          const SizedBox(height: 12),
          _buildPickerTile(
            label: 'Hide Stat',
            value: _hiddenStat,
            options: const ['Avg Pace', 'Calories'],
            onSelected: (v) => setState(() => _hiddenStat = v),
          ),
          const SizedBox(height: 20),
          _buildExertionSlider(),
          const SizedBox(height: 24),
          _buildPrimaryButton(
            label: 'Save Activity',
            onTap: () {
              // Wire up save logic here
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Map placeholder ──────────────────────────────────────────────
  Widget _buildMapPlaceholder() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: 180,
        child: Stack(
          children: [
            // Simulated map background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFCFE2F3), Color(0xFFD4EAC8)],
                ),
              ),
            ),
            // Grid lines
            CustomPaint(
              size: const Size(double.infinity, 180),
              painter: _MapGridPainter(),
            ),
            // Road overlays
            Positioned(
              top: 70,
              left: 0,
              right: 0,
              child: Container(height: 10, color: const Color(0xFFB0C9D4).withOpacity(0.6)),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 90,
              child: Container(width: 10, color: const Color(0xFFB0C9D4).withOpacity(0.6)),
            ),
            // Location pin
            const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.place, color: Color(0xFFDC2626), size: 36),
                  SizedBox(height: 2),
                ],
              ),
            ),
            // Location label
            Positioned(
              bottom: 10,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Mumbai, IN',
                  style: TextStyle(fontSize: 11, color: Color(0xFF374151)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Picker tile ──────────────────────────────────────────────────
  Widget _buildPickerTile({
    required String label,
    required String value,
    required List<String> options,
    required ValueChanged<String> onSelected,
  }) {
    return GestureDetector(
      onTap: () => _showPicker(label, options, onSelected),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
            const Icon(Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF6B7280), size: 22),
          ],
        ),
      ),
    );
  }

  // ── Bottom sheet picker ──────────────────────────────────────────
  void _showPicker(
      String title, List<String> options, ValueChanged<String> onSelected) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 12),
            ...options.map((opt) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    opt,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right,
                      color: Color(0xFFD1D5DB)),
                  onTap: () {
                    onSelected(opt);
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
    );
  }

  // ── Exertion slider ──────────────────────────────────────────────
  Widget _buildExertionSlider() {
    const labels = ['Easy', 'Light', 'Moderate', 'Hard', 'Max'];
    final levelIndex = ((_exertion - 1) / 2.5).floor().clamp(0, 4);
    final levelLabel = labels[levelIndex];

    final Color trackColor = _exertion <= 3
        ? const Color(0xFF16A34A)
        : _exertion <= 7
            ? const Color(0xFFD97706)
            : const Color(0xFFDC2626);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Exertion Level',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: trackColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  levelLabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: trackColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: trackColor,
              inactiveTrackColor: const Color(0xFFF3F4F6),
              thumbColor: trackColor,
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            ),
            child: Slider(
              value: _exertion,
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (v) => setState(() => _exertion = v),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Easy', style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
              Text('Max', style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
            ],
          ),
        ],
      ),
    );
  }

  // ── Primary button ───────────────────────────────────────────────
  Widget _buildPrimaryButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
//  Map grid painter (decorative lines on the map placeholder)
// ─────────────────────────────────────────────────────────────────
class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF8BA0A8).withOpacity(0.35)
      ..strokeWidth = 0.5;

    for (double x = 0; x < size.width; x += 24) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 24) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}