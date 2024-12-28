import 'package:flutter/material.dart';
import 'package:main/ca/domain/weather_entities.dart';
import 'package:provider/provider.dart';

import '../viewmodels/resource.dart';
import '../viewmodels/windrose.dart';
import '../widgets/radar_chart.dart';

class WindroseWidget extends StatelessWidget {
  const WindroseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return WindroseVmProvider(
        child: Consumer<WindroseViewModel>(builder: (context, vm, _) {
      switch (vm.windroseModel) {
        case ResourceLoading _:
          return const Center(child: CircularProgressIndicator());
        case ResourceSuccess r:
          return WindroseSuccess(r.data);
        case ResourceError r:
          return Center(child: Text('Error: ${r.error}'));
        default:
          throw Exception('Unknown resource type: $vm.windroseModel');
      }
    }));
  }
}

class WindroseSuccess extends StatelessWidget {
  final Map<WindDirection, int> _windrose;

  const WindroseSuccess(this._windrose, {super.key});

  @override
  Widget build(BuildContext context) {
    final Map<WindDirection, double> windroseData =
        _windrose.map((key, value) => MapEntry(key, value.toDouble()));

    return RadarChartWidget(
        data: windroseData, formatRadius: (double v) => v.toStringAsFixed(0), formatVertex: (double v) => '${v.toStringAsFixed(0)}',);
  }
}
