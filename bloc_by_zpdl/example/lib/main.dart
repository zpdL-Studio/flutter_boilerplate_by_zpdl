import 'package:bloc_by_zpdl/bloc_by_zpdl.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: BLoCProviderWidget(
        binding: (provider) {
          provider.addBLoC(HomeBLoC());
        },
        builder: (context) => HomePage(),
      ),
    );
  }
}

class HomeBLoC extends BLoC with BLoCLifeCycle {

  final count = BehaviorSubject<int>();

  String _text = '';
  String get text => _text;
  set text(String text) {
    _text = text;
    notifyListeners();
  }

  @override
  void init() {
    super.init();

    count.value = 0;
  }

  @override
  void dispose() {
    count.close();
    super.dispose();
  }

  @override
  void onResume() {
    print('KKH HomeBLoC onResume');
  }

  @override
  void onPause() {
    print('KKH HomeBLoC onPause');
  }
}

class HomePage extends BLoCView<HomeBLoC> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times: ${bLoC.text}',
            ),
            StreamBuilder<int>(
              stream: bLoC.count.stream,
              builder: (context, snapshot) {
                return Text(
                  '${snapshot.data ?? 0}',
                  style: Theme.of(context).textTheme.headline4,
                );
              }
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bLoC.count.value = bLoC.count.value + 1;
          bLoC.text = 'Increment ${bLoC.count.value}';
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
