import 'dart:async';

///
/// Class that holds and manages a list of Subscriptions.
///
class SubxMap {
  final Map<Object, StreamSubscription> _subscriptionMap = {};

  ///
  /// Return the number of StreamSubscriptions
  ///
  int get length => _subscriptionMap.length;

  ///
  /// Add or update a StreamSubscription to the list with a specified key.
  /// Will unsubscribe a Subscription when updating a existing key.
  ///
  /// For example:
  ///
  ///     subxMap.add('key', observable.listen(...));
  SubxMap add(Object key, StreamSubscription<dynamic> value) {
    final oldSubscription = _subscriptionMap[key];

    if (oldSubscription != null && oldSubscription != value) {
      oldSubscription.cancel();
    }

    _subscriptionMap[key] = value;

    return this;
  }

  ///
  /// Return a StreamSubscription from the list with a specified key
  ///
  /// For example:
  ///
  ///     StreamSubscription subscription = subxMap[0];
  StreamSubscription? operator [](Object key) => _subscriptionMap[key];

  ///
  /// Returns a boolean indicating whether an subscription exists or not.
  ///
  /// For example:
  ///
  ///     subxMap.containsSubscription(subscription);
  bool containsSubscription(StreamSubscription<dynamic> subscription) {
    return _subscriptionMap.containsValue(subscription);
  }

  ///
  /// Cancel a StreamSubscription with a specified key and remove it from list
  ///
  /// For example:
  ///
  ///     subxMap.cancelForKey('key');
  Future<bool> cancelForKey(Object key) async {
    if (_subscriptionMap.containsKey(key)) {
      final subscription = _subscriptionMap.remove(key)!;
      await subscription.cancel();

      return true;
    }

    return false;
  }

  ///
  /// Cancel all StreamSubscriptions and remove them from the list
  ///
  /// For example:
  ///
  ///     subxMap.cancelAll();
  void cancelAll() async {
    _subscriptionMap.forEach((
      Object key,
      StreamSubscription<dynamic> subscription,
    ) {
      subscription.cancel();
    });

    _subscriptionMap.clear();
  }

  ///
  /// Pause all StreamSubscriptions of the list
  ///
  /// For example:
  ///
  ///     subxMap.pauseAll();
  void pauseAll() {
    _subscriptionMap.forEach((_, StreamSubscription<dynamic> subscription) {
      subscription.pause();
    });
  }

  ///
  /// Resume all StreamSubscriptions of the list
  ///
  /// For example:
  ///
  ///     subxMap.resumeAll();
  void resumeAll() {
    _subscriptionMap.forEach((_, StreamSubscription<dynamic> subscription) {
      subscription.resume();
    });
  }
}
