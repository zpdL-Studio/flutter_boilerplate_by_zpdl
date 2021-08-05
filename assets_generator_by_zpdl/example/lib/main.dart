import 'package:assets_annotation_by_zpdl/assets_annotation_by_zpdl.dart';
import 'package:flutter/material.dart';

part 'main.g.dart';

void main() {
  runApp(MyApp());
}

/// original naming
@assetsAnnotation
class Assets {
  const Assets();
}

const assets = Assets();

/// camel case naming
@assetsAnnotationCamel
class AssetsCamel {
  const AssetsCamel();
}

const assetsCamel = AssetsCamel();

/// snake case naming
@assetsAnnotationSnake
class AssetsSnake {
  const AssetsSnake();
}

const assetsSnake = AssetsSnake();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'assets generator by zpdl Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Assets generator',)),
      body: ListView(
        children: [
          _buildListTile(
              assets.image.fog_6126432_1920,
              assetsCamel.image.fog61264321920,
              assetsSnake.image.fog_6126432_1920),
          _buildListTile(
              assets.image.camelAlbum.iconCalendarJpg,
              assetsCamel.image.camelAlbum.iconCalendarJpg,
              assetsSnake.image.camel_album.icon_calendar_jpg),
          _buildListTile(
              assets.image.snake_guide.snake_guide,
              assetsCamel.image.snakeGuide.snakeGuide,
              assetsSnake.image.snake_guide.snake_guide),
        ],
      ),
    );
  }

  Widget _buildListTile(String assets, String assetsCamel, String assetsSnake) {
    return ListTile(
      title: Text(assets),
      subtitle: Text('$assetsCamel\n$assetsSnake'),
      leading: Image.asset(assets),
    );
  }
}