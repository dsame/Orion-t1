import 'package:flutter/material.dart';

class ThemedAppWidget extends StatelessWidget {
  final String _title;
  final Widget _child;

  const ThemedAppWidget({super.key, required title, required child})
      : _title = title,
        _child = child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: _title,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: _child);
  }
}
