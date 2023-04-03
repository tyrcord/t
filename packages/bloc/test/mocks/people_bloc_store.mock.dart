import 'package:tbloc/tbloc.dart';
import 'people_bloc_state.mock.dart';

class PeopleBlocStore implements BlocStore<PeopleBlocState> {
  static final _storage = <String, PeopleBlocState>{};

  @override
  Future<void> clear() async => _storage.clear();

  @override
  Future<PeopleBlocState?> persist(String key, PeopleBlocState value) async {
    if (!_storage.containsKey(key)) {
      return _storage.putIfAbsent(key, () => value);
    }

    return _storage.update(key, (_) => value);
  }

  @override
  Future<PeopleBlocState?> retrieve(String key) async => _storage[key];

  @override
  Future<PeopleBlocState?> delete(String key) async => _storage.remove(key);
}
