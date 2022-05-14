import 'package:assets_annotation_by_zpdl/assets_annotation_by_zpdl.dart';
import 'package:flutter/material.dart';

part 'main.g.dart';

void main() {
  runApp(const MyApp());
}

/// original naming
@AssetsAnnotation(version: '1.0.0')
class Assets {
  const Assets();
}

const assets = Assets();

/// camel case naming
@AssetsAnnotation.camelCase(version: '1.0.0')
class AssetsCamel {
  const AssetsCamel();
}

const assetsCamel = AssetsCamel();

/// snake case naming
@AssetsAnnotation.snakeCase(version: '1.0.0')
class AssetsSnake {
  const AssetsSnake();
}

const assetsSnake = AssetsSnake();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'assets generator by zpdl Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assets generator',)),
      body: ListView(
        children: [
          _buildListTile(
              assets.image.uog____61___264____32__1____920,
              assetsCamel.image.og61264321920,
              assetsSnake.image.og____61___264____32__1____920),
          _buildListTile(
              assets.image.camelAlbum.iconCalendarJpg,
              assetsCamel.image.camelAlbum.iconCalendarJpg,
              assetsSnake.image.camel_album.icon_calendar_jpg),
          _buildListTile(
              assets.image.snake_guide.snake_guide,
              assetsCamel.image.snakeGuide.snakeGuide,
              assetsSnake.image.snake_guide.snake_guide),
          _buildListTile(
              assets.camelGuide,
              assetsCamel.camelGuide,
              assetsSnake.camel_guide),
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