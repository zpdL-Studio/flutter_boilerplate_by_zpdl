//
//
// class BLoCProviderWidget extends StatefulWidget {
//   final List<BLoC> bLoCs;
//   final Widget child;
//
//   const BLoCProvider({Key? key, required this.bLoCs, required this.child, }) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() => _BLoCProviderState();
// }
//
// class _BLoCProviderState extends State<BLoCProviderWidget> with BLoCProvider {
//
//   final List<BLoC> _bLoCs = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _bLoCs.addAll(widget.bLoCs.toList());
//     bLoCs = widget.bLoCs.toList();
//     for(final bLoC in bLoCs) {
//       bLoC._contextCallback = () => context;
//     }
//     // context.visitAncestorElements((element) => false)
//     // _BLoCProvider.instance._pushState(this);
//   }
//
//   @override
//   void dispose() {
//     // _BLoCProvider.instance._popState(this);
//
//     for(final bLoC in bLoCs) {
//       bLoC.dispose();
//     }
//     bLoCs.clear();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.child;
//   }
// }