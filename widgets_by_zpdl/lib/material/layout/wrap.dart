import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ColumnWrap extends SingleChildRenderObjectWidget {
  final double? width;
  final Widget child;

  ColumnWrap({
    Key? key,
    this.width,
    required this.child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) => _ColumnWrapRenderBox(width: width,);

  @override
  void updateRenderObject(BuildContext context, _ColumnWrapRenderBox renderObject) {
    renderObject..width = width;
  }
}

class _ColumnWrapRenderBox extends RenderShiftedBox {

  _ColumnWrapRenderBox({
    double? width,
    RenderBox? child,
  })  : this._width = width,
        super(child);

  double? _width;
  double? get width => _width;
  set width(double? width) {
    if(_width != width) {
      _width = width;
      markNeedsLayout();
    }
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return width ?? super.computeMaxIntrinsicWidth(height);
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return width ?? super.computeMinIntrinsicWidth(height);
  }

  @override
  void performLayout() {
    final child = this.child;
    if(child != null) {
      child.layout(BoxConstraints(
        minWidth: width ?? constraints.maxWidth,
        maxWidth: width ?? constraints.maxWidth,
        minHeight: constraints.minHeight,
        maxHeight: constraints.maxHeight,
      ), parentUsesSize: true);

      size = Size(child.size.width, child.size.height);
    }
  }
}

class RowWrap extends SingleChildRenderObjectWidget {
  final double? height;
  final Widget child;

  RowWrap({
    Key? key,
    this.height,
    required this.child,
    }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) => _RowWrapRenderBox(height: height,);

  @override
  void updateRenderObject(BuildContext context, _RowWrapRenderBox renderObject) {
    renderObject..height = height;
  }
}

class _RowWrapRenderBox extends RenderShiftedBox {

  _RowWrapRenderBox({
    double? height,
    RenderBox? child,
  })  : this._height = height,
        super(child);

  double? _height;
  double? get height => _height;
  set height(double? height) {
    if(_height != height) {
      _height = height;
      markNeedsLayout();
    }
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return height ?? super.computeMaxIntrinsicHeight(width);
  }
  
  @override
  double computeMinIntrinsicHeight(double width) {
    return height ?? super.computeMinIntrinsicHeight(width);
  }

  @override
  void performLayout() {
    final child = this.child;
    if(child != null) {
      child.layout(BoxConstraints(
        minWidth: constraints.minWidth,
        maxWidth: constraints.maxWidth,
        minHeight: 0,
        maxHeight: height ?? constraints.maxHeight,
      ), parentUsesSize: true);

      final measureHeight = height ?? child.size.height;
      size = Size(child.size.width, measureHeight);
      if(child.parentData is BoxParentData) {
        final BoxParentData childParentData = child.parentData as BoxParentData;
        childParentData.offset = Offset(0, (measureHeight - child.size.height) / 2);
      }
    }
  }
}