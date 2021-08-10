# Assets generator

Provides [Dart Build System] builders for handling assets.

The builders generate code when they find members annotated with classes defined in [package:assets_annotation_by_zpdl].
Generates assets in pubspec.yaml

- To generate assets `pubspec.yaml` in for a class, annotate it with `@AssetsAnnotation`.


## Install

Add the following to your `pubspec.yaml`:

```sh
dependencies:
  assets_annotation_by_zpdl: ^1.1.0

dev_dependencies:
  assets_generator_by_zpdl: ^1.1.0
  build_runner: <latest>
```

### Usage

#### 1. Create a class with `@AssetsAnnotation`

```dart
import 'package:assets_annotation_by_zpdl/assets_annotation_by_zpdl.dart';

part 'assets.g.dart';

@AssetsAnnotation.camelCase(version: '1.0.0')
class Assets {
  const Assets();
}

```

#### 2. Generate your assets

Run the following command to generate a `lib/assets.g.dart` file :

```
flutter packages pub run build_runner build
```

#### 3. Use your assets

```dart
const assets = Assets();

print(assets.image.image);
print(assets.animation.animation);
```

## Annotation values

1. isCamelCase : The first letter is written in lowercase. The first letter of the rest of the following words is capitalized.
2. isSnakeCase : Place an underline in the middle of each word joined.
3. version: Used for update