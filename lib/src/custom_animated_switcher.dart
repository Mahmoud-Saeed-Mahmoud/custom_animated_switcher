import 'dart:math';

import 'package:flutter/material.dart';

/// An enum to define the types of transition animations.
enum AnimationType {
  /// Represents a clip and scale reveal animation.
  clipReveal,

  /// Represents a slide and fade animation.
  slideFade,
}

/// A custom clipper that creates a circular reveal effect.
/// This clipper is used to clip the child widget during the animation.
class CircularRevealClipper extends CustomClipper<Path> {
  /// Default constructor for the CircularRevealClipper.
  const CircularRevealClipper();

  /// Creates a circular path for clipping based on the size of the widget.
  @override
  Path getClip(Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = sqrt(pow(size.width / 2, 2) + pow(size.height / 2, 2));

    return Path()..addOval(Rect.fromCircle(center: center, radius: maxRadius));
  }

  /// Indicates whether the clipper should reclip. This clipper should not reclip once its created.
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// A versatile widget that animates transitions between two widgets.
///
/// The [CustomAnimatedSwitcher] widget allows for animated transitions between a primary
/// and a secondary widget. The transition type can be customized using the [animationType]
/// parameter. This widget supports two animation types: a basic clip/scale reveal, or a
/// slide-in/slide-out with a fade effect.
class CustomAnimatedSwitcher extends StatefulWidget {
  /// Determines whether the primary widget is currently visible.
  final bool showPrimary;

  /// The widget displayed when the primary widget is not shown.
  final Widget secondaryWidget;

  /// The main widget that is displayed when `showPrimary` is true.
  final Widget primaryWidget;

  /// The duration of the transition animation.
  final Duration animationDuration;

  /// Optional clipper to clip the primary widget during animation.
  final CustomClipper<Path>? clipper;

  /// The animation curve for the main animation (clip/scale).
  final Curve animationCurve;

  /// The animation curve for the slide animation.
  final Curve slideCurve;

  /// The animation curve for the fade animation.
  final Curve fadeCurve;

  /// Indicates whether the slide animation should be horizontal or vertical.
  final bool horizontalSlide;

  /// The type of animation to use for the transition.
  final AnimationType animationType;

  /// Creates a [CustomAnimatedSwitcher] widget.
  const CustomAnimatedSwitcher({
    super.key,
    required this.showPrimary,
    required this.secondaryWidget,
    required this.primaryWidget,
    this.animationDuration = const Duration(milliseconds: 500),
    this.clipper,
    this.animationCurve = Curves.easeInOut,
    this.slideCurve = Curves.easeInOut,
    this.fadeCurve = Curves.easeInOut,
    this.horizontalSlide = true,
    this.animationType = AnimationType.clipReveal,
  });

  @override
  CustomAnimatedSwitcherState createState() => CustomAnimatedSwitcherState();
}

/// The state class for the [CustomAnimatedSwitcher] widget.
class CustomAnimatedSwitcherState extends State<CustomAnimatedSwitcher>
    with SingleTickerProviderStateMixin {
  /// Animation controller to manage all the animations.
  late AnimationController _controller;

  /// The main animation for scaling and clipping.
  late Animation<double> _animation;

  /// Animation for the fade effect of the secondary widget.
  late Animation<double> _opacityAnimation;

  /// Animation for the slide effect of the primary widget.
  late Animation<Offset> _slideAnimation;

  /// Builds the widget tree based on the current animation state.
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            //primaryWidget Widget
            // Conditionally render animations based on animation type
            if (widget.animationType == AnimationType.clipReveal)
              _buildClipRevealAnimation()
            else
              _buildSlideFadeAnimation(),
            // Secondary Widget's Fade Transition
            if (!widget.showPrimary)
              FadeTransition(
                opacity: _opacityAnimation,
                child: Center(
                  child: widget.secondaryWidget,
                ),
              ),
          ],
        );
      },
    );
  }

  /// Called when the widget's configuration has changed.
  @override
  void didUpdateWidget(covariant CustomAnimatedSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if `showPrimary` state changed, animate controller accordingly
    if (oldWidget.showPrimary != widget.showPrimary) {
      if (!widget.showPrimary) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
    }
  }

  /// Disposes of the animation controller.
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Initializes the animation controller and animation objects.
  @override
  void initState() {
    super.initState();
    // Initialize the animation controller with the given duration
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    // Initialize the main animation with a curve
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.animationCurve,
    );

    // Initialize fade animation for the secondary widget
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _controller, curve: widget.fadeCurve));

    // Initialize slide animation for primary widget based on horizontal/vertical configuration
    _slideAnimation = Tween<Offset>(
      begin: widget.horizontalSlide
          ? const Offset(1.0, 0.0)
          : const Offset(0.0, 1.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(parent: _controller, curve: widget.slideCurve));

    // If `showPrimary` is already true, set animation to the end
    if (widget.showPrimary) {
      _controller.value = 1.0;
    }
  }

  /// Builds the widget tree for the clip/scale reveal animation.
  Widget _buildClipRevealAnimation() {
    return widget.clipper != null
        ? ClipPath(
            clipper: widget.clipper!,
            child: Transform.scale(
                scale: _animation.value,
                alignment: Alignment.center,
                child: widget.primaryWidget),
          )
        : Transform.scale(
            scale: _animation.value,
            alignment: Alignment.center,
            child: widget.primaryWidget);
  }

  /// Builds the widget tree for the slide and fade animation.
  Widget _buildSlideFadeAnimation() {
    return widget.clipper != null
        ? ClipPath(
            clipper: widget.clipper!,
            child: Transform.scale(
              scale: _animation.value,
              alignment: Alignment.center,
              child: SlideTransition(
                  position: _slideAnimation, child: widget.primaryWidget),
            ),
          )
        : Transform.scale(
            scale: _animation.value,
            alignment: Alignment.center,
            child: SlideTransition(
                position: _slideAnimation, child: widget.primaryWidget),
          );
  }
}

/// Example of a rectangular clipper.
/// This can be used in place of the circular clipper
class RectangularRevealClipper extends CustomClipper<Path> {
  /// Default constuctor for the RectangularRevealClipper
  const RectangularRevealClipper();

  /// Creates a rectangular path for clipping
  @override
  Path getClip(Size size) {
    return Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
  }

  /// Indicates whether the clipper should reclip. This clipper should not reclip once its created.
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
