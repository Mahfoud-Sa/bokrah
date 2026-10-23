import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/auth/data/datasources/auth_token_storage.dart';
import 'features/auth/data/services/auth_service.dart';
import 'features/auth/data/services/mock_auth_service.dart';
import 'features/autoUpdate/data/datasources/github_release_datasource.dart';
import 'features/autoUpdate/data/datasources/update_preferences_datasource.dart';
import 'features/autoUpdate/data/repositories/app_update_repository_impl.dart';
import 'features/autoUpdate/domain/repositories/app_update_repository.dart';
import 'features/autoUpdate/presentation/cubits/app_update_cubit.dart';

final singelton = GetIt.instance;

Future<void> initializationDependencies() async {
  final prefs = await SharedPreferences.getInstance();

  if (!singelton.isRegistered<AuthTokenStorage>()) {
    final storage = SharedPrefsAuthTokenStorage(prefs: prefs);
    singelton.registerSingleton<AuthTokenStorage>(storage);
    singelton.registerSingleton<AuthService>(
      MockAuthService(tokenStorage: storage),
    );
  }

  if (!singelton.isRegistered<AppUpdateRepository>()) {
    final releaseDatasource = HttpGithubReleaseDatasource();
    final prefsDatasource = SharedPrefsUpdatePreferencesDatasource(prefs: prefs);
    final repository = AppUpdateRepositoryImpl(
      releaseDatasource: releaseDatasource,
      preferencesDatasource: prefsDatasource,
    );
    singelton.registerSingleton<AppUpdateRepository>(repository);
    singelton.registerLazySingleton<AppUpdateCubit>(
      () => AppUpdateCubit(repository: repository),
    );
  }
}
