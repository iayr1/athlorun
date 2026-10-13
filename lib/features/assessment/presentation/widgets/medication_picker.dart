import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../config/themes/app_theme.dart';

/// Common medications by generic or brand name, for the "What medications
/// do you take?" step. Not exhaustive; users can search and add their own.
const kCommonMedications = [
  'Abilify',
  'Abilify Maintena',
  'Abiraterone',
  'Acetaminophen',
  'Actemra',
  'Acyclovir',
  'Adderall',
  'Albuterol',
  'Allopurinol',
  'Alprazolam',
  'Amlodipine',
  'Amoxicillin',
  'Aspirin',
  'Atorvastatin',
  'Azithromycin',
  'Baclofen',
  'Benadryl',
  'Bisoprolol',
  'Budesonide',
  'Bupropion',
  'Buspirone',
  'Carvedilol',
  'Cetirizine',
  'Ciprofloxacin',
  'Citalopram',
  'Clonazepam',
  'Clopidogrel',
  'Cyclobenzaprine',
  'Dexamethasone',
  'Diazepam',
  'Diclofenac',
  'Doxycycline',
  'Duloxetine',
  'Empagliflozin',
  'Enalapril',
  'Escitalopram',
  'Esomeprazole',
  'Estradiol',
  'Ezetimibe',
  'Famotidine',
  'Fexofenadine',
  'Fluconazole',
  'Fluoxetine',
  'Fluticasone',
  'Folic Acid',
  'Furosemide',
  'Gabapentin',
  'Glimepiride',
  'Glipizide',
  'Hydrochlorothiazide',
  'Hydrocodone',
  'Hydroxychloroquine',
  'Hydroxyzine',
  'Ibuprofen',
  'Insulin Glargine',
  'Insulin Lispro',
  'Iron Supplement',
  'Isotretinoin',
  'Ketoconazole',
  'Ketorolac',
  'Lamotrigine',
  'Lansoprazole',
  'Levetiracetam',
  'Levocetirizine',
  'Levothyroxine',
  'Lisinopril',
  'Loratadine',
  'Losartan',
  'Melatonin',
  'Meloxicam',
  'Metformin',
  'Methotrexate',
  'Methylphenidate',
  'Metoprolol',
  'Montelukast',
  'Naproxen',
  'Nitrofurantoin',
  'Nifedipine',
  'Nortriptyline',
  'Olanzapine',
  'Omeprazole',
  'Ondansetron',
  'Oxycodone',
  'Pantoprazole',
  'Paracetamol',
  'Paroxetine',
  'Prednisone',
  'Pregabalin',
  'Propranolol',
  'Quetiapine',
  'Quinapril',
  'Ramipril',
  'Ranitidine',
  'Risperidone',
  'Rosuvastatin',
  'Salbutamol',
  'Semaglutide',
  'Sertraline',
  'Sildenafil',
  'Simvastatin',
  'Spironolactone',
  'Sumatriptan',
  'Tamsulosin',
  'Topiramate',
  'Tramadol',
  'Trazodone',
  'Valacyclovir',
  'Valsartan',
  'Venlafaxine',
  'Vitamin B12',
  'Vitamin D3',
  'Warfarin',
  'Xarelto',
  'Xanax',
  'Yasmin',
  'Zinc Supplement',
  'Zoloft',
  'Zolpidem',
];

/// "What medications do you take?": A–Z tabs, a search field, a checkbox
/// list and the selected medications as removable chips.
class MedicationPicker extends StatefulWidget {
  final List<String> selected;
  final ValueChanged<List<String>> onChanged;

  const MedicationPicker({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  State<MedicationPicker> createState() => _MedicationPickerState();
}

class _MedicationPickerState extends State<MedicationPicker> {
  static final _letters = [
    for (var c = 'A'.codeUnitAt(0); c <= 'Z'.codeUnitAt(0); c++)
      String.fromCharCode(c),
  ];

  final _search = TextEditingController();
  final _list = ScrollController();
  String _letter = 'A';
  bool _searching = false;

  @override
  void dispose() {
    _search.dispose();
    _list.dispose();
    super.dispose();
  }

  List<String> get _visible {
    final all = {...kCommonMedications, ...widget.selected}.toList()..sort();
    if (_searching) {
      final q = _search.text.trim().toLowerCase();
      return q.isEmpty
          ? all
          : all.where((m) => m.toLowerCase().contains(q)).toList();
    }
    return all.where((m) => m.toUpperCase().startsWith(_letter)).toList();
  }

  void _toggle(String name) {
    HapticFeedback.selectionClick();
    final next = [...widget.selected];
    next.contains(name) ? next.remove(name) : next.add(name);
    widget.onChanged(next);
  }

  void _addTyped() {
    final name = _search.text.trim();
    if (name.isEmpty) return;
    final existing = kCommonMedications.firstWhere(
      (m) => m.toLowerCase() == name.toLowerCase(),
      orElse: () => name,
    );
    if (!widget.selected.contains(existing)) _toggle(existing);
    _search.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visible;
    final typed = _search.text.trim();
    final canAdd = _searching &&
        typed.isNotEmpty &&
        !visible.any((m) => m.toLowerCase() == typed.toLowerCase());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 48,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: _searching
              ? Row(
                  children: [
                    const SizedBox(width: 8),
                    const Icon(Icons.search_rounded, color: AppPalette.gray40),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _search,
                        autofocus: true,
                        textInputAction: TextInputAction.done,
                        onChanged: (_) => setState(() {}),
                        onSubmitted: (_) => _addTyped(),
                        style: AppText.textSmSemiBold,
                        decoration: const InputDecoration(
                          hintText: 'Search medications',
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Close search',
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () => setState(() {
                        _searching = false;
                        _search.clear();
                      }),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          for (final l in _letters)
                            _LetterTab(
                              letter: l,
                              selected: l == _letter,
                              onTap: () => setState(() => _letter = l),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Search',
                      icon: const Icon(
                        Icons.search_rounded,
                        color: AppPalette.gray80,
                      ),
                      onPressed: () => setState(() => _searching = true),
                    ),
                  ],
                ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 320,
          child: Scrollbar(
            controller: _list,
            thumbVisibility: true,
            child: ListView(
              controller: _list,
              padding: const EdgeInsets.only(right: 10),
              children: [
                if (canAdd)
                  _MedicationRow(
                    name: 'Add “$typed”',
                    selected: false,
                    icon: Icons.add_rounded,
                    onTap: _addTyped,
                  ),
                if (visible.isEmpty && !canAdd)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'No medications starting with $_letter.',
                      textAlign: TextAlign.center,
                      style: AppText.paragraphSm,
                    ),
                  ),
                for (final m in visible)
                  _MedicationRow(
                    name: m,
                    selected: widget.selected.contains(m),
                    onTap: () => _toggle(m),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 6,
          runSpacing: 6,
          children: [
            const Text('Selected:', style: AppText.paragraphSm),
            if (widget.selected.isEmpty)
              Text('None', style: AppText.textSmSemiBold),
            for (final m in widget.selected)
              _RemovableChip(label: m, onRemove: () => _toggle(m)),
          ],
        ),
      ],
    );
  }
}

class _LetterTab extends StatelessWidget {
  final String letter;
  final bool selected;
  final VoidCallback onTap;

  const _LetterTab({
    required this.letter,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppPalette.gray80 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          letter,
          style: AppText.textSmExtraBold.copyWith(
            color: selected ? Colors.white : AppPalette.gray50,
          ),
        ),
      ),
    );
  }
}

class _MedicationRow extends StatelessWidget {
  final String name;
  final bool selected;
  final IconData? icon;
  final VoidCallback onTap;

  const _MedicationRow({
    required this.name,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final fg = selected ? Colors.white : AppPalette.gray80;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        decoration: BoxDecoration(
          color: selected ? AppPalette.blue60 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: selected ? AppPalette.focusRing(AppPalette.blue60) : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: AppText.textSmSemiBold.copyWith(color: fg),
                    ),
                  ),
                  Icon(
                    icon ??
                        (selected
                            ? Icons.check_box_rounded
                            : Icons.check_box_outline_blank_rounded),
                    color: selected ? Colors.white : AppPalette.gray80,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RemovableChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _RemovableChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 4, 4, 4),
      decoration: BoxDecoration(
        color: AppPalette.gray20,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppText.labelXs.copyWith(
              letterSpacing: 0,
              color: AppPalette.gray80,
            ),
          ),
          const SizedBox(width: 2),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close_rounded,
              size: 14,
              color: AppPalette.gray60,
            ),
          ),
        ],
      ),
    );
  }
}
