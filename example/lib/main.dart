import 'package:custom_animated_switcher/custom_animated_switcher.dart';
import 'package:flutter/material.dart';

// Import the CustomAnimatedSwitcher and related components

void main() {
  // Runs the Flutter app by calling the runApp() function
  runApp(const MyApp());
}

/// The root widget for the application.
///
/// This widget sets up the MaterialApp and the main theme of the application.
class MyApp extends StatelessWidget {
  /// Default constructor for the MyApp widget.
  const MyApp({super.key});

  /// Builds the root widget tree for the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomeScreen(), // Set the main screen of the application.
    );
  }
}

/// The main screen of the application.
///
/// This screen demonstrates how to use the CustomAnimatedSwitcher widget.
class MyHomeScreen extends StatefulWidget {
  /// Default constructor for the MyHomeScreen widget.
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomePageState();
}

/// The state class for the MyHomeScreen widget.
class _MyHomePageState extends State<MyHomeScreen> {
  /// Indicates whether the loading/primary content is currently visible.
  bool _isLoading = false;

  /// Builds the UI for the main screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Custom Animated Switcher"),
      ),
      body: Center(
        // Wrap the CustomAnimatedSwitcher with a Center widget
        child: CustomAnimatedSwitcher(
          showPrimary:
              _isLoading, // Toggle between primary and secondary widget based on loading
          animationType: AnimationType
              .clipReveal, // Set the animation type to 'clipReveal'
          animationCurve: Curves
              .fastOutSlowIn, // Set the animation curve for smooth transition.
          animationDuration: const Duration(
            milliseconds: 500,
          ), // Set animation duration to 500 ms
          primaryWidget: ListView.builder(
              // Build a list view as the primary widget
              itemCount: 20,
              itemBuilder: (_, index) => Text('Data: $index')),
          secondaryWidget:
              const CircularProgressIndicator(), // Display CircularProgressIndicator when loading
        ),
      ),
      // Toggle button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isLoading = !_isLoading; // Toggle the loading state
          });
        },
        // Display a visibility icon depending on the state
        child: Icon(_isLoading ? Icons.visibility_off : Icons.visibility),
      ),
    );
  }
}
