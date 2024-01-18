/// A generic cache item class used for caching data with a time-to-live (TTL).
///
/// This class stores a value of type [T] and manages its expiry based on the
/// provided TTL. It automatically calculates expiry time upon creation and
/// provides methods to check expiry and update access time.
class TCacheItem<T> {
  /// The time when the item is set to expire.
  ///
  /// This is calculated based on the TTL and the creation or last access time.
  late final DateTime _expiryTime;

  /// The time when the item was last accessed.
  ///
  /// Updating this time extends the life of the cache item.
  late DateTime lastAccessTime;

  /// The duration after which the cache item should expire.
  ///
  /// This duration is used to calculate the [_expiryTime].
  final Duration ttl;

  /// The value of the cache item.
  ///
  /// This is the actual data that is being cached.
  T value;

  /// Creates a new cache item with the given [value] and [ttl].
  ///
  /// Initializes the [lastAccessTime] to the current time and calculates
  /// the [_expiryTime] based on the [ttl].
  TCacheItem(this.value, this.ttl) {
    lastAccessTime = DateTime.now();
    _expiryTime = lastAccessTime.add(ttl);
  }

  /// Checks if the cache item has expired.
  ///
  /// Returns `true` if the current time is after the [_expiryTime],
  /// indicating that the item has expired.
  bool get isExpired => DateTime.now().isAfter(_expiryTime);

  /// Updates the [lastAccessTime] to the current time.
  ///
  /// This method effectively extends the life of the cache item by
  /// recalculating the [_expiryTime] based on the new access time.
  void updateAccessTime() {
    lastAccessTime = DateTime.now();
  }
}
