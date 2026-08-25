class AppEnv {
  AppEnv._();

  /// Google Maps API Key
  /// Can be overridden during build time using `--dart-define=MAPS_API_KEY=your_key`
  static const String mapsApiKey = String.fromEnvironment(
    'MAPS_API_KEY',
    defaultValue: 'AIzaSyDi42MgLiRS6-BfJghVilzB_zsmJtL7gVk',
  );
}
