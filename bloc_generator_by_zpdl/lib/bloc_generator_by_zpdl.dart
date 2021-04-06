import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/bloc_state_generator.dart';

Builder blocByZpdl(BuilderOptions options) => SharedPartBuilder([BLoCStateGenerator()],'bloc_by_zpdl');