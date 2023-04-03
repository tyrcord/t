# SubX

[![Build Status](https://travis-ci.com/tyrcord/subx.svg?branch=master)](https://travis-ci.com/tyrcord/subx)

_RxDart Subscriptions management._

Provide Apis to store and manage RxDart subscriptions and provide methods to unsubscribe them all.

## Prerequisites

The project has dependencies that require the Dart SDK 2.0

## Contents

- [Changelog](CHANGELOG.md)
- [SubxList](#subxlist)
  - [API Reference](https://pub.dev/documentation/subx/latest/subx/SubxList-class.html)
- [SubxMap](#subxmap)
  - [API Reference](https://pub.dev/documentation/subx/latest/subx/SubxMap-class.html)
- [License](#license)

## SubxList

Object that holds and manages a list of Subscriptions.

### Usage

```dart
import 'package:rxdart/rxdart.dart';
import 'package:subx/subx.dart';

SubxList subxList = SubxList();
BehaviorSubject source = BehaviorSubject();

StreamSubscription subscription = source.listen((data) {...});
StreamSubscription subscription2 = source.listen((data) {...});

subxList.add(subscription);
subxList.add(subscription2);

...

subxList.unsubscribeAll();
```

[API Reference](https://pub.dev/documentation/subx/latest/subx/SubxList-class.html)

## SubxMap

Object that holds and manages Key-Subscription pairs.

```dart
import 'package:rxdart/rxdart.dart';
import 'package:subx/subx.dart';

SubxList subxList = SubxList();
BehaviorSubject source = BehaviorSubject();

StreamSubscription subscription = source.listen((data) {...});
StreamSubscription subscription2 = source.listen((data) {...});

subxList.set('key1', subscription);
subxList.set('key2', subscription2);

...

subxList.unsubscribeAll();
```

[API Reference](https://pub.dev/documentation/subx/latest/subx/SubxMap-class.html)

## License

Copyright (c) Tyrcord, Inc. Licensed under the ISC License.

See [LICENSE](LICENSE) file in the project root for details.
