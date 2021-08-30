import 'package:bloc_by_zpdl/bloc_by_zpdl.dart';

part 'bloc_generate_example.g.dart';


class BLoCTest {
  final String firstName;
  final String lastName;
  final DateTime? dateOfBirth;
  final Function() callback;
  final Function()? callbackNullable;
  final Function(String param) callbackParam;

  BLoCTest({required this.firstName, required this.lastName, this.dateOfBirth, required this.callback, this.callbackNullable, required this.callbackParam});
}

// @BLoCStateAnnotation(parameter: BLoCTest, providerName: 'BLoCTestProvider', providerBuilder: BLoCTestBuilder)
// class BLoCTestBLoC extends $BLoCTestBLoC {
//
//   @override
//   void disposeBLoC() {
//     // TODO: implement disposeBLoC
//   }
// }


// class BLoCTestBuilder extends BLoCBuilder<BLoCTestBLoC> {
//   BLoCTestBuilder(BLoCTestBLoC bLoC) : super(bLoC);
//
//   @override
//   Widget builder(BuildContext context, BLoCTestBLoC bLoC) {
//     // TODO: implement builder
//     throw UnimplementedError();
//   }
// }

// class $BLoCTest {
//
//   BLoGTest get bLoGTest => _BLoCTestImple();
//
//
// }
//
// class _BLoCTestImple implements BLoGTest {
//
//   final String firstName;
//   final String lastName;
//   final DateTime? dateOfBirth;
//   final void Function() callback;
//   final void Function()? callbackNullable;
//   final void Function(String param) callbackParam;
//
//   _BLoCTestImple(this.firstName, this.lastName, this.dateOfBirth, this.callback, this.callbackNullable, this.callbackParam);
//
// }