import 'package:caffeio/data/repositories/brewing_methods_repository.abs.dart';
import 'package:caffeio/data/repositories_impl/brewing_methods_repository.dart';
import 'package:get_it/get_it.dart';

class DiRepositories {
  static Future<void> setUp(GetIt getIt) async {
    getIt.registerSingleton<BrewingMethodsRepository>(
        BrewingMethodsRepositoryImpl(getIt.get()));
  }
}