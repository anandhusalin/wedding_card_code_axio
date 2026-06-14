import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/utils/validators.dart';

class Step3Family extends StatefulWidget {
  final GlobalKey<FormState>? formKey;
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onSaved;

  const Step3Family({
    super.key,
    this.formKey,
    required this.initialData,
    required this.onSaved,
  });

  @override
  State<Step3Family> createState() => _Step3FamilyState();
}

class _Step3FamilyState extends State<Step3Family> {
  late TextEditingController _brideFatherController;
  late TextEditingController _brideMotherController;
  late TextEditingController _groomFatherController;
  late TextEditingController _groomMotherController;
  final _fatherNamesNotifier = ValueNotifier('');

  @override
  void initState() {
    super.initState();
    _brideFatherController =
        TextEditingController(text: widget.initialData['brideFamily']?['fatherName']);
    _brideMotherController =
        TextEditingController(text: widget.initialData['brideFamily']?['motherName']);
    _groomFatherController =
        TextEditingController(text: widget.initialData['groomFamily']?['fatherName']);
    _groomMotherController =
        TextEditingController(text: widget.initialData['groomFamily']?['motherName']);
    // Sync the father names to the notifier so _ParentsMeetSection can listen
    // without rebuilding the whole widget on every keystroke.
    _fatherNamesNotifier.value = '${_groomFatherController.text} & ${_brideFatherController.text}';
    _groomFatherController.addListener(_updateFatherNames);
    _brideFatherController.addListener(_updateFatherNames);
  }

  void _updateFatherNames() {
    _fatherNamesNotifier.value = '${_groomFatherController.text} & ${_brideFatherController.text}';
  }

  @override
  void dispose() {
    _groomFatherController.removeListener(_updateFatherNames);
    _brideFatherController.removeListener(_updateFatherNames);
    _fatherNamesNotifier.dispose();
    _brideFatherController.dispose();
    _brideMotherController.dispose();
    _groomFatherController.dispose();
    _groomMotherController.dispose();
    super.dispose();
  }

  void _save() {
    widget.onSaved({
      'brideFamily': {
        'fatherName': _brideFatherController.text,
        'motherName': _brideMotherController.text,
      },
      'groomFamily': {
        'fatherName': _groomFatherController.text,
        'motherName': _groomMotherController.text,
      },
    });
  }

  Widget _buildFamilySection(String title, bool isBride) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.family_restroom_rounded,
          title: title,
        ),
        const SizedBox(height: AppTheme.space4),
        AppTextField(
          controller: isBride ? _brideFatherController : _groomFatherController,
          label: "Father's name",
          hint: 'Optional',
          prefixIcon: Icons.man_2_rounded,
          validator: (v) => Validators.validateMessage(v, maxLength: 100),
          onChanged: (_) => _save(),
        ),
        const SizedBox(height: AppTheme.space4),
        AppTextField(
          controller: isBride ? _brideMotherController : _groomMotherController,
          label: "Mother's name",
          hint: 'Optional',
          prefixIcon: Icons.woman_2_rounded,
          validator: (v) => Validators.validateMessage(v, maxLength: 100),
          onChanged: (_) => _save(),
        ),
        const SizedBox(height: AppTheme.space6),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppTheme.space4),
          // ─── Bride Family ───────────────────────────────────
          _buildFamilySection('Bride\'s family', true),
          const SizedBox(height: AppTheme.space8),
          // ─── Groom Family ───────────────────────────────────
          _buildFamilySection('Groom\'s family', false),
          const SizedBox(height: AppTheme.space8),
          // ─── Parents Meet ────────────────────────────────────
          ValueListenableBuilder<String>(
            valueListenable: _fatherNamesNotifier,
            // Only this section rebuilds on father-name changes;
            // the text fields keep their cursor and IME state.
            builder: (_, names, _) => _ParentsMeetSection(combined: names),
          ),
        ],
      ),
    );
  }
}

class _ParentsMeetSection extends StatelessWidget {
  final String combined;
  const _ParentsMeetSection({required this.combined});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.space5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        color: AppColors.tertiarySurface,
        border: Border.all(
          color: AppColors.tertiary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.tertiary,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: Icon(
                  Icons.diversity_3_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppTheme.space3),
              Text(
                'Parents Meet',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.space3),
          Text(
            'Include information about how the families met or '
            'any special relationships.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppTheme.space2),
          Text(
            'For example: "Our parents have known each other since college '
            'and attended the same university."',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.slate600,
                  fontStyle: FontStyle.italic,
                ),
          ),
          if (combined.isNotEmpty) ...[
            const SizedBox(height: AppTheme.space3),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.space3,
                vertical: AppTheme.space2,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
              child: Text(
                'Preview: $combined',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.slate700,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Using the same _SectionHeader from step_2_details.dart
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        const SizedBox(width: AppTheme.space3),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}
