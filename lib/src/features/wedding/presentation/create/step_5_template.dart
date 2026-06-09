import 'package:flutter/material.dart';

class Step5Template extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onSaved;

  const Step5Template({
    super.key,
    required this.initialData,
    required this.onSaved,
  });

  @override
  State<Step5Template> createState() => _Step5TemplateState();
}

class _Step5TemplateState extends State<Step5Template> {
  String _selectedTemplate = 'traditional-kerala';

  @override
  void initState() {
    super.initState();
    _selectedTemplate = widget.initialData['templateId'] ?? 'traditional-kerala';
  }

  void _save(String templateId) {
    setState(() => _selectedTemplate = templateId);
    widget.onSaved({
      'templateId': templateId,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile(
          title: const Text('Traditional Kerala'),
          value: 'traditional-kerala',
          groupValue: _selectedTemplate,
          onChanged: (v) => _save(v.toString()),
        ),
        RadioListTile(
          title: const Text('Modern Elegant'),
          value: 'modern-elegant',
          groupValue: _selectedTemplate,
          onChanged: (v) => _save(v.toString()),
        ),
      ],
    );
  }
}
