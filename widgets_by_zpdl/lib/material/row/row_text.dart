import 'package:flutter/material.dart';

import '../../material.dart';

class RowPrefixText extends StatelessWidget {

  final String? prefix;
  final double? prefixDivider;

  final String text;
  final TextStyle? style;
  final bool? softWrap;
  final TextOverflow? overflow;
  final int? maxLines;

  final EdgeInsetsGeometry? padding;

  const RowPrefixText({Key? key, this.prefix, this.prefixDivider, required this.text, this.style, this.softWrap, this.overflow, this.maxLines, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = this.style ?? Theme.of(context).textTheme.bodyText1;
    final prefix = this.prefix;
    final prefixDivider = this.prefixDivider;

    Widget child = Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        if(prefix != null)
          Text(prefix, style: style),
        if(prefixDivider != null )
          RowSpace(prefixDivider),
        Expanded(child: Text(
          text,
          style: style,
          softWrap: softWrap,
          overflow: overflow,
          maxLines: maxLines,
        ))
      ],
    );

    final padding = this.padding;
    if(padding != null) {
      child = Padding(
        padding: padding,
        child: child,
      );
    }
    return child;
  }
}


