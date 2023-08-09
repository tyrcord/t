# TCache

Efficiently store and retrieve data with TTL, LRU eviction.

Usage Example:

```
import 'package:cache_manager/cache_manager.dart';

void main() {
  final cache = CacheManager();

  // Setting a cache item
  await cache.setItem('key1', 'value1', ttl: Duration(minutes: 15));

  // Getting a cache item
  String value = cache.getItem('key1');
  print(value);  // Outputs: 'value1'

  // Removing a cache item
  await cache.removeItem('key1');
}
```
