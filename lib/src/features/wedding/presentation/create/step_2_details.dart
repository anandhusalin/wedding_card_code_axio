import 'package:flutter/material.dart';
import '../../../../core/widgets/app_text_field.dart';

class Step2Details extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onSaved;

  const Step2Details({
    super.key,
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

  /// Defensive parser: the shared `_weddingData` map can hold the date as a
  /// `DateTime` (set by this step) or as a `String` (left over from the
  /// publish step's `.toIso8601String()` conversion). We accept both so the
  /// user can navigate back and forward without crashing.
  DateTime? _parseDate(dynamic raw) {
    if (raw == null) return null;
    if (raw is DateTime) return raw;
    if (raw is String) {
      return DateTime.tryParse(raw);
    }
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          title: Text(_selectedDate == null ? 'Select Date' : _selectedDate!.toIso8601String().split('T')[0]),
          trailing: const Icon(Icons.calendar_today),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 3650)),
            );
            if (date != null) {
              setState(() => _selectedDate = date);
              _save();
            }
          },
        ),
        AppTextField(
          controller: _timeController,
          label: 'Time',
          onChanged: (_) => _save(),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _venueController,
          label: 'Venue Name',
          onChanged: (_) => _save(),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _addressController,
          label: 'Venue Address',
          onChanged: (_) => _save(),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _mapUrlController,
          label: 'Google Maps Link',
          onChanged: (_) => _save(),
        ),
      ],
    );
  }
}
