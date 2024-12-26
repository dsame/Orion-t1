import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:main/presentation/screens/minmax_temperature.dart';
import 'package:main/presentation/screens/precipitation.dart';

import '../screens/windrose.dart';

class DefaultTabControllerScaffold extends StatelessWidget {
  const DefaultTabControllerScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
          length: 3,
          child: Scaffold(
            bottomNavigationBar: TabBar(
              tabs: [
                Tab(
                    icon: SvgPicture.asset(
                      'assets/chart_bar.svg', // Path to your SVG asset
                      height: 24.0, // You can adjust the size
                      width: 24.0, // You can adjust the size
                    )),
                Tab(
                    icon: SvgPicture.asset(
                      'assets/chart_lines.svg', // Path to your SVG asset
                      height: 24.0, // You can adjust the size
                      width: 24.0, // You can adjust the size
                    )),
                Tab(
                    icon: SvgPicture.asset(
                      'assets/chart_windrose.svg', // Path to your SVG asset
                      height: 24.0, // You can adjust the size
                      width: 24.0, // You can adjust the size
                    )),
              ],
            ),
            body: const TabBarView(
              children: [
                PrecipitationWidget(),
                MinMaxTemperatureWidget(),
                WindroseWidget(),
                /*
                WindroseChartWidget(
                  data: const {
                    WindDirection.N: 50,
                    WindDirection.NE: 30,
                    WindDirection.E: 70,
                    WindDirection.SE: 20,
                    WindDirection.S: 80,
                    WindDirection.SW: 48,
                    WindDirection.W: 160,
                    WindDirection.NW: 87,
                  },
                ),*/
              ],
            ),
          ),
        ); //const MyHomePage(title: 'Flutter Demo Home Page'),
  }
}