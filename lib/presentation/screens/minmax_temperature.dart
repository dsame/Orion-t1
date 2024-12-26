import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:main/ca/domain/weather_entities.dart';
import 'package:main/presentation/viewmodels/minmax_temperature.dart';
import 'package:main/presentation/widgets/line_chart.dart';
import 'package:provider/provider.dart';

import '../viewmodels/resource.dart';

class MinMaxTemperatureWidget extends StatelessWidget {
  const MinMaxTemperatureWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: overengineered, VM provided in the same point where it is consumed
    // reason: it is similar to calling VM factory
    // justification: we still have decoupling between the view and the viewmodel
    return MinMaxTemperatureVmProvider(
        child: Consumer<MinMaxTemperatureViewModel>(builder: (context, vm, _) {
      switch (vm.measurements) {
        case ResourceLoading _:
          return const Center(child: CircularProgressIndicator());
        case ResourceError r:
          // TODO: extract error message more carefully
          return Center(child: Text('Error: ${r.error}'));
        case ResourceSuccess r:
          return MinMaxTemperatureSuccessWidget(measurements: r.data);
        default:
          throw Exception('Unknown resource type: $vm.measurements');
      }
    }));
  }
}

class MinMaxTemperatureSuccessWidget extends StatelessWidget {
  final Map<DayOfWeek, MinMaxTemperature> measurements;

  const MinMaxTemperatureSuccessWidget({super.key, required this.measurements});

  @override
  Widget build(BuildContext context) {
    // the data from the service can have missing days
    // I sanitize it here because it is matter of UI
    // how to show missing data
    final List<double> min = List.generate(
            7,
            (index) =>
                measurements[DayOfWeekExt.fromIntZero(index)]?.min ?? 0.0)
        .map((e) => e == double.negativeInfinity ? 0.0 : e)
        .toList();
    final List<double> max = List.generate(
            7,
            (index) =>
                measurements[DayOfWeekExt.fromIntZero(index)]?.max ?? 0.0)
        .map((e) => e == double.infinity ? 0.0 : e)
        .toList();
    return LineChartWidget(line1Data: min, line2Data: max);
  }
}
