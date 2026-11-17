import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Custom page route with a shared-axis slide + fade animation.
class SlideFadeRoute<T> extends PageRouteBuilder<T> {
  SlideFadeRoute({required WidgetBuilder builder, Duration duration = const Duration(milliseconds: 450)})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child
                .animate()
                .fade(duration: duration)
                .slideX(begin: 0.12, end: 0, duration: duration, curve: Curves.easeOutCubic);
          },
          transitionDuration: duration,
        );
}

/// Helper to push a screen with a slide-fade transition.
Future<T?> slideFadePush<T>(BuildContext context, WidgetBuilder builder) {
  return Navigator.of(context).push<T>(
    SlideFadeRoute<T>(builder: builder),
  );
}

/// Helper to push and remove previous routes with slide-fade.
Future<T?> slideFadePushReplacement<T>(BuildContext context, WidgetBuilder builder) {
  return Navigator.of(context).pushReplacement<T, T?>(
    SlideFadeRoute<T>(builder: builder),
  );
}

/// A widget that animates its content when it first appears.
class Reveal extends StatelessWidget {
  const Reveal({
    super.key,
    required this.child,
    this.duration = 600,
    this.delay = 0,
    this.curve = Curves.easeOutCubic,
    this.beginOffset = const Offset(0, 0.1),
  });

  final Widget child;
  final int duration;
  final int delay;
  final Curve curve;
  final Offset beginOffset;

  @override
  Widget build(BuildContext context) {
    return child
        .animate()
        .fade(duration: duration.ms, delay: delay.ms)
        .slide(begin: beginOffset, end: Offset.zero, duration: duration.ms, delay: delay.ms, curve: curve);
  }
}

/// Staggered list animation wrapper. Use with ListView.builder or Column children.
class StaggeredList extends StatelessWidget {
  const StaggeredList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.duration = 400,
    this.stagger = 80,
    this.curve = Curves.easeOutCubic,
  });

  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final int duration;
  final int stagger;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return itemBuilder(context, index).animate().fade(
              duration: duration.ms,
              delay: (stagger * index).ms,
            ).slideY(
              begin: 0.1,
              end: 0,
              duration: duration.ms,
              delay: (stagger * index).ms,
              curve: curve,
            );
      },
    );
  }
}