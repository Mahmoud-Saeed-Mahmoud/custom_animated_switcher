# Custom Animated Switcher

A versatile Flutter widget that provides animated transitions between two widgets, offering a variety of customizable effects.

## Features

- **Multiple Animation Types:** Choose from `clipReveal`, `slideFade` transitions.
- **Customizable Animations:**
  - Control animation duration, curves, and direction.
  - Use custom clippers for unique reveal effects.
- **Easy to Use:**  Simple API for quickly integrating animated transitions.
- **Reusable:** Designed to be versatile and adaptable for various use cases.

## Getting Started

To use this widget, add it to your project and import the necessary file:

```yaml
  dependencies:
    flutter:
      sdk: flutter
    custom_animated_switcher: ^1.0.0
```

## Usage

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomeScreen(),
    );
  }
}

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomeScreen> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Custom Animated Switcher"),
      ),
      body: Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: CustomAnimatedSwitcher(
            showPrimary: _isLoading,
            animationType: AnimationType.clipReveal,
            animationCurve: Curves.fastOutSlowIn,
            animationDuration: const Duration(milliseconds: 500),
            primaryWidget: ListView.builder(
                itemCount: 20, itemBuilder: (_, index) => Text('Data: $index')),
            secondaryWidget: const CircularProgressIndicator(),
            clipper: const CircularRevealClipper(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isLoading = !_isLoading;
          });
        },
        child: Icon(_isLoading ? Icons.visibility_off : Icons.visibility),
      ),
    );
  }
}
```

## Parameters

The `CustomAnimatedSwitcher` accepts the following parameters:

-   `showPrimary`: **(required `bool`)** Determines whether the `primaryWidget` is currently visible (`true`) or if the `secondaryWidget` should be displayed (`false`).
-   `secondaryWidget`: **(required `Widget`)** The widget that is displayed when `showPrimary` is `false`.
-   `primaryWidget`: **(required `Widget`)** The widget that is displayed when `showPrimary` is `true`.
-   `animationDuration`: **(`Duration`, optional)** The total duration of the transition animation. Defaults to `500 milliseconds`.
-   `clipper`: **(`CustomClipper<Path>?`, optional)** An optional custom clipper that is used to clip the `primaryWidget` during transitions. When not provided the widget will still be animated but without clipping effect.
-   `animationCurve`: **(`Curve`, optional)** The animation curve used for the main scaling and clipping animation. Defaults to `Curves.easeInOut`.
-   `slideCurve`: **(`Curve`, optional)** The animation curve used for the sliding animation effect, applied when `animationType` is `slideFade`. Defaults to `Curves.easeInOut`.
-   `fadeCurve`: **(`Curve`, optional)** The animation curve used for the fading animation effect. Defaults to `Curves.easeInOut`.
-   `horizontalSlide`: **(`bool`, optional)** When set to `true`, the slide animation (when using `slideFade`) occurs horizontally. When `false`, it slides vertically. Defaults to `true`.
-   `animationType`: **(`AnimationType`, optional)**  Determines the type of transition animation used. It can be either `clipReveal` for a scaling and clipping animation, or `slideFade` for a sliding and fading animation.  Defaults to `clipReveal`.

## Animation Types

The `animationType` parameter accepts the following values from the `AnimationType` enum, which determines the transition animation:

-   `clipReveal`:
    -   Applies a **clip and scale reveal** animation to the `primaryWidget`.
    -   The widget scales up from the center while revealing itself based on the configured `clipper`.
    -   It uses the `animationCurve` for the scaling and reveal effect.
    -  When no clipper is provided the widget scales up with no clipping effect.
-   `slideFade`:
    -   Applies a **slide and fade** animation to the `primaryWidget`.
    -   The widget slides into view using the `slideCurve` from either the left or top based on `horizontalSlide`, while scaling in, and the secondary widget fades out.
    -   It uses the `fadeCurve` for the fading effect.
    - Uses the main `animationCurve` for scaling animation.

## Customization

You can fine-tune the animation effects of the `CustomAnimatedSwitcher` using the following parameters:

-   **`animationDuration`:**
    -   Adjust the `animationDuration` parameter (a `Duration` value) to control how long the transition animation takes.
    -   A shorter duration will result in a faster animation, and a longer duration will slow it down.
    -   Example: `animationDuration: const Duration(milliseconds: 300)` for a quick animation.

-   **`animationCurve`:**
    -   The `animationCurve` parameter (a `Curve` object) determines the speed curve for the primary scale and clip reveal animation (when using `clipReveal` animationType) and the scale animation in `slideFade` type animation.
    -   You can use any pre-defined Flutter curves (e.g., `Curves.easeInOut`, `Curves.easeIn`, `Curves.bounceOut`) or create your own custom curve.
    -   Example: `animationCurve: Curves.easeOutQuad` for an animation that starts quickly and slows down.

-   **`slideCurve`:**
    -    The `slideCurve` parameter (a `Curve` object) determines the speed curve for the slide animation effect when using `slideFade` animation type.
     - You can use any pre-defined Flutter curves (e.g., `Curves.easeInOut`, `Curves.easeIn`, `Curves.bounceOut`) or create your own custom curve.
    -   Example: `slideCurve: Curves.easeOutCubic` for a slide that starts quickly and slows down.

-   **`fadeCurve`:**
    -   The `fadeCurve` parameter (a `Curve` object) controls the speed curve for the fade effect that happens with `secondaryWidget` in all the animations.
    -   You can use any pre-defined Flutter curves (e.g., `Curves.easeInOut`, `Curves.easeIn`, `Curves.bounceOut`) or create your own custom curve.
    -   Example: `fadeCurve: Curves.easeInSine` for a fade that starts slow and gains speed.

-   **`clipper`:**
    -   The `clipper` parameter lets you use a `CustomClipper<Path>` to define the shape of the reveal effect during the `clipReveal` animation or the slide-in effect in `slideFade`.
    -   You can use the included `CircularRevealClipper`, `RectangularRevealClipper`, or implement your own custom clipper for unique shapes.
     - Example: `clipper: const CircularRevealClipper()` or `clipper: MyCustomClipper()`
        - Note that when no clipper is provided the animation still works but without clipping effect.

-  **`horizontalSlide`:**
    - The `horizontalSlide` parameter (a boolean) affects the slide direction when using the `slideFade` animationType.
        -  Setting `horizontalSlide` to `true` causes the `primaryWidget` to slide in horizontally (from right to left).
        - Setting `horizontalSlide` to `false` causes the `primaryWidget` to slide in vertically (from top to bottom).
     -  Example: `horizontalSlide: false` for a vertical slide transition.

By combining these customization options, you can create a wide range of transition effects.

## Example Custom Clipper

To create a custom clipping effect you can create your own `CustomClipper<Path>`. Here's an example of a rectangular clipper that you can use as a base for more complex effects.

```dart
class RectangularRevealClipper extends CustomClipper<Path> {
  const RectangularRevealClipper();
  @override
  Path getClip(Size size) {
    return Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Changelog

See the [CHANGELOG.md](CHANGELOG.md) file for a detailed history of changes.

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.