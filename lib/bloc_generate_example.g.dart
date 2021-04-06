// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bloc_generate_example.dart';

// **************************************************************************
// BLoCStateGenerator
// **************************************************************************

abstract class $BLoCTestBLoC extends BLoCState<BLoCTestProvider> {
  String get firstName => widget.firstName;
  String get lastName => widget.lastName;
  DateTime? get dateOfBirth => widget.dateOfBirth;
  dynamic Function() get callback => widget.callback;
  dynamic Function()? get callbackNullable => widget.callbackNullable;
  dynamic Function(String) get callbackParam => widget.callbackParam;

  @override
  void didUpdateWidget(covariant BLoCTestProvider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.firstName != oldWidget.firstName ||
        widget.lastName != oldWidget.lastName ||
        widget.dateOfBirth != oldWidget.dateOfBirth) {
      setState(() {});
    }
  }
}

class BLoCTestProvider extends BLoCProvider<BLoCTestBLoC> {
  final String firstName;
  final String lastName;
  final DateTime? dateOfBirth;
  final dynamic Function() callback;
  final dynamic Function()? callbackNullable;
  final dynamic Function(String) callbackParam;

  BLoCTestProvider(
      {Key? key,
      required this.firstName,
      required this.lastName,
      this.dateOfBirth,
      required this.callback,
      this.callbackNullable,
      required this.callbackParam})
      : super(key: key, builder: (_, bLoC) => BLoCTestBuilder(bLoC));

  @override
  State<StatefulWidget> createState() => BLoCTestBLoC();
}
