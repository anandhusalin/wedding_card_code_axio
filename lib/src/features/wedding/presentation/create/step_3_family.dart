import 'package:flutter/material.dart';
import '../../../../core/widgets/app_text_field.dart';

class Step3Family extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onSaved;

  const Step3Family({
    super.key,
    required this.initialData,
    required this.onSaved,
  });

  @override
  State<Step3Family> createState() => _Step3FamilyState();
}

class _Step3FamilyState extends State<Step3Family> {
  late TextEditingController _brideFatherController;
  late TextEditingController _brideMotherController;

  @override
  void initState() {
    super.initState();
    _brideFatherController = TextEditingController(text: widget.initialData['brideFamily']?['fatherName']);
    _brideMotherController = TextEditingController(text: widget.initialData['brideFamily']?['motherName']);
  }

  void _save() {
    widget.onSaved({
      'brideFamily': {
        'fatherName': _brideFatherController.text,
        'motherName': _brideMotherController.text,
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Bride Family Details'),
        AppTextField(
          controller: _brideFatherController,
          label: "Father's Name",
          onChanged: (_) => _save(),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _brideMotherController,
          label: "Mother's Name",
          onChanged: (_) => _save(),
        ),
      ],
    );
  }
}
