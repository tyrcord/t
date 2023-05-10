// ignore_for_file: avoid_print

import 'package:subx/subx.dart';

void main() async {
  final subxList = SubxList();
  final source = Stream.periodic(const Duration(milliseconds: 500), (counter) {
    return ++counter;
  });

  final source2 = Stream.periodic(const Duration(seconds: 1), (counter) {
    return ++counter;
  });

  final subscription = source.listen(
    (data) => print('Subscription1: $data'),
  );

  final subscription2 = source2.listen(
    (data) => print('Subscription2: $data'),
  );

  subxList.add(subscription);
  subxList.add(subscription2);

  await Future.delayed(const Duration(seconds: 2), () {
    return subxList.cancelAll();
  });
}
