// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserViewModel)
final userViewModelProvider = UserViewModelProvider._();

final class UserViewModelProvider
    extends $AsyncNotifierProvider<UserViewModel, List<User>> {
  UserViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'userViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$userViewModelHash();

  @$internal
  @override
  UserViewModel create() => UserViewModel();
}

String _$userViewModelHash() => r'38842b3a003fcd52b2dc42014b4161fd36aeba59';

abstract class _$UserViewModel extends $AsyncNotifier<List<User>> {
  FutureOr<List<User>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<User>>, List<User>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<User>>, List<User>>,
        AsyncValue<List<User>>,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
