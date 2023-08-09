class TCacheItem<T> {
  late final DateTime _expiryTime;
  late DateTime lastAccessTime;
  final Duration ttl;
  T value;

  TCacheItem(this.value, this.ttl) {
    lastAccessTime = DateTime.now();
    _expiryTime = lastAccessTime.add(ttl);
  }

  bool get isExpired => DateTime.now().isAfter(_expiryTime);

  void updateAccessTime() {
    lastAccessTime = DateTime.now();
  }
}
