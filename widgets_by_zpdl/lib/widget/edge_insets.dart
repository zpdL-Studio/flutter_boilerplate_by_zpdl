import 'package:flutter/widgets.dart';

class EdgeInsetsOnly extends EdgeInsetsDirectional {
  const EdgeInsetsOnly(
      {double? all,
      double? vertical,
      double? horizontal,
      double? start,
      double? top,
      double? end,
      double? bottom})
      : super.only(
          start: start ?? horizontal ?? all ?? 0,
          end: end ?? horizontal ?? all ?? 0,
          top: top ?? vertical ?? all ?? 0,
          bottom: bottom ?? vertical ?? all ?? 0,
        );
}