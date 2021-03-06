import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class IosOutSideUnFocusTab extends StatelessWidget {

  final Widget child;

  const IosOutSideUnFocusTab({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          final focusScopeNode = FocusScope.of(context);
          if (!focusScopeNode.hasPrimaryFocus && focusScopeNode.hasFocus) {
            focusScopeNode.unfocus();
          }
        },
        child: child,
      );
    } else {
      return child;
    }
  }
}