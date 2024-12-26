import 'package:flutter/material.dart';
import 'package:main/presentation/scaffolds/default_tab_controller.dart';
import 'package:main/presentation/theme/app.dart';

import 'di.dart';

void main() {
  runApp(const AppDependenciesProvider(
      child: ThemedAppWidget(
          title: "Orion task#1", child: DefaultTabControllerScaffold())));
}
