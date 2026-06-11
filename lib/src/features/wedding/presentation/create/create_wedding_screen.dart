import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import 'step_1_couple_info.dart';
import 'step_2_details.dart';
import 'step_3_family.dart';
import 'step_4_story.dart';
import 'step_5_template.dart';
import 'step_6_publish.dart';

class CreateWeddingScreen extends ConsumerStatefulWidget {
  const CreateWeddingScreen({super.key});

  @override
  ConsumerState<CreateWeddingScreen> createState() => _CreateWeddingScreenState();
}

class _CreateWeddingScreenState extends ConsumerState<CreateWeddingScreen> {
  int _currentStep = 0;
  final Map<String, dynamic> _weddingData = {};

  final List<Map<String, String>> _stepInfo = [
    {'title': 'Couple Info', 'subtitle': 'Bride & Groom details'},
    {'title': 'Event Details', 'subtitle': 'Date, time & venue'},
    {'title': 'Family', 'subtitle': 'Family information'},
    {'title': 'Gallery', 'subtitle': 'Photos & story'},
    {'title': 'Theme', 'subtitle': 'Choose a template'},
    {'title': 'Publish', 'subtitle': 'Go live!'},
  ];

  void _onStepContinue() {
    if (_currentStep < 5) {
      setState(() => _currentStep += 1);
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    }
  }

  void _updateData(Map<String, dynamic> data) {
    setState(() => _weddingData.addAll(data));
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return Step1CoupleInfo(initialData: _weddingData, onSaved: _updateData);
      case 1:
        return Step2Details(initialData: _weddingData, onSaved: _updateData);
      case 2:
        return Step3Family(initialData: _weddingData, onSaved: _updateData);
      case 3:
        return Step4Story(initialData: _weddingData, onSaved: _updateData);
      case 4:
        return Step5Template(initialData: _weddingData, onSaved: _updateData);
      case 5:
        return Step6Publish(weddingData: _weddingData);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Create Wedding Website'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // ─── Step indicator header ───────────────────────
          Container(
            color: AppColors.primary,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Step ${_currentStep + 1} of ${_stepInfo.length}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _stepInfo[_currentStep]['title']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      _stepInfo[_currentStep]['subtitle']!,
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (_currentStep + 1) / _stepInfo.length,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_stepInfo.length, (i) {
                    final isCurrent = i == _currentStep;
                    final isCompleted = i < _currentStep;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: isCurrent ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: (isCompleted || isCurrent) ? Colors.white : Colors.white38,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          // ─── Step content area ───────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildStepContent(),
            ),
          ),

          // ─── Bottom navigation ───────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                if (_currentStep > 0) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _onStepCancel,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primary),
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('← Back'),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _onStepContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _currentStep == 5 ? '🎉 Publish Wedding' : 'Next →',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
