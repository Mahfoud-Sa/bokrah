import 'package:get_it/get_it.dart';

final singelton = GetIt.instance;
Future<void> initializationDependencies() async {
  // final _appDataBaseServices = await AppDataBaseServices();
  // singelton.registerSingleton<AppDataBaseServices>(_appDataBaseServices);
}
