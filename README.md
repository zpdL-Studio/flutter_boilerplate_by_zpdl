# flutter_boilerplate_by_zpdl

Create Package
flutter create --org studio.zpdl --template=package widgets_by_zpdl

Create Plugin
flutter create --androidx --org studio.zpdl --template=plugin --platforms=android,ios -i swift -a kotlin store_camera_plugin_camera


# Create build.dart
flutter packages pub run build_runner build --delete-conflicting-outputs

flutter pub run build_runner build clean
flutter pub run build_runner build --delete-conflicting-outputs