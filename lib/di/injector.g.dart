// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'injector.dart';

// **************************************************************************
// InjectorGenerator
// **************************************************************************

class _$Injector extends Injector {
  void configure() {
    final Container container = Container();
    container.registerSingleton<AuthService, AuthApiService>(
        (c) => AuthApiService());
    container.registerFactory<ItemService, ItemApiService>(
        (c) => ItemApiService(c<AuthService>()));
    container.registerFactory<LocationService, LocationApiService>(
        (c) => LocationApiService());
    container.registerFactory((c) => AuthBloc(c<AuthService>()));
    container.registerFactory(
        (c) => ItemBloc(c<ItemService>(), c<LocationService>()));
    container.registerFactory((c) => AppBloc(c<AuthBloc>(), c<ItemBloc>()));
  }
}
