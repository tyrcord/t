// Project imports:
import 'package:tbloc/tbloc.dart';

enum PeopleBlocEventPayloadType {
  updateInformation,
  errorDelayed,
  married,
  marry,
  error,
  multiple,
}

class PeopleBlocEventPayload {
  final String? firstname;
  final String? lastname;
  final bool? isSingle;
  final bool? isMarrying;
  final int? age;

  PeopleBlocEventPayload({
    this.firstname,
    this.lastname,
    this.isSingle,
    this.isMarrying,
    this.age,
  });
}

class PeopleBlocEvent
    extends BlocEvent<PeopleBlocEventPayloadType, PeopleBlocEventPayload> {
  const PeopleBlocEvent.error()
      : super(
          type: PeopleBlocEventPayloadType.error,
          error: 'error',
        );

  const PeopleBlocEvent.married({super.payload})
      : super(
          type: PeopleBlocEventPayloadType.married,
        );

  const PeopleBlocEvent.updateInformation({
    super.payload,
    super.forceBuild,
  }) : super(
          type: PeopleBlocEventPayloadType.updateInformation,
        );

  const PeopleBlocEvent.marrySomeone()
      : super(type: PeopleBlocEventPayloadType.marry);

  const PeopleBlocEvent.updateMultipleInformation()
      : super(type: PeopleBlocEventPayloadType.multiple);

  const PeopleBlocEvent.errorDelayed()
      : super(type: PeopleBlocEventPayloadType.errorDelayed);
}
