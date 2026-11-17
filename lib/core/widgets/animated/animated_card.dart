import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// A card with entrance animation, hover lift, and tap scale feedback.
class AnimatedCard extends StatefulWidget {
  const AnimatedCard({
    super.key,
    required this.child,
    this.color,
    this.elevation = 0,
    this.borderRadius = 16.0,
    this.border,
    this.onTap,
    this.onLongPress,
    this.duration = 300,
    this.delay = 0,
    this.curve = Curves.easeOutCubic,
    this.animateOnLoad = true,
    this.padding,
    this.margin,
  });

  final Widget child;
  final Color? color;
  final double elevation;
  final double borderRadius;
  final BoxBorder? border;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final int duration;
  final int delay;
  final Curve curve;
  final bool animateOnLoad;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      margin: widget.margin,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.color ?? Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: widget.border,
        boxShadow: widget.elevation > 0
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: widget.elevation * 2,
                  offset: Offset(0, widget.elevation),
                ),
              ]
            : null,
      ),
      child: widget.child,
    );

    Widget interactive = card;
    if (widget.onTap != null || widget.onLongPress != null) {
      interactive = InkWell(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: card,
      );
    }

    Widget animated = interactive;
    if (widget.animateOnLoad) {
      animated = interactive.animate().fade(duration: widget.duration.ms, delay: widget.delay.ms).slideY(
        begin: 0.12,
        end: 0,
        duration: widget.duration.ms,
        delay: widget.delay.ms,
        curve: widget.curve,
      );
    }

    return AnimatedScale(
      scale: _pressed ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 150),
      child: AnimatedContainer(
        transform: Matrix4.translationValues(0, _hovered ? -6 : 0, 0),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTapDown: (_) => setState(() => _pressed = true),
            onTapUp: (_) => setState(() => _pressed = false),
            onTapCancel: () => setState(() => _pressed = false),
            child: animated,
          ),
        ),
      ),
    );
  }
}

/// A gradient card variant for hero sections.
class GradientCard extends StatelessWidget {
  const GradientCard({
    super.key,
    required this.child,
    required this.gradient,
    this.borderRadius = 22.0,
    this.onTap,
    this.duration = 500,
    this.delay = 0,
  });

  final Widget child;
  final Gradient gradient;
  final double borderRadius;
  final VoidCallback? onTap;
  final int duration;
  final int delay;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: child,
      ),
    );

    Widget interactive = card;
    if (onTap != null) {
      interactive = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: card,
      );
    }

    return interactive
        .animate()
        .fade(duration: duration.ms, delay: delay.ms)
        .slideY(begin: 0.14, end: 0, duration: duration.ms, delay: delay.ms, curve: Curves.easeOutCubic);
  }
}