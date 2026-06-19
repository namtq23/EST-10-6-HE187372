import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/user.dart';
import '../data/repositories/user_repository.dart';

part 'user_viewmodel.g.dart';

@riverpod
class UserViewModel extends _$UserViewModel {
  // Local list to cache and manipulate user data in memory
  List<User> _cachedUsers = [];

  @override
  FutureOr<List<User>> build() async {
    if (_cachedUsers.isNotEmpty) {
      return _cachedUsers;
    }

    // Fetch from the API only on the initial load or when cache is empty
    final users = await ref.watch(fetchUsersListProvider.future);
    _cachedUsers = List.from(users);
    return _cachedUsers;
  }

  /// Manually forces a refresh from the API, overwriting the cache
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      ref.invalidate(fetchUsersListProvider);
      final users = await ref.read(fetchUsersListProvider.future);
      _cachedUsers = List.from(users);
      return _cachedUsers;
    });
  }

  /// Adds a new user to the repository and updates the local cache without re-fetching
  Future<User> addUser(User user) async {
    final repository = ref.read(userRepositoryProvider);
    final newUser = await repository.createUser(user);

    // Update local cache
    _cachedUsers.add(newUser);

    // Notify view with updated cache
    state = AsyncValue.data(List.from(_cachedUsers));

    return newUser;
  }

  /// Updates an existing user in the repository and local cache without re-fetching
  Future<User> updateUser(User user) async {
    final repository = ref.read(userRepositoryProvider);
    final updatedUser = await repository.updateUser(user);

    // Update local cache
    _cachedUsers =
        _cachedUsers.map((u) => u.id == user.id ? updatedUser : u).toList();

    // Notify view with updated cache
    state = AsyncValue.data(List.from(_cachedUsers));

    return updatedUser;
  }

  /// Deletes a user by their ID in the repository and removes them from the local cache without re-fetching
  Future<bool> deleteUser(int id) async {
    final repository = ref.read(userRepositoryProvider);
    await repository.deleteUser(id);

    // Update local cache
    _cachedUsers.removeWhere((u) => u.id == id);

    // Notify view with updated cache
    state = AsyncValue.data(List.from(_cachedUsers));

    return true;
  }
}
