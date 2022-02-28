import 'package:flutter/material.dart';
import 'package:contract_by_zpdl/contract_by_zpdl.dart';

void main() {
  runApp(MaterialApp.router(
    title: 'Contract by zpdl example',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    routerDelegate: contract.initRouterDelegate(const HomePage(), const [
      NamedPage('1', '2'),
      NamedPage('2', '3'),
      NamedPage('3', null),
      NamedPage('a', 'b'),
      NamedPage('b', 'c'),
      NamedPage('c', null),
    ]),
    routeInformationParser: contract.parser,

    // home: const MyHomePage(title: 'Flutter Demo Home Page'),
  ));
}

class HomePage extends HomePageBinder {

  const HomePage(): super();

  @override
  bool binding(BuildContext context, PresenterBinder binder, Map<String, String> queryParameter, Object? arguments) {
    binder.put(HomePresenter());
    return true;
  }

  @override
  Widget builder(BuildContext context) {
    return ViewBuilder<HomePresenter>(builder: (context, presenter) {
      return Scaffold(
        appBar: AppBar(title: Text('Home'),),
        body: Column(
          children: [
            ListTile(
              onTap: () {
                Contract.push('1');
              },
              title: const Text('Page 1'),
            ),
            ListTile(
              onTap: () {
                Contract.push('a');
              },
              title: const Text('Page 2'),
            ),
            Expanded(child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'You have pushed the button this many times:',
                  ),
                  Text(
                    '${presenter.count}',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              ),
            ))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: presenter.increment,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      );
    });
  }
}

class HomePresenter extends Presenter {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}

class NamedPage extends PageBinder {

  final String? nextPage;
  const NamedPage(String path, this.nextPage) : super(path);

  @override
  bool binding(BuildContext context, PresenterBinder binder, Map<String, String> queryParameter, Object? arguments) => true;

  @override
  Widget builder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(path),),
      body: Center(
        child: Text('Current Page : $path\nNext Page : $nextPage'),
      ),
      floatingActionButton: nextPage != null ? FloatingActionButton(
        onPressed: () {
          Contract.push(nextPage!);
        },
        child: const Icon(Icons.navigate_next),
      ) : null
    );
  }
}