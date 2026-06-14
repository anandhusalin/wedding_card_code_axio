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
    // Repaint the parents-meet preview as the user types into father-name
    // fields; the static _ParentsMeetSection reads controller text at build
    // time, so a setState is required to re-render it.
    _brideFatherController.addListener(_onTextChanged);
    _groomFatherController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
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
          _ParentsMeetSection(
            groomName: _groomFatherController.text,
            brideName: _brideFatherController.text,
          ),
        ],
      ),
    );
  }
}

class _ParentsMeetSection extends StatelessWidget {
  final String groomName;
  final String brideName;
  const _ParentsMeetSection({required this.groomName, required this.brideName});

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
