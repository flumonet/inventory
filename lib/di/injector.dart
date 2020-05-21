import 'package:inventory/bloc/Item/item_bloc.dart';
import 'package:inventory/bloc/app/app_bloc.dart';
import 'package:inventory/bloc/auth/auth_bloc.dart';
import 'package:inventory/services/api/auth_api_service.dart';
import 'package:inventory/services/api/auth_service.dart';
import 'package:inventory/services/api/item_api_service.dart';
import 'package:inventory/services/api/item_service.dart';
import 'package:inventory/services/api/location_api_service.dart';
import 'package:inventory/services/api/location_service.dart';
import 'package:kiwi/kiwi.dart';

part 'injector.g.dart';

abstract class Injector {
  static Container container;

  static void setup() {
    container = Container();
    _$Injector().configure();
  }
  static final resolve = container.resolve;

  @Register.singleton(
    AuthService,
    from: AuthApiService,
  )
  @Register.factory(
    ItemService,
    from: ItemApiService,
  )

  @Register.factory(
    LocationService,
    from: LocationApiService,
  )

  @Register.factory(
    AuthBloc,
  )

  @Register.factory(
    ItemBloc,
  )

  @Register.factory(AppBloc,)

  void configure();
}
