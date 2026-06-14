import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<Map<String, String>> _stepInfo = const [
    {'title': 'Couple Info', 'subtitle': 'Bride & Groom details'},
    {'title': 'Event Details', 'subtitle': 'Date, time & venue'},
    {'title': 'Family', 'subtitle': 'Family information'},
    {'title': 'Gallery', 'subtitle': 'Photos & story'},
    {'title': 'Theme', 'subtitle': 'Choose a template'},
    {'title': 'Publish', 'subtitle': 'Go live!'},
  ];

  void _onStepContinue() {
    // Validate the current step's form (steps 0-3 have forms; 4 and 5 don't)
    if (_currentStep < 4) {
      final form = _formKey.currentState;
      if (form != null && !form.validate()) {
        // Don't advance; FormField will show errors
        return;
      }
    }
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
        return Step1CoupleInfo(
          formKey: _formKey,
          initialData: _weddingData,
          onSaved: _updateData,
        );
      case 1:
        return Step2Details(
          formKey: _formKey,
          initialData: _weddingData,
          onSaved: _updateData,
        );
      case 2:
        return Step3Family(
          formKey: _formKey,
          initialData: _weddingData,
          onSaved: _updateData,
        );
      case 3:
        return Step4Story(
          formKey: _formKey,
          initialData: _weddingData,
          onSaved: _updateData,
        );
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    final progress = (_currentStep + 1) / _stepInfo.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Wedding'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Column(
        children: [
          // ─── Modern step indicator ───────────────────────
          Container(
            decoration: BoxDecoration(
              gradient: isDark
                  ? const LinearGradient(
                      colors: [Color(0xFF4C0519), Color(0xFF2E1065)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : AppColors.brandGradient,
            ),
            padding: EdgeInsets.fromLTRB(
              Responsive.pagePadding(context),
              AppTheme.space2,
              Responsive.pagePadding(context),
              AppTheme.space6,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Step ${_currentStep + 1} of ${_stepInfo.length}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _stepInfo[_currentStep]['title']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                    Text(
                      _stepInfo[_currentStep]['subtitle']!,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.space4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: progress),
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                    builder: (_, value, _) => LinearProgressIndicator(
                      value: value,
                      backgroundColor: Colors.white.withValues(alpha: 0.25),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                      minHeight: 6,
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.space3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_stepInfo.length, (i) {
                    final isCurrent = i == _currentStep;
                    final isCompleted = i < _currentStep;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: isCurrent ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: (isCompleted || isCurrent)
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.35),
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
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.pagePadding(context),
                vertical: AppTheme.space6,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: Responsive.contentMaxWidth(context),
                ),
                child: _buildStepContent(),
              ),
            ),
          ),

          // ─── Bottom navigation ───────────────────────────
          Container(
            padding: EdgeInsets.fromLTRB(
              Responsive.pagePadding(context),
              AppTheme.space4,
              Responsive.pagePadding(context),
              AppTheme.space4,
            ),
            decoration: BoxDecoration(
              color: cs.surface,
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.slate800 : AppColors.slate200,
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  if (_currentStep > 0) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _onStepCancel,
                        child: const Text('Back'),
                      ),
                    ),
                    const SizedBox(width: AppTheme.space3),
                  ],
                  Expanded(
                    flex: _currentStep > 0 ? 2 : 1,
                    child: FilledButton(
                      onPressed: _onStepContinue,
                      child: Text(
                        _currentStep == 5 ? 'Publish Wedding' : 'Continue',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
