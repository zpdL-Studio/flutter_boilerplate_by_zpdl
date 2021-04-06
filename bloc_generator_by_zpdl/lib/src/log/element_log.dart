import 'package:analyzer/dart/element/element.dart';

extension LogConstructorElement on ConstructorElement {
  String get logConstructorElement {
    final sb = StringBuffer();
    sb.writeln('ConstructorElement {');
    sb.writeln('\t declaration: ${declaration.toString()}, displayName: $displayName, enclosingElement: $enclosingElement');
    sb.writeln('\t isConst: $isConst, isDefaultConstructor: $isDefaultConstructor, isFactory: $isFactory');
    sb.writeln('\t name: $name, nameEnd: $nameEnd, periodOffset: $periodOffset');
    sb.writeln('\t redirectedConstructor: ${redirectedConstructor.toString()}, returnType: $returnType');
    sb.writeln('}');
    return sb.toString();
  }
}

extension LogFieldElement on FieldElement {
  String get logFieldElement {
    final sb = StringBuffer();
    sb.writeln('FieldElement { ${toString()}');
    sb.writeln('\t declaration: ${declaration.toString()}, isAbstract: $isAbstract, isCovariant: $isCovariant, isEnumConstant: $isEnumConstant, isExternal: $isExternal, isStatic: $isStatic,');
    sb.writeln('}');
    return sb.toString();
  }
}

extension LogClassMemberElement on ClassMemberElement {
  String get logClassMemberElement {
    final sb = StringBuffer();
    sb.writeln('ClassMemberElement {enclosingElement: $enclosingElement, isStatic: $isStatic, ${toString()}}');
    return sb.toString();
  }
}

extension LogVariableElement on VariableElement {
  String get logVariableElement {
    final sb = StringBuffer();
    sb.writeln('VariableElement {');
    sb.writeln('\t declaration: ${declaration.toString()}, type: $type, computeConstantValue: ${computeConstantValue()}');
    sb.writeln('\t hasImplicitType: $hasImplicitType, isConst: $isConst, isFinal: $isFinal, isLate: $isLate, isStatic: $isStatic,');
    sb.writeln('}');
    return sb.toString();
  }
}

