import 'package:flutter/material.dart';
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
  final List<MinMaxTemperature> measurements;

  const MinMaxTemperatureSuccessWidget({super.key, required this.measurements});

  @override
  Widget build(BuildContext context) {
    // the data from the service can have missing days
    // They should be sanitized here because it is matter of UI
    // how to show missing data, currently they replaced with zeros
    final List<double> min = List.filled( measurements.length, 0.0);
    final List<double> max = List.filled( measurements.length, 0.0);
    final List<String> labels = List.filled( measurements.length, '');

    var index = 0;
    measurements.forEach((measurement) {
      labels[index] = DayOfWeekExt.fromDateTime(measurement.day).toShortLabel();
      min[index] = measurement.min;
      max[index] = measurement.max;
      index++;
    });
    return LineChartWidget(line1Data: min, line2Data: max);
  }
}
/*
extension on DayOfWeek {
  String toShortLabel() {
    switch (this) {
      case DayOfWeek.MON:
        return 'Mon';
      case DayOfWeek.TUE:
        return 'Tue';
      case DayOfWeek.WED:
        return 'Wed';
      case DayOfWeek.THU:
        return 'Thu';
      case DayOfWeek.FRI:
        return 'Fri';
      case DayOfWeek.SAT:
        return 'Sat';
      case DayOfWeek.SUN:
        return 'Sun';
    }
  }
}
 */