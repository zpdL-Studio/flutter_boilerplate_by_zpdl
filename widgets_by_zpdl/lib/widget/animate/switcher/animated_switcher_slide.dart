import 'package:flutter/widgets.dart';

import '../../../config.dart';

class AnimatedSwitcherSlide extends StatelessWidget {

  final Alignment alignment;
  final Duration? duration;
  final Curve? switchInCurve;
  final Curve? switchOutCurve;
  final Widget child;

  const AnimatedSwitcherSlide({Key? key, this.alignment = Alignment.center, this.switchInCurve, this.switchOutCurve, this.duration, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration ?? configAnimatedSwitcherDuration,
      switchInCurve: switchInCurve ?? configAnimatedSwitcherInCurve,
      switchOutCurve: switchOutCurve ?? configAnimatedSwitcherOutCurve,
      transitionBuilder: (Widget child, Animation<double> animation) {
        final _offsetAnimation = Tween<Offset>(
          begin: Offset(alignment.x, alignment.y),
          end: Offset.zero,
        ).animate(animation);
        return SlideTransition(position: _offsetAnimation, child: child,);
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
