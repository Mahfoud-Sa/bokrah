import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/auth/data/datasources/auth_token_storage.dart';
import 'features/auth/data/services/auth_service.dart';
import 'features/auth/data/services/mock_auth_service.dart';

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
}
