// Project imports:
import 'package:tbloc/tbloc.dart';

/// A function that builds a [BlocState] based on the type of the [BlocState].
typedef BlocStateBuilder<S extends BlocState> = S Function();
