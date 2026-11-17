import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_theme.dart';

/// A magnetic / springy button that scales on tap and glows on hover.
class MagneticButton extends StatefulWidget {
  const MagneticButton({
    super.key,
    this.child,
    this.onPressed,
    this.backgroundColor = AppColors.green,
    this.foregroundColor = Colors.white,
    this.borderRadius = 16.0,
    this.height = 56.0,
    this.width,
    this.elevation = 4,
    this.icon,
    this.label,
    this.animateOnLoad = true,
    this.duration = 400,
    this.delay = 0,
  });

  final Widget? child;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final double borderRadius;
  final double height;
  final double? width;
  final double elevation;
  final Widget? icon;
  final String? label;
  final bool animateOnLoad;
  final int duration;
  final int delay;

  @override
  State<MagneticButton> createState() => _MagneticButtonState();
}

class _MagneticButtonState extends State<MagneticButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final button = FilledButton.icon(
      onPressed: widget.onPressed,
      icon: widget.icon ?? const SizedBox.shrink(),
      label: widget.label != null ? Text(widget.label!) : const SizedBox.shrink(),
      style: FilledButton.styleFrom(
        backgroundColor: widget.backgroundColor,
        foregroundColor: widget.foregroundColor,
        minimumSize: Size(widget.width ?? double.infinity, widget.height),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.borderRadius)),
        elevation: widget.elevation,
        shadowColor: widget.backgroundColor.withValues(alpha: 0.35),
        padding: const EdgeInsets.symmetric(horizontal: 24),
      ),
    );

    Widget interactive = AnimatedScale(
      scale: _pressed ? 0.95 : 1.0,
      duration: const Duration(milliseconds: 120),
      child: button,
    );

    interactive = AnimatedContainer(
      transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      child: interactive,
    );

    interactive = MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: interactive,
      ),
    );

    Widget result = interactive;
    if (widget.animateOnLoad) {
      result = result
          .animate()
          .fade(duration: widget.duration.ms, delay: widget.delay.ms)
          .slideY(begin: 0.16, end: 0, duration: widget.duration.ms, delay: widget.delay.ms, curve: Curves.easeOutCubic);
    }

    return result;
  }
}

/// Outlined variant of the magnetic button.
class MagneticOutlineButton extends StatefulWidget {
  const MagneticOutlineButton({
    super.key,
    required this.child,
    this.onPressed,
    this.borderColor = AppColors.green,
    this.foregroundColor = AppColors.darkGreen,
    this.borderRadius = 16.0,
    this.height = 56.0,
    this.width,
    this.animateOnLoad = true,
    this.duration = 400,
    this.delay = 0,
  });

  final Widget? child;
  final VoidCallback? onPressed;
  final Color borderColor;
  final Color foregroundColor;
  final double borderRadius;
  final double height;
  final double? width;
  final bool animateOnLoad;
  final int duration;
  final int delay;

  @override
  State<MagneticOutlineButton> createState() => _MagneticOutlineButtonState();
}

class _MagneticOutlineButtonState extends State<MagneticOutlineButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final button = OutlinedButton.icon(
      onPressed: widget.onPressed,
      label: widget.child ?? const Text(''),
      style: OutlinedButton.styleFrom(
        foregroundColor: widget.foregroundColor,
        side: BorderSide(
          color: widget.borderColor.withValues(alpha: _hovered ? 0.9 : 0.3),
          width: 1.5,
        ),
        minimumSize: Size(widget.width ?? double.infinity, widget.height),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.borderRadius)),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        backgroundColor: _hovered ? widget.borderColor.withValues(alpha: 0.05) : Colors.transparent,
      ),
    );

    return AnimatedScale(
      scale: _pressed ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 120),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTapDown: (_) => setState(() => _pressed = true),
            onTapUp: (_) => setState(() => _pressed = false),
            onTapCancel: () => setState(() => _pressed = false),
            child: widget.animateOnLoad
                ? button.animate().fade(duration: widget.duration.ms, delay: widget.delay.ms).slideY(
                      begin: 0.16, end: 0,
                      duration: widget.duration.ms,
                      delay: widget.delay.ms,
                      curve: Curves.easeOutCubic,
                    )
                : button,
          ),
        ),
      ),
    );
  }
}

/// Simple text link button with hover underline animation.
class MagneticTextButton extends StatefulWidget {
  const MagneticTextButton({
    super.key,
    required this.label,
    this.onPressed,
    this.color = AppColors.green,
    this.animateOnLoad = true,
    this.duration = 400,
    this.delay = 0,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final bool animateOnLoad;
  final int duration;
  final int delay;

  @override
  State<MagneticTextButton> createState() => _MagneticTextButtonState();
}

class _MagneticTextButtonState extends State<MagneticTextButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final button = TextButton(
      onPressed: widget.onPressed,
      child: Text(
        widget.label,
        style: TextStyle(
          color: widget.color,
          fontWeight: FontWeight.w700,
          decoration: _hovered ? TextDecoration.underline : TextDecoration.none,
        ),
      ),
    );

    return AnimatedScale(
      scale: _hovered ? 1.05 : 1.0,
      duration: const Duration(milliseconds: 150),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: widget.animateOnLoad
            ? button.animate().fade(duration: widget.duration.ms, delay: widget.delay.ms).slideY(
                  begin: 0.1, end: 0,
                  duration: widget.duration.ms,
                  delay: widget.delay.ms,
                  curve: Curves.easeOutCubic,
                )
            : button,
      ),
    );
  }
}