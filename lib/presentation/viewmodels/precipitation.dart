import 'package:flutter/widgets.dart';
import 'package:main/ca/domain/weather_entities.dart';
import 'package:main/presentation/viewmodels/resource.dart';
import 'package:provider/provider.dart';

import '../../ca/domain/weather_service.dart';

class PrecipitationVmProvider extends StatelessWidget {
  final Widget child;

  const PrecipitationVmProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherService>(
      builder: (context, weatherService, _) {
        return ChangeNotifierProvider(
          create: (_) => PrecipitationViewModel(weatherService)..init(),
          child: child,
        );
      },
    );
  }
}

class PrecipitationViewModel with ChangeNotifier {
  final WeatherService _weatherService;

  PrecipitationViewModel(this._weatherService);

  Resource<Map<DayOfWeek, double>> _precipitations = ResourceLoading();
  Resource<Map<DayOfWeek, double>> get precipitations => _precipitations;

  Future<void> init() {
    return _refresh();
  }

  Future<void> refresh() async {
    _precipitations = ResourceLoading();
    notifyListeners();
    return _refresh();
  }

  Future<void> _refresh() async {
    _precipitations = ResourceSuccess(await _weatherService.getTotalPrecipitationLast7Days());
    notifyListeners();
  }
}
