library assets_annotation_by_zpdl;

const assetsAnnotation = AssetsAnnotation();
const assetsAnnotationCamel = AssetsAnnotation(isCamelCase: true);
const assetsAnnotationSnake = AssetsAnnotation(isSnakeCase: true);

/// Annotation for assets_generator_by_zpdl package
class AssetsAnnotation {
  /// Camel case enable value
  /// The first letter is written in lowercase. The first letter of the rest of the following words is capitalized.
  /// ex) isCamelCase
  final bool isCamelCase;
  /// Snake case enable value
  /// Place an underline in the middle of each word joined.
  /// ex) is_snake_case
  final bool isSnakeCase;

  const AssetsAnnotation({this.isCamelCase = false, this.isSnakeCase = false});
}