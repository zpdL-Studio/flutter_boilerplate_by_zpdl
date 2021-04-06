/// Business Logic Component
abstract class BLoC {
  void disposeBLoC();
}

// typedef BLoCBuildCallback<T extends BLoC> = Widget Function(BuildContext context, T bLoC);
//
// abstract class BLoCBuilder<T extends BLoC> {
//   Widget bLoCBuild(BuildContext context, T bLoC);
// }
//
// abstract class BLoCProvider<T extends BLoC> extends StatefulWidget implements BLoCBuilder<T> {
//   const BLoCProvider({Key? key}) : super(key: key);
// }
//
// abstract class BLoCConsumer<T extends BLoC> extends StatelessWidget implements BLoCBuilder<T> {
//
//   @override
//   Widget build(BuildContext context) {
//     return bLoCBuild(context, BLoCConsumer.of<T>(context));
//   }
//
//   static T of<T extends BLoC>(BuildContext context) {
//     throw BLoCNotFoundException('BLoCConsumer T : $T');
//   }
// }