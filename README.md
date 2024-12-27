# PoC for Flutter architecture

## Quick Preview

Web version is available at [https://orion-1.web.app](https://orion-1.web.app)

## Overview

- `main`
    - `AppDependenciesProvider`[⤴](https://github.com/dsame/orion-t1/blob/main/lib/di.dart) - adds application live-time
      dependencies with
      `MultiProvider`[⤴](https://github.com/dsame/orion-t1/blob/2a35827429472afa3c8925571615ce80b59cef21/lib/di.dart#L28C1-L33C7)
  > currently only `WeatherService`
    - `ThemedAppWidget` - instantiate `MaterialApp` with default material3 `ThemeData`
    -
    `DefaultTabControllerScaffold`[⤴](https://github.com/dsame/orion-t1/blob/main/lib/presentation/scaffolds/default_tab_controller.dart) -
    a child of `ThemedAppWidget` that adds a `DefaultTabController` to
    the widget tree with 3 tabs(screens)
        -
        `PrecipitationWidget`[⤴](https://github.com/dsame/orion-t1/blob/main/lib/presentation/screens/precipitation.dart) -
        a screen that shows precipitation data (bar chart)
        -
        `MinMaxTemperatureWidget`[⤴](https://github.com/dsame/orion-t1/blob/main/lib/presentation/screens/minmax_temperature.dart) -
        a screen that shows min/max temperature data (line chart)
        - `WindroseWidget`[⤴](https://github.com/dsame/orion-t1/blob/main/lib/presentation/screens/windrose.dart)  - a
          screen that shows windrose data (radar chart)

The screens have the similar structure:

-
`ViewModelProvider`[⤴](https://github.com/dsame/orion-t1/blob/2a35827429472afa3c8925571615ce80b59cef21/lib/presentation/screens/minmax_temperature.dart#L17C1-L17C39) -
a widget that provides (with `ChangeNotifierProvider`) a view model (a subclass of
`ChangeNotifier`) to the widget tree.
-
`Consumer`[⤴](https://github.com/dsame/orion-t1/blob/2a35827429472afa3c8925571615ce80b59cef21/lib/presentation/screens/minmax_temperature.dart#L18C1-L18C52) -
a widget that listens to the view model and rebuilds its child widgets when the view model changes.

> View models expose an instance of
`Resource`[⤴](https://github.com/dsame/orion-t1/blob/main/lib/presentation/viewmodels/resource.dart) class that
> identifies the state of data: Loading, Success, Error.

-
switch[⤴](https://github.com/dsame/orion-t1/blob/2a35827429472afa3c8925571615ce80b59cef21/lib/presentation/screens/minmax_temperature.dart#L19C1-L19C32)
among the resource states:
    -
    `Loading`[⤴](https://github.com/dsame/orion-t1/blob/2a35827429472afa3c8925571615ce80b59cef21/lib/presentation/screens/minmax_temperature.dart#L21C1-L21C67) -
    show a loading indicator
    -
    `Error`[⤴](https://github.com/dsame/orion-t1/blob/2a35827429472afa3c8925571615ce80b59cef21/lib/presentation/screens/minmax_temperature.dart#L24C1-L24C58) -
    show an error message
    -
    `Success`[⤴](https://github.com/dsame/orion-t1/blob/2a35827429472afa3c8925571615ce80b59cef21/lib/presentation/screens/minmax_temperature.dart#L26C1-L26C71) -
    show the auxiliary widget, responsible to convert domain data to chart data.
- Chart-specific widget[⤴](https://github.com/dsame/orion-t1/tree/main/lib/presentation/widgets)

## Structure

`lib`[⤴](https://github.com/dsame/orion-t1/tree/main/lib):

- `main.dart`[⤴](https://github.com/dsame/orion-t1/blob/main/lib/main.dart): the entry point of the application
- `di.dart`[⤴](https://github.com/dsame/orion-t1/blob/main/lib/di.dart): `MultiProvider` configuration with
  `WhetherService` dependency
- `ca`[⤴](https://github.com/dsame/orion-t1/tree/main/lib/ca): stands for `Clean Architecture` - non-UI code.
    - `repositories`[⤴](https://github.com/dsame/orion-t1/tree/main/lib/ca/repositories): assumed to implement caching,
      unifying data representation from different sources and effective
      data fetching.
      > currently only
      `WeatherRepository`[⤴](https://github.com/dsame/orion-t1/blob/main/lib/ca/repositories/weather/weather_repository.dart)
      and
      `MeasurementModel`[⤴](https://github.com/dsame/orion-t1/blob/main/lib/ca/repositories/weather/models/measurement.dart)
      are implemented.
        - `weather/datasources`[⤴](https://github.com/dsame/orion-t1/tree/main/lib/ca/repositories/weather/datasources):
          contains sources of raw data responsible for fetching data from
          different sources (e.g. REST API, local storage, etc.) and converting it to a unified data model.
    - `domain`[⤴](https://github.com/dsame/orion-t1/tree/main/lib/ca/domain): business logic, manipulating data received
      from repositories and converting data models to domain
      entities.
        - `weather_entities.dart`[⤴](https://github.com/dsame/orion-t1/blob/main/lib/ca/domain/weather_entities.dart):
          `DayOfWeek`, `MinMaxTemperature`, `Precipitation`, `Windrose`.
        - `weather_service.dart`[⤴](https://github.com/dsame/orion-t1/blob/main/lib/ca/domain/weather_service.dart):
          `getMinMaxTemperatureLast7Days`, `getPrecipitationLast7Days`, `getWindroseLast7Days`.
- `presentation`: UI-related code.
    - `scaffolds`[⤴](https://github.com/dsame/orion-t1/tree/main/lib/presentation/scaffolds): top-level widgets for the
      different features of the application. Currently only
      `DefaultTabControllerScaffold` is implemented because the application has only 1 feature.
    - `screens`[⤴](https://github.com/dsame/orion-t1/tree/main/lib/presentation/screens): widgets that represent the
      top-level (having not back button) screens of the feature. Currently only
      `PrecipitationWidget`, `MinMaxTemperatureWidget`, `WindroseWidget` are implemented.
    - `widgets`[⤴](https://github.com/dsame/orion-t1/tree/main/lib/presentation/widgets): widgets that are used in the
      screens (views).
    - `viewmodels`[⤴](https://github.com/dsame/orion-t1/tree/main/lib/presentation/viewmodels): view models(
      ChangeNotifiers) that are used in the screens.
  > The data provided by the view models are wrapped into
  `Resource`[⤴](https://github.com/dsame/orion-t1/blob/main/lib/presentation/viewmodels/resource.dart) class that
  identifies the state of
  data: Loading, Success, Error. This way the UI can react to the states and be sure about their availability.
    - `theme`: currently unmodified theme data suggested by default flutter project.
- `math`[⤴](https://github.com/dsame/orion-t1/tree/main/lib/math): contains helper functions for mathematical
  operations (calculates "good"
  numbers[⤴](https://github.com/dsame/orion-t1/blob/951028531c78331576d3f012b825b5738b21b7bc/lib/math/closest_rounded.dart#L1C1-L1C79)
  of ticks for the charts).

### HTTP data source

For the demo purposes the http client is mocked with
`AssetClient`[⤴](https://github.com/dsame/orion-t1/blob/main/lib/ca/repositories/weather/datasources/http/asset_client.dart)
implementation that reads the data from the
json file[⤴](https://github.com/dsame/orion-t1/blob/main/assets/sample_1d.json) from the assets folder and uses it as a
seed for the random data generation (assuming each next day has a bit of
different[⤴](https://github.com/dsame/orion-t1/blob/2a35827429472afa3c8925571615ce80b59cef21/lib/ca/repositories/weather/datasources/http/http_datasource.dart#L60C1-L79C67)
measurements from the previous).

### Randomizing data

For the sake of testability and reproducibility, the fixed random generator instance is used whenever the random data
is needed. The seeds for the random generators are set in
`di.dart`[⤴](https://github.com/dsame/orion-t1/blob/2a35827429472afa3c8925571615ce80b59cef21/lib/di.dart#L21C1-L23C45)
file.

## Tests

Few tests are located in the `test`[⤴](https://github.com/dsame/orion-t1/tree/main/test) folder.

## CI/CD

The project is set up with GitHub Actions[⤴](https://github.com/dsame/orion-t1/blob/main/.github/workflows/main.yml) to
build[⤴](https://github.com/dsame/orion-t1/blob/2a35827429472afa3c8925571615ce80b59cef21/.github/workflows/main.yml#L26C1-L26C31)
and
deploy[⤴](https://github.com/dsame/orion-t1/blob/2a35827429472afa3c8925571615ce80b59cef21/.github/workflows/main.yml#L30C1-L33C70)
web target for the quick reviews.
The workflow is set up to be triggered
manually[⤴](https://github.com/dsame/orion-t1/blob/2a35827429472afa3c8925571615ce80b59cef21/.github/workflows/main.yml#L8C1-L8C21).

## Questions

### Before the development

- Assumed per-day aggregation(sum) of the precipitation data. Is it correct?
- The speed of wind is assumed to be ignored on the wind diagram. Is it correct?
- I assume the data can be missing for some days/hours. Is it correct?

### During the development

- The ChangeNotifier is used for the view models. Is it an expected implementation? Should we discuss the alternatives?
- The ViewModels are instantiated as close to the views as possible. Alternatively,
  they can be instantiated in the `AppDependenciesProvider` and provided to the views. Should we discuss this?
- I want to add the "Refresh" button to the screens and "Polling mode" to automatically refresh the data. Can 1 work day
  be approved for this?
- I want to add the reactive source of the data (e.g., WebSocket). Does it make sense?

## Known issues & TODOs

- ViewModels/Data:
    - [ ] Days of the week are completely erased, they should be kept and shown.

- Theming:
    - [ ] Colors are hardcoded

- Bar chart:
    - [ ] The left and right padding should be removed from the painter area.
    - [ ] The paddings should be added to the container.
    - [ ] Top labels seem to be cut off by 1px.
    - [ ] Labels (days of the week) at the bottom should be added.

- Line chart:
    - [x] Min/max should have different colors.
    - [ ] Grid lines should be labeled.
    - [ ] Measurements should be labeled.

- Windrose:
- [ ] Wrong scale of the wind vertices. The vertices are too small.
- [ ] Circles' color should be brighter.
- [ ] WE & WS labels are wrongly placed.
- [ ] Polygon is not filled correctly.

- Others:
- [ ] "Nice numbers" are too naive, tend to be bigger than needed, should be improved.
- [ ] Android doesn't obey safe area insets.