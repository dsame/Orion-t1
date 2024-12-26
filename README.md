# PoC for Flutter architecture

## Overview

- `main`
    - `AppDependenciesProvider` - adds application live-time dependencies with `MultiProvider`
  > currently only `WeatherService`
    - `ThemedAppWidget` - instantiate `MaterialApp` with default material3 `ThemeData`
    - `DefaultTabControllerScaffold` - a child of `ThemedAppWidget` that adds a `DefaultTabController` to
      the widget tree with 3 tabs(screens)
        - `PrecipitationWidget` - a screen that shows precipitation data (bar chart)
        - `MinMaxTemperatureWidget` - a screen that shows min/max temperature data (line chart)
        - `WindroseWidget`  - a screen that shows windrose data (radar chart)

The screens have the similar structure:

- `ViewModelProvider` - a widget that provides (with `ChangeNotifierProvider`) a view model (a subclass of
  `ChangeNotifier`) to the widget tree.
- `Consumer` - a widget that listens to the view model and rebuilds its child widgets when the view model changes.

> View models expose an instance of `Resource` class that identifies the state of data: Loading, Success, Error.

- switch among the resource states:
    - `Loading` - show a loading indicator
    - `Error` - show an error message
    - `Success` - show the auxiliary widget, responsible to convert domain data to chart data.
- Chart-specific widgets

## Structure

`lib`: contains the main application code

- `main.dart`: the entry point of the application
- `di.dart`: `MultiProvider` configuration with `WhetherService` dependency
- `ca`: stands for `Clean Architecture` - non-UI code.
    - `repositories`: assumed to implement caching, unifying data representation from different sources and effective
      data fetching.
      > currently only `WeatherRepository`and `MeasurementModel` are implemented.
        - `weather/datasources`: contains sources of raw data responsible for fetching data from
          different sources (e.g. REST API, local storage, etc.) and converting it to a unified data model.

    - `domain`: business logic, manipulating data received from repositories and converting data models to domain
      entities.
        - `weather_entities.dart`: `DayOfWeek`, `MinMaxTemperature`, `Precipitation`, `Windrose`.
        - `weather_service.dart`: `getMinMaxTemperatureLast7Days`, `getPrecipitationLast7Days`, `getWindroseLast7Days`.
- `presentation`: UI-related code.
    - `scaffolds`: top-level widgets for the different features of the application. Currently only
      `DefaultTabControllerScaffold` is implemented because the application has only 1 feature.
    - `screens`: widgets that represent the top-level (having not back button) screens of the feature. Currently only
      `PrecipitationWidget`, `MinMaxTemperatureWidget`, `WindroseWidget` are implemented.
    - `widgets`: widgets that are used in the screens (views).
    - `viewmodels`: view models(ChangeNotifiers) that are used in the screens.
  > The data provided by the view models are wrapped into `Resource` class that identifies the state of
  data: Loading, Success, Error. This way the UI can react to the states and be sure about their availability.
    - `theme`: currently unmodified theme data suggested by default flutter project.
- `math`: contains helper functions for mathematical operations (calculates "good" number of ticks for the charts).

### HTTP data source

For the demo purposes the http client is mocked with `AssetClient` implementation that reads the data from the json
file from the assets folder and uses it as a seed for the random data generation (assuming each next day has a bit
different measurements from the previous).

### Randomizing data

For the sake of testability and reproducibility, the fixed random generator instance is used whenever the random data
is needed. The seeds for the random generators are set in `di.dart` file.

## Tests

Few tests are located in the `test` folder.

## CI/CD

The project is set up with GitHub Actions to build and deploy web target for the quick reviews.
The workflow is set up to be triggered manually.


