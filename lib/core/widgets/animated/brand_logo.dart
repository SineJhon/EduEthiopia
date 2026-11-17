import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_theme.dart';

/// Animated brand logo with optional pulse glow and scale-on-tap.
class BrandLogo extends StatefulWidget {
  const BrandLogo({
    super.key,
    this.size = 92.0,
    this.borderWidth = 2.0,
    this.borderColor = AppColors.gold,
    this.onTap,
    this.animateOnLoad = true,
  });

  final double size;
  final double borderWidth;
  final Color borderColor;
  final VoidCallback? onTap;
  final bool animateOnLoad;

  @override
  State<BrandLogo> createState() => _BrandLogoState();
}

class _BrandLogoState extends State<BrandLogo> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final logo = ClipOval(
      child: Image.asset(
        'assets/images/edu_ethiopia_logo.jpg',
        height: widget.size,
        width: widget.size,
        fit: BoxFit.cover,
      ),
    );

    final bordered = Container(
      padding: EdgeInsets.all(widget.borderWidth / 2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: widget.borderColor.withValues(alpha: _hovered ? 0.9 : 0.65),
          width: widget.borderWidth,
        ),
      ),
      child: logo,
    );

    Widget child = bordered;

    if (widget.onTap != null) {
      child = InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(widget.size / 2 + widget.borderWidth),
        child: bordered,
      );
    }

    if (widget.animateOnLoad) {
      child = child
          .animate()
          .scale(delay: 200.ms, duration: 700.ms, curve: Curves.elasticOut)
          .shimmer(duration: 2000.ms, delay: 1000.ms, color: widget.borderColor.withValues(alpha: 0.35));
    }

    return AnimatedScale(
      scale: _hovered ? 1.05 : 1.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: child,
      ),
    );
  }
}