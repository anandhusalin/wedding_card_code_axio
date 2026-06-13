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
  // Hardcoded to match backend's TEMPLATE_IDS whitelist. If you add a new
  // template, update both this list and the Zod enum in
  // backend/src/validators/wedding.validator.js.
  static const List<_TemplateChoice> _templates = [
    _TemplateChoice(
      id: 'traditional-kerala',
      name: 'Traditional Kerala',
      tagline: 'Classic Kerala style',
      primary: Color(0xFFD4A574),
      accent: Color(0xFF7B2D26),
      bg: Color(0xFFFAF3E7),
      icon: Icons.temple_hindu,
    ),
    _TemplateChoice(
      id: 'modern-elegant',
      name: 'Modern Elegant',
      tagline: 'Clean & minimal',
      primary: Color(0xFF1F2937),
      accent: Color(0xFFBFA987),
      bg: Color(0xFFF6F1EA),
      icon: Icons.diamond_outlined,
    ),
    _TemplateChoice(
      id: 'floral-romance',
      name: 'Floral Romance',
      tagline: 'Soft & romantic',
      primary: Color(0xFFD4A5A5),
      accent: Color(0xFFB89292),
      bg: Color(0xFFFFF5F5),
      icon: Icons.local_florist,
    ),
    _TemplateChoice(
      id: 'royal-maroon',
      name: 'Royal Maroon',
      tagline: 'Regal & ornate',
      primary: Color(0xFF7B1E1E),
      accent: Color(0xFFC9A96E),
      bg: Color(0xFFFAF6F0),
      icon: Icons.castle_outlined,
    ),
  ];

  late String _selectedTemplate;

  @override
  void initState() {
    super.initState();
    _selectedTemplate = widget.initialData['templateId'] ?? 'traditional-kerala';
  }

  void _save(String templateId) {
    setState(() => _selectedTemplate = templateId);
    widget.onSaved({'templateId': templateId});
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
          'All templates are free. You can switch later.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        const SizedBox(height: 24),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.78,
          children: _templates
              .map((t) => _TemplateCard(
                    template: t,
                    selected: _selectedTemplate == t.id,
                    onTap: () => _save(t.id),
                  ))
              .toList(),
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
  final VoidCallback onTap;

  const _TemplateCard({
    required this.template,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? template.primary : Colors.grey[300]!,
            width: selected ? 3 : 1,
          ),
          boxShadow: [
            if (selected)
              BoxShadow(
                color: template.primary.withValues(alpha: 0.25),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Thumbnail area — a colored preview with the template's icon.
            // Once we have real PNG thumbnails in assets/templates/, swap this
            // for Image.asset('assets/templates/${template.id}.png').
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: template.bg,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                ),
                child: Stack(
                  children: [
                    // Diagonal accent stripe to differentiate visually
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _TemplateAccentPainter(
                          primary: template.primary,
                          accent: template.accent,
                        ),
                      ),
                    ),
                    // Centered icon
                    Center(
                      child: Icon(
                        template.icon,
                        size: 56,
                        color: template.primary,
                      ),
                    ),
                    // "Selected" check badge
                    if (selected)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: template.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    // Free badge
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: template.accent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'FREE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Name + tagline
            Padding(
              padding: const EdgeInsets.all(12),
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
          ],
        ),
      ),
    );
  }
}

class _TemplateAccentPainter extends CustomPainter {
  final Color primary;
  final Color accent;

  _TemplateAccentPainter({required this.primary, required this.accent});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = accent.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.7)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.5,
        size.width,
        size.height * 0.85,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TemplateAccentPainter old) =>
      old.primary != primary || old.accent != accent;
}
