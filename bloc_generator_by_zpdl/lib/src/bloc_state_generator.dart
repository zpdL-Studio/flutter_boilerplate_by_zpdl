import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:bloc_by_zpdl/annotation.dart';
import 'package:build/build.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';

import 'string_buffer_extension.dart';
import 'visitor/constructor_visitor.dart';
import 'visitor/field_visitor.dart';

class BLoCStateGenerator extends GeneratorForAnnotation<BLoCStateAnnotation> {
  @override
  FutureOr<String> generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    print('KKH element : $element');
    print('KKH annotation : $annotation');
    print('KKH annotation : ${annotation.objectValue}');
    print('KKH buildStep : $buildStep');

    var visitor = ConstructorVisitor();
    element.visitChildren(visitor);

    FieldFunctionVisitor? parameter;
    if(annotation.read('parameter').isType) {
      final typeValue = annotation.read('parameter').typeValue;
      if(typeValue is InterfaceType) {
        parameter = FieldFunctionVisitor();
        typeValue.element.visitChildren(parameter);
      }
    }

    ConstructorVisitor? providerBuilder;
    if(annotation.read('providerBuilder').isType) {
      final typeValue = annotation.read('providerBuilder').typeValue;
      if(typeValue is InterfaceType) {
        providerBuilder = ConstructorVisitor();
        typeValue.element.visitChildren(providerBuilder);
      }
    }

    String providerName = '${visitor.className}Provider';
    if(annotation.read('providerName').isString) {
      providerName = annotation.read('providerName').stringValue;
    }

    final sourceBuilder = StringBuffer();
    _generateBLoCSource(visitor, sourceBuilder, parameter, providerName);
    sourceBuilder.writeln('');
    _generateProviderSource(visitor, sourceBuilder, parameter, providerName, providerBuilder);
    return sourceBuilder.toString();
  }

  void _generateBLoCSource(
      ConstructorVisitor visitor,
      StringBuffer sb,
      FieldFunctionVisitor? parameter,
      String providerName
      ) {
    sb.writeln('abstract class \$${visitor.className} extends BLoCState<$providerName> {');
    sb.writeln();
    if(parameter != null) {
      for (final field in parameter.fields.entries) {
        sb.writeLine(1, '${field.value} get ${field.key} => widget.${field.key};');
      }
      for (final field in parameter.functions.entries) {
        sb.writeLine(1, '${field.value} get ${field.key} => widget.${field.key};');
      }
      sb.writeln();
    }

    if(parameter != null) {
      sb.writeLine(1, '@override');
      sb.writeLine(1, 'void didUpdateWidget(covariant $providerName oldWidget) {');
      sb.writeLine(2, 'super.didUpdateWidget(oldWidget);');

      StringBuffer equalSb = StringBuffer();
      for (final field in parameter.fields.entries) {
        if(equalSb.isNotEmpty) {
          equalSb.write(' || ');
        }
        equalSb.write('widget.${field.key} != oldWidget.${field.key}');
      }
      sb.writeLine(2, 'if($equalSb) {');
      sb.writeLine(3, 'setState(() {});');
      sb.writeLine(2, '}');
      sb.writeLine(1, '}');
    }

    sb.writeln('}');
  }

  void _generateProviderSource(
      ConstructorVisitor visitor,
      StringBuffer sb,
      FieldFunctionVisitor? parameter,
      String providerName,
      ConstructorVisitor? providerBuilder) {
    sb.writeln('class $providerName extends BLoCProvider<${visitor.className}> {');

    StringBuffer constructorBuilder = StringBuffer();
    constructorBuilder.write('$providerName({Key? key');
    if(providerBuilder == null) {
      constructorBuilder.write(', required BLoCBuilderCallback<${visitor.className}> builder');
    }

    if(parameter != null) {
      for (final field in parameter.fields.entries) {
        constructorBuilder.write(
            ',${field.value.nullabilitySuffix == NullabilitySuffix.none
                ? ' required '
                : ' '}this.${field.key}');
        sb.writeLine(1, 'final ${field.value} ${field.key};');
      }
      for (final field in parameter.functions.entries) {
        constructorBuilder.write(
            ',${field.value.nullabilitySuffix == NullabilitySuffix.none
                ? ' required '
                : ' '}this.${field.key}');
        sb.writeLine(1, 'final ${field.value} ${field.key};');
      }
    }

    if(providerBuilder != null) {
      constructorBuilder.write('}): super(key: key, builder: (_, bLoC) => ${providerBuilder.className}(bLoC));');
    } else {
      constructorBuilder.write('}): super(key: key, builder: builder);');
    }
    sb.writeln();
    sb.writeLine(1, constructorBuilder);
    sb.writeln();
    sb.writeLine(1, '@override');
    sb.writeLine(1, 'State<StatefulWidget> createState() => ${visitor.className}();');
    sb.writeln('}');
  }
}