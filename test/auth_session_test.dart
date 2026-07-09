import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_secure_storage/test/test_flutter_secure_storage_platform.dart';
import 'package:flutter_secure_storage_platform_interface/flutter_secure_storage_platform_interface.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hable/database/database.dart';
import 'package:hable/providers/auth_provider.dart';
import 'package:hable/providers/database_provider.dart';
import 'package:hable/providers/habit_providers.dart';

void main() {
  test(
    'currentUserProvider resolves the authenticated user and logout hides local user state',
    () async {
      final storageData = <String, String>{
        'jwt_token': 'token-123',
        'user_id': 'active-user',
        'username': 'Active',
      };
      FlutterSecureStoragePlatform.instance = TestFlutterSecureStoragePlatform(
        storageData,
      );

      final db = AppDatabase(NativeDatabase.memory());

      await db.insertUser(
        UsersCompanion.insert(
          userId: 'stale-user',
          username: 'Stale',
        ),
      );
      await db.insertUser(
        UsersCompanion.insert(
          userId: 'active-user',
          username: 'Active',
        ),
      );

      const storage = FlutterSecureStorage();
      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(db),
          secureStorageProvider.overrideWithValue(storage),
        ],
      );
      AsyncValue<User?>? latestUserState;
      final currentUserSubscription = container.listen<AsyncValue<User?>>(
        currentUserProvider,
        (previous, next) => latestUserState = next,
        fireImmediately: true,
      );

      container.read(authProvider);
      await pumpEventQueue();
      await pumpEventQueue();

      final authState = container.read(authProvider);
      expect(authState.isInitialized, isTrue);
      expect(authState.isAuthenticated, isTrue);
      expect(authState.userId, 'active-user');

      final currentUser = latestUserState?.value;
      expect(currentUser, isNotNull);
      expect(currentUser!.userId, 'active-user');
      expect(currentUser.username, 'Active');

      await container.read(authProvider.notifier).logout();
      await pumpEventQueue();
      await pumpEventQueue();

      final loggedOutState = container.read(authProvider);
      expect(loggedOutState.isInitialized, isTrue);
      expect(loggedOutState.isAuthenticated, isFalse);
      expect(loggedOutState.userId, isNull);
      expect(storageData, isEmpty);

      final loggedOutUser = latestUserState?.value;
      expect(loggedOutUser, isNull);

      currentUserSubscription.close();
      container.dispose();
      await db.close();
    },
  );
}
