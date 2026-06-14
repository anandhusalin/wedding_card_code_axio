import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/utils/validators.dart';

class Step2Details extends StatefulWidget {
  final GlobalKey<FormState>? formKey;
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onSaved;

  const Step2Details({
    super.key,
    this.formKey,
    required this.initialData,
    required this.onSaved,
  });

  @override
  State<Step2Details> createState() => _Step2DetailsState();
}

class _Step2DetailsState extends State<Step2Details> {
  DateTime? _selectedDate;
  late TextEditingController _timeController;
  late TextEditingController _venueController;
  late TextEditingController _addressController;
  late TextEditingController _mapUrlController;

  @override
  void initState() {
    super.initState();
    _selectedDate = _parseDate(widget.initialData['weddingDate']);
    _timeController = TextEditingController(text: widget.initialData['weddingTime'] as String?);
    _venueController = TextEditingController(text: widget.initialData['venue']?['name']);
    _addressController = TextEditingController(text: widget.initialData['venue']?['address']);
    _mapUrlController = TextEditingController(text: widget.initialData['venue']?['mapUrl']);
  }

  DateTime? _parseDate(dynamic raw) {
    if (raw == null) return null;
    if (raw is DateTime) return raw;
    if (raw is String) return DateTime.tryParse(raw);
    return null;
  }

  void _save() {
    widget.onSaved({
      'weddingDate': _selectedDate,
      'weddingTime': _timeController.text,
      'venue': {
        'name': _venueController.text,
        'address': _addressController.text,
        'mapUrl': _mapUrlController.text,
      }
    });
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primary,
                  onPrimary: Colors.white,
                ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      setState(() => _selectedDate = date);
      _save();
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primary,
                  onPrimary: Colors.white,
                ),
          ),
          child: child!,
        );
      },
    );
    if (time != null) {
      _timeController.text =
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      _save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ─── Date & Time ───────────────────────────────────
          Row(
            children: [
              Expanded(
                child: _PickerField(
                  icon: Icons.calendar_today_rounded,
                  label: 'Date',
                  value: _selectedDate == null
                      ? 'Select date'
                      : _selectedDate!.toIso8601String().split('T')[0],
                  onTap: _pickDate,
                  isError: _selectedDate == null,
                  errorText: 'Required',
                ),
              ),
              const SizedBox(width: AppTheme.space3),
              Expanded(
                child: _PickerField(
                  icon: Icons.schedule_rounded,
                  label: 'Time',
                  value: _timeController.text.isEmpty ? 'Select time' : _timeController.text,
                  onTap: _pickTime,
                  isError: _timeController.text.isEmpty,
                  errorText: 'Required',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.space6),

          // ─── Venue section ────────────────────────────────
          _SectionHeader(
            icon: Icons.location_on_rounded,
            title: 'Venue details',
          ),
          const SizedBox(height: AppTheme.space4),
          AppTextField(
            controller: _venueController,
            label: 'Venue name',
            hint: 'e.g. St. Mary\'s Church',
            prefixIcon: Icons.church_rounded,
            validator: (v) => Validators.validateRequired(v, 'Venue name'),
            onChanged: (_) => _save(),
          ),
          const SizedBox(height: AppTheme.space4),
          AppTextField(
            controller: _addressController,
            label: 'Venue address',
            hint: 'Full street address',
            prefixIcon: Icons.location_on_outlined,
            maxLines: 2,
            validator: (v) => Validators.validateRequired(v, 'Venue address'),
            onChanged: (_) => _save(),
          ),
          const SizedBox(height: AppTheme.space4),
          AppTextField(
            controller: _mapUrlController,
            label: 'Google Maps link',
            hint: 'https://maps.google.com/...',
            prefixIcon: Icons.map_rounded,
            keyboardType: TextInputType.url,
            validator: Validators.validateOptionalUrl,
            onChanged: (_) => _save(),
          ),
        ],
      ),
    );
  }
}

class _PickerField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  final bool isError;
  final String? errorText;

  const _PickerField({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
    this.isError = false,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasValue = !value.startsWith('Select');
    final borderColor = isError
        ? Theme.of(context).colorScheme.error
        : (isDark ? AppColors.slate700 : AppColors.slate300);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.space4,
              vertical: AppTheme.space3,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border.all(
                color: borderColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 20),
                const SizedBox(width: AppTheme.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        value,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: hasValue
                                  ? Theme.of(context).colorScheme.onSurface
                                  : Theme.of(context).colorScheme.onSurfaceVariant,
                              fontWeight: hasValue ? FontWeight.w600 : FontWeight.w500,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isError && errorText != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              errorText!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ),
        ],
      ],
    );
  }
}

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
