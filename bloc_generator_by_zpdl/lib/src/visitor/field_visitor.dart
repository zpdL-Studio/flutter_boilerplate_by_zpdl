import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

import 'constructor_visitor.dart';

class FieldVisitor extends ConstructorVisitor {

  final Map<String, DartType> fields = {};

  @override
  dynamic visitFieldElement(FieldElement element) {
    fields[element.name] = element.type;
  }
}

class FieldFunctionVisitor extends ConstructorVisitor {

  final Map<String, DartType> fields = {};
  final Map<String, FunctionType> functions = {};

  @override
  dynamic visitFieldElement(FieldElement element) {
    if(element.type is FunctionType) {
      functions[element.name] = element.type as FunctionType;
    } else {
      fields[element.name] = element.type;
    }
  }
}