import 'package:flutter/material.dart';

class ColumnSpace extends StatelessWidget {

  final double height;

  const ColumnSpace(this.height, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height,);
  }
}

class RowSpace extends StatelessWidget {

  final double width;

  const RowSpace(this.width, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width,);
  }
}