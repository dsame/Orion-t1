import 'package:flutter/material.dart';
import 'package:main/presentation/viewmodels/precipitation.dart';
import 'package:main/presentation/widgets/bar_chart.dart';
import 'package:provider/provider.dart';

import '../../ca/domain/weather_entities.dart';
import '../viewmodels/resource.dart';

class PrecipitationWidget extends StatelessWidget {
  const PrecipitationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PrecipitationVmProvider(
      child: Consumer<PrecipitationViewModel>(
        builder: (context, vm, _) {
          switch (vm.precipitations) {
            case ResourceLoading _:
              return const Center(child: CircularProgressIndicator());
            case ResourceSuccess r:
              return PrecipitationWidgetSuccess(precipitations: r.data);
            case ResourceError r:
              // TODO: extract error message more carefully
              return Center(child: Text('Error: ${r.error}'));
            default:
              throw Exception('Unknown resource type: $vm.precipitations');
          }
        },
      ),
    );
  }
}

class PrecipitationWidgetSuccess extends StatelessWidget {
  final List<DayPrecipitation> _precipitations;

  const PrecipitationWidgetSuccess({super.key, required precipitations})
      : _precipitations = precipitations;

  @override
  Widget build(BuildContext context) {
    final List<double> data = List.filled(_precipitations.length, 0);
    final List<String> labels = List.filled(_precipitations.length, '');

    var index = 0;
    _precipitations.forEach((dayPrecipitation) {
      labels[index] = DayOfWeekExt.fromDateTime(dayPrecipitation.day).toString();
      data[index] = dayPrecipitation.precipitation;
      index++;
    });
    return BarChartWidget(data: data, labels: labels);
  }
}
