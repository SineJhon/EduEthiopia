import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// An animated promise chip with scale-on-tap and staggered entrance.
class AnimatedChip extends StatefulWidget {
  const AnimatedChip({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
    this.duration = 500,
    this.delay = 0,
    this.height = 60.0,
    this.animateOnLoad = true,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  final int duration;
  final int delay;
  final double height;
  final bool animateOnLoad;

  @override
  State<AnimatedChip> createState() => _AnimatedChipState();
}

class _AnimatedChipState extends State<AnimatedChip> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final chip = Container(
      height: widget.height,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: widget.color.withValues(alpha: 0.18)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(widget.icon, color: widget.color, size: 20),
          const SizedBox(height: 3),
          Text(
            widget.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
        ],
      ),
    );

    return AnimatedScale(
      scale: _pressed ? 0.94 : 1.0,
      duration: const Duration(milliseconds: 120),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: widget.animateOnLoad != false
            ? chip.animate().fade(duration: widget.duration.ms, delay: widget.delay.ms).scale(
                  begin: const Offset(0.92, 0.92),
                  end: Offset.zero,
                  duration: widget.duration.ms,
                  delay: widget.delay.ms,
                  curve: Curves.elasticOut,
                )
            : chip,
      ),
    );
  }
}