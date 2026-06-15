import 'package:flutter/material.dart';

import 'template_preview.dart';

/// Step 5 — Template selection.
///
/// Each of the 4 templates is presented as a card with a "live"
/// miniature preview. Tapping a card opens a bottom sheet that scrolls
/// through every section of that template (Hero, Couple, Our Story,
/// Family, Events, Gallery, Travel, Gift, Wishes, Footer) using the
/// user's actual data from the create-wizard. The "Select" button at
/// the bottom of the sheet commits the choice.
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
  // Must match the backend's TEMPLATE_IDS whitelist and the
  // TemplateTheme keys in template_preview.dart.
  static const List<_TemplateChoice> _templates = [
    _TemplateChoice(
      id: 'floral-romance',
      name: 'Floral Romance',
      tagline: 'Soft & romantic',
      primary: Color(0xFFB7628A),
      accent: Color(0xFFE6B3C2),
      bg: Color(0xFFFFF8F4),
      icon: Icons.local_florist,
    ),
    _TemplateChoice(
      id: 'royal-maroon',
      name: 'Royal Maroon',
      tagline: 'Regal & ornate',
      primary: Color(0xFF5C0015),
      accent: Color(0xFFC9A95E),
      bg: Color(0xFFFAF1E0),
      icon: Icons.castle_outlined,
    ),
    _TemplateChoice(
      id: 'modern-elegant',
      name: 'Modern Elegant',
      tagline: 'Clean & minimal',
      primary: Color(0xFF1F2937),
      accent: Color(0xFFBFA987),
      bg: Color(0xFFFAF7F2),
      icon: Icons.diamond_outlined,
    ),
    _TemplateChoice(
      id: 'traditional-kerala',
      name: 'Traditional Kerala',
      tagline: 'Classic Kerala style',
      primary: Color(0xFF7B2D26),
      accent: Color(0xFFC9A95E),
      bg: Color(0xFFFAF3E7),
      icon: Icons.temple_hindu,
    ),
  ];

  late String _selectedTemplate;

  @override
  void initState() {
    super.initState();
    _selectedTemplate = widget.initialData['templateId'] ?? 'floral-romance';
  }

  void _save(String templateId) {
    setState(() => _selectedTemplate = templateId);
    widget.onSaved({'templateId': templateId});
  }

  Future<void> _openPreview(_TemplateChoice t) async {
    final selected = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _TemplatePreviewSheet(
        template: t,
        isSelected: _selectedTemplate == t.id,
        data: widget.initialData,
        onSelect: () {
          _save(t.id);
          Navigator.of(ctx).pop(true);
        },
      ),
    );
    if (selected == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: t.primary, size: 18),
              const SizedBox(width: 8),
              Text('${t.name} selected'),
            ],
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose a template',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Tap any card to preview all 9 sections with your data. All templates are free.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        const SizedBox(height: 8),
        if (_selectedTemplate.isNotEmpty)
          _SelectedBanner(
            template: _templates.firstWhere((t) => t.id == _selectedTemplate),
            onPreview: () => _openPreview(
              _templates.firstWhere((t) => t.id == _selectedTemplate),
            ),
          ),
        const SizedBox(height: 20),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _templates.length,
          separatorBuilder: (_, _) => const SizedBox(height: 14),
          itemBuilder: (ctx, i) {
            final t = _templates[i];
            return _TemplateCard(
              template: t,
              selected: _selectedTemplate == t.id,
              data: widget.initialData,
              onTap: () => _save(t.id),
              onPreviewTap: () => _openPreview(t),
            );
          },
        ),
      ],
    );
  }
}

class _TemplateChoice {
  final String id;
  final String name;
  final String tagline;
  final Color primary;
  final Color accent;
  final Color bg;
  final IconData icon;

  const _TemplateChoice({
    required this.id,
    required this.name,
    required this.tagline,
    required this.primary,
    required this.accent,
    required this.bg,
    required this.icon,
  });
}

class _TemplateCard extends StatelessWidget {
  final _TemplateChoice template;
  final bool selected;
  final Map<String, dynamic> data;
  final VoidCallback onTap;
  final VoidCallback onPreviewTap;

  const _TemplateCard({
    required this.template,
    required this.selected,
    required this.data,
    required this.onTap,
    required this.onPreviewTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? template.primary : Colors.grey[300]!,
          width: selected ? 2.5 : 1,
        ),
        boxShadow: [
          if (selected)
            BoxShadow(
              color: template.primary.withValues(alpha: 0.18),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ─── Live mini-preview ─────────────────────────────
          // Renders the actual first 2 sections (Hero + Couple) of
          // this template using the user's data. Tapping anywhere
          // inside opens the full preview sheet.
          GestureDetector(
            onTap: onPreviewTap,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
              child: Container(
                color: template.bg,
                constraints: const BoxConstraints(maxHeight: 280),
                child: Stack(
                  children: [
                    // Mini preview
                    SizedBox(
                      height: 280,
                      child: TemplatePreview(
                        templateId: template.id,
                        data: data,
                        isPhone: true,
                      ),
                    ),
                    // Top-right "Selected" check
                    if (selected)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: template.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    // Bottom gradient + "Tap to preview" hint
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.55),
                            ],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.visibility_outlined,
                              size: 14,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Tap to preview all sections',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // ─── Name + actions ────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: template.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(template.icon, color: template.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        template.name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: selected ? template.primary : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        template.tagline,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                FilledButton.tonalIcon(
                  onPressed: onTap,
                  style: FilledButton.styleFrom(
                    backgroundColor: selected
                        ? template.primary
                        : template.primary.withValues(alpha: 0.08),
                    foregroundColor: selected ? Colors.white : template.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    minimumSize: const Size(0, 36),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  icon: Icon(
                    selected ? Icons.check : Icons.add,
                    size: 14,
                  ),
                  label: Text(selected ? 'Selected' : 'Select'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectedBanner extends StatelessWidget {
  final _TemplateChoice template;
  final VoidCallback onPreview;
  const _SelectedBanner({required this.template, required this.onPreview});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: template.primary.withValues(alpha: 0.07),
        border: Border.all(color: template.primary.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: template.primary, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Currently selected: ${template.name}',
              style: TextStyle(
                color: template.primary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          TextButton(
            onPressed: onPreview,
            style: TextButton.styleFrom(
              foregroundColor: template.primary,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: const Size(0, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Preview'),
          ),
        ],
      ),
    );
  }
}

class _TemplatePreviewSheet extends StatelessWidget {
  final _TemplateChoice template;
  final bool isSelected;
  final Map<String, dynamic> data;
  final VoidCallback onSelect;

  const _TemplatePreviewSheet({
    required this.template,
    required this.isSelected,
    required this.data,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (ctx, scrollCtrl) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // ─── Handle bar ───────────────────────────────
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // ─── Header ───────────────────────────────────
              Container(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[200]!),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: template.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(template.icon,
                          color: template.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            template.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            template.tagline,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
              ),
              // ─── Scrollable preview ──────────────────────
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollCtrl,
                  // Pad bottom so the last section isn't covered by the
                  // bottom action bar.
                  padding: EdgeInsets.only(bottom: media.padding.bottom + 80),
                  child: TemplatePreview(
                    templateId: template.id,
                    data: data,
                    isPhone: true,
                  ),
                ),
              ),
              // ─── Bottom action bar ───────────────────────
              Container(
                padding: EdgeInsets.fromLTRB(
                  20,
                  12,
                  20,
                  12 + media.padding.bottom,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.grey[200]!),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Close'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: FilledButton(
                          onPressed: onSelect,
                          style: FilledButton.styleFrom(
                            backgroundColor: template.primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            isSelected
                                ? 'Keep ${template.name}'
                                : 'Select ${template.name}',
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
      },
    );
  }
}
