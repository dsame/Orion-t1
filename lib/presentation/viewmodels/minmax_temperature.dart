import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../ca/domain/weather_entities.dart';
import '../../ca/domain/weather_service.dart';
import 'resource.dart';

class MinMaxTemperatureVmProvider extends StatelessWidget {
  final Widget child;

  const MinMaxTemperatureVmProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherService>(
      builder: (context, weatherService, _) {
        return ChangeNotifierProvider(
          create: (_) => MinMaxTemperatureViewModel(weatherService)..init(),
          child: child,
        );
      },
    );
  }
}

class MinMaxTemperatureViewModel with ChangeNotifier {
  final WeatherService _weatherService;
  Resource<Map<DayOfWeek, MinMaxTemperature>> _measurements = ResourceLoading();

  Resource<Map<DayOfWeek, MinMaxTemperature>> get measurements => _measurements;

  MinMaxTemperatureViewModel(this._weatherService);

  Future<void> init() {
    return _refresh();
  }

  Future<void> refresh() async {
    _measurements = ResourceLoading();
    notifyListeners();
    return _refresh();
  }

  // TODO: handle errors
  Future<void> _refresh() async {
    _measurements =
        ResourceSuccess(await _weatherService.getMinMaxTemperatureLast7Days());
    notifyListeners();
  }
}
