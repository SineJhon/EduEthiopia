import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// A shimmer loading placeholder for skeleton screens.
class ShimmerLoader extends StatelessWidget {
  const ShimmerLoader({
    super.key,
    this.width = double.infinity,
    this.height = 16.0,
    this.borderRadius = 8.0,
    this.baseColor,
    this.highlightColor,
    this.duration = 1500,
  });

  final double width;
  final double height;
  final double borderRadius;
  final Color? baseColor;
  final Color? highlightColor;
  final int duration;

  @override
  Widget build(BuildContext context) {
    final base = baseColor ?? Theme.of(context).colorScheme.surface;
    final highlight = highlightColor ?? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: base,
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: const LinearGradient(
          colors: [Colors.transparent, Colors.white, Colors.transparent],
          stops: [0.1, 0.3, 0.5],
        ),
      ),
      child: const SizedBox.expand(),
    ).animate().shimmer(
          duration: duration.ms,
          color: highlight.withValues(alpha: 0.6),
        );
  }
}

/// A shimmer card placeholder (e.g., for dashboard tiles).
class ShimmerCard extends StatelessWidget {
  const ShimmerCard({
    super.key,
    this.width = double.infinity,
    this.height = 140.0,
    this.borderRadius = 16.0,
    this.baseColor,
    this.highlightColor,
  });

  final double width;
  final double height;
  final double borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    final base = baseColor ?? Theme.of(context).colorScheme.surface;
    final highlight = highlightColor ?? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: base,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: const SizedBox.expand(),
    ).animate().shimmer(
          duration: 1500.ms,
          color: highlight.withValues(alpha: 0.6),
        );
  }
}

/// Simple pulse animation for attention (e.g., AI FAB).
class PulseWidget extends StatelessWidget {
  const PulseWidget({
    super.key,
    required this.child,
    this.duration = 2000,
    this.scale = 1.15,
  });

  final Widget child;
  final int duration;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return child.animate().scale(
          begin: Offset.zero,
          end: Offset(scale, scale),
          duration: duration.ms,
          curve: Curves.easeInOut,
        ).then().scale(
          begin: Offset(scale, scale),
          end: Offset.zero,
          duration: duration.ms,
          curve: Curves.easeInOut,
        );
  }
}