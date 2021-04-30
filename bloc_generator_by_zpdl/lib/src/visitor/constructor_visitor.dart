import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:analyzer/dart/element/type.dart';

class ConstructorVisitor extends SimpleElementVisitor {
  late final ConstructorElement constructor;

  DartType get className => constructor.type.returnType;

  @override
  dynamic visitConstructorElement(ConstructorElement element) {
    // print("BLoCStateVisitor visitConstructorElement $element");
    constructor = element;
  }

  // @override
  // visitFieldElement(FieldElement element) {
  //   print("BLoCStateVisitor visitFieldElement $element");
  // }
  //
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