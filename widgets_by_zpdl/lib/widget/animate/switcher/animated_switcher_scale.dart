import 'package:flutter/widgets.dart';

import '../../../config.dart';

class AnimatedSwitcherScale extends StatelessWidget {

  final Alignment alignment;
  final Duration? duration;
  final Curve? switchInCurve;
  final Curve? switchOutCurve;
  final Widget child;

  const AnimatedSwitcherScale({Key? key, this.alignment = Alignment.center, this.switchInCurve, this.switchOutCurve, this.duration, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration ?? configAnimatedSwitcherDuration,
      switchInCurve: switchInCurve ?? configAnimatedSwitcherInCurve,
      switchOutCurve: switchOutCurve ?? configAnimatedSwitcherOutCurve,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(scale: animation, child: child,);
      },
      layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
        return Stack(
          alignment: alignment,
          children: <Widget>[
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      child: child,
    );
  }
}
