library assets_generator_by_zpdl;

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'assets_generator.dart';

Builder assetsByZpdl(BuilderOptions options) =>
    SharedPartBuilder([AssetsGenerator()], 'assets_by_zpdl');