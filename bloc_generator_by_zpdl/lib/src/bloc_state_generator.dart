import 'dart:async';

import 'package:bloc_by_zpdl/annotation.dart';

import 'string_buffer_extension.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';

class BLoCStateGenerator extends GeneratorForAnnotation<BLoCStateAnnotation> {
  @override
  FutureOr<String> generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    print("KKH element : $element");
    print("KKH annotation : $annotation");
    print("KKH annotation : ${annotation.objectValue}");
    print("KKH buildStep : $buildStep");

    var visitor = BLoCStateVisitor();
    element.visitChildren(visitor);

    final sourceBuilder = StringBuffer();
    _generateBLoCSource(visitor, sourceBuilder);
    sourceBuilder.writeln('');
    _generateProviderCSource(visitor, sourceBuilder);
    return sourceBuilder.toString();
  }

  void _generateBLoCSource(BLoCStateVisitor visitor, StringBuffer sb) {
    sb.writeln('abstract class \$${visitor.bLoc} extends BLoCState<${visitor.provider}> {');
    for(final field in visitor.fields.entries) {
      sb.writeLine(1, '${field.value} get ${field.key} => widget.${field.key};');
    }
    for(final field in visitor.functions.entries) {
      sb.writeLine(1, '${field.value} get ${field.key} => widget.${field.key};');
    }
    sb.writeln('}');
  }

  void _generateProviderCSource(BLoCStateVisitor visitor, StringBuffer sb) {
    sb.writeln('class ${visitor.provider} extends BLoCProvider<${visitor.bLoc}> {');

    StringBuffer constructorBuilder = StringBuffer();
    constructorBuilder.write('${visitor.provider}({Key? key, required BLoCBuilderCallback<${visitor.bLoc}> builder');
    for(final field in visitor.fields.entries) {
      constructorBuilder.write(',${field.value.nullabilitySuffix == NullabilitySuffix.none ? ' required ' : ' '}this.${field.key}');
      sb.writeLine(1, 'final ${field.value} ${field.key};');
    }
    for(final field in visitor.functions.entries) {
      constructorBuilder.write(',${field.value.nullabilitySuffix == NullabilitySuffix.none ? ' required ' : ' '}this.${field.key}');
      sb.writeLine(1, 'final ${field.value} ${field.key};');
    }
    constructorBuilder.write('}): super(key: key, builder: builder);');
    sb.writeln();
    sb.writeLine(1, constructorBuilder);
    sb.writeln();
    sb.writeLine(1, '@override');
    sb.writeLine(1, 'State<StatefulWidget> createState() => ${visitor.bLoc}();');
    sb.writeln('}');
  }
}
// BLoGTestProvider({Key? key, BLoCBuilderCallback<BLoGTestBLoC> builder, this.firstName, this.lastName, this.dateOfBirth, this.callback, this.callbackNullable, this.callbackParam}): super(key: key, builder: builder);
class BLoCStateVisitor extends SimpleElementVisitor {

  late final DartType className;

  final Map<String, DartType> fields = {};
  final Map<String, FunctionType> functions = {};

  String get bLoc => '${className}BLoC';

  String get provider => '${className}Provider';

  @override
  visitConstructorElement(ConstructorElement element) {
    // print("BLoCStateVisitor visitConstructorElement $element");
    className = element.type.returnType;
  }

  @override
  visitFieldElement(FieldElement element) {
    if(element.type is FunctionType) {
      functions[element.name] = element.type as FunctionType;
    } else {
      fields[element.name] = element.type;
    }
    // print("BLoCStateVisitor visitFieldElement name: ${element.name} FunctionType ${element.type}");
  }

  // @override
  // visitClassElement(ClassElement element) {
  //   print("BLoCStateVisitor visitClassElement $element");
  // }
  //
  // @override
  // visitTypeParameterElement(TypeParameterElement element) {
  //   print("BLoCStateVisitor visitTypeParameterElement $element");
  // }
  //
  // @override
  // visitTypeAliasElement(TypeAliasElement element) {
  //   print("BLoCStateVisitor visitTypeAliasElement $element");
  // }
  //
  // @override
  // visitTopLevelVariableElement(TopLevelVariableElement element) {
  //   print("BLoCStateVisitor visitTopLevelVariableElement $element");
  // }
  //
  // @override
  // visitPropertyAccessorElement(PropertyAccessorElement element) {
  //   print("BLoCStateVisitor visitPropertyAccessorElement $element");
  // }
  //
  // @override
  // visitPrefixElement(PrefixElement element) {
  //   print("BLoCStateVisitor visitPrefixElement $element");
  // }
  //
  // @override
  // visitParameterElement(ParameterElement element) {
  //   print("BLoCStateVisitor visitParameterElement $element");
  // }
  //
  // @override
  // visitMultiplyDefinedElement(MultiplyDefinedElement element) {
  //   print("BLoCStateVisitor visitMultiplyDefinedElement $element");
  // }
  //
  // @override
  // visitMethodElement(MethodElement element) {
  //   print("BLoCStateVisitor visitMethodElement $element");
  // }
  //
  // @override
  // visitLocalVariableElement(LocalVariableElement element) {
  //   print("BLoCStateVisitor visitLocalVariableElement $element");
  // }
  //
  // @override
  // visitLibraryElement(LibraryElement element) {
  //   print("BLoCStateVisitor visitLibraryElement $element");
  // }
  //
  // @override
  // visitLabelElement(LabelElement element) {
  //   print("BLoCStateVisitor visitLabelElement $element");
  // }
  //
  // @override
  // visitImportElement(ImportElement element) {
  //   print("BLoCStateVisitor visitImportElement $element");
  // }
  //
  // @override
  // visitGenericFunctionTypeElement(GenericFunctionTypeElement element) {
  //   print("BLoCStateVisitor visitGenericFunctionTypeElement $element");
  // }
  //
  // @override
  // visitFunctionTypeAliasElement(FunctionTypeAliasElement element) {
  //   print("BLoCStateVisitor visitFunctionTypeAliasElement $element");
  // }
  //
  // @override
  // visitFunctionElement(FunctionElement element) {
  //   print("BLoCStateVisitor visitFunctionElement $element");
  // }
  //
  // @override
  // visitFieldFormalParameterElement(FieldFormalParameterElement element) {
  //   print("BLoCStateVisitor visitFieldFormalParameterElement $element");
  // }
  //
  // @override
  // visitExtensionElement(ExtensionElement element) {
  //   print("BLoCStateVisitor visitExtensionElement $element");
  // }
  //
  // @override
  // visitExportElement(ExportElement element) {
  //   print("BLoCStateVisitor visitExportElement $element");
  // }
  //
  // @override
  // visitCompilationUnitElement(CompilationUnitElement element) {
  //   print("BLoCStateVisitor visitCompilationUnitElement $element");
  // }
}