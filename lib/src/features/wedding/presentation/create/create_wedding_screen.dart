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
  
  // State to hold the form data across steps
  final Map<String, dynamic> _weddingData = {};

  void _onStepContinue() {
    if (_currentStep < 5) {
      setState(() => _currentStep += 1);
    } else {
      // Final submit
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    }
  }

  void _updateData(Map<String, dynamic> data) {
    setState(() {
      _weddingData.addAll(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Wedding Website'),
      ),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepContinue: _onStepContinue,
        onStepCancel: _onStepCancel,
        onStepTapped: (step) => setState(() => _currentStep = step),
        controlsBuilder: (context, details) {
          // Custom controls if needed, handled by the steps usually, but we can provide generic ones
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  child: Text(_currentStep == 5 ? 'Publish' : 'Next'),
                ),
                if (_currentStep > 0) ...[
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: const Text('Back'),
                  ),
                ],
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('Couple'),
            content: Step1CoupleInfo(
              initialData: _weddingData,
              onSaved: _updateData,
            ),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Details'),
            content: Step2Details(
              initialData: _weddingData,
              onSaved: _updateData,
            ),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Family'),
            content: Step3Family(
              initialData: _weddingData,
              onSaved: _updateData,
            ),
            isActive: _currentStep >= 2,
            state: _currentStep > 2 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Gallery'),
            content: Step4Story(
              initialData: _weddingData,
              onSaved: _updateData,
            ),
            isActive: _currentStep >= 3,
            state: _currentStep > 3 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Theme'),
            content: Step5Template(
              initialData: _weddingData,
              onSaved: _updateData,
            ),
            isActive: _currentStep >= 4,
            state: _currentStep > 4 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Publish'),
            content: Step6Publish(
              weddingData: _weddingData,
            ),
            isActive: _currentStep >= 5,
          ),
        ],
      ),
    );
  }
}
