import 'package:flutter/widgets.dart';
import 'package:main/ca/domain/weather_service.dart';
import 'package:main/presentation/viewmodels/resource.dart';
import 'package:provider/provider.dart';

import '../../ca/domain/weather_entities.dart';

class WindroseVmProvider extends StatelessWidget {
  final Widget child;

  const WindroseVmProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherService>(
      builder: (context, weatherService, _) {
        return ChangeNotifierProvider(
          create: (_) => WindroseViewModel(weatherService)..init(),
          child: child,
        );
      },
    );
  }
}

class WindroseViewModel with ChangeNotifier {
  final WeatherService _weatherService;
  Resource<Map<WindDirection, int>> _windroseModel = ResourceLoading();
  Resource<Map<WindDirection, int>> get windroseModel => _windroseModel;

  WindroseViewModel(this._weatherService);

  Future<void> init() {
    return _refresh();
  }

  Future<void> refresh() async {
    _windroseModel = ResourceLoading();
    notifyListeners();
    return _refresh();
  }

  Future<void> _refresh() async {
    _windroseModel = ResourceSuccess(await _weatherService.getWindRoseLast7Days());
    notifyListeners();
  }
}