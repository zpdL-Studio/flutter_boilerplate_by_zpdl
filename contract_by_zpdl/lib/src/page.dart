import 'package:flutter/material.dart';

import 'contract.dart';

abstract class PageBinder {
  const PageBinder(this.path);

  final String path;

  bool binding(BuildContext context, PresenterBinder binder,
      Map<String, String> queryParameter, Object? arguments);

  Widget builder(BuildContext context);

  Page createPage(BuildContext context, Uri uri, Object? arguments, Widget child) {
    return MaterialPage(
      key: ValueKey(uri.toString()),
      name: uri.path,
      arguments: arguments,
      child: child,
    );
  }
}

abstract class HomePageBinder extends PageBinder {
  const HomePageBinder() : super('/');

  @override
  Page createPage(BuildContext context, Uri uri, Object? arguments, Widget child) {
    return NonAnimationPage(
      key: ValueKey(uri.toString()),
      name: uri.path,
      arguments: arguments,
      child: child,
    );
  }
}

class Page404 extends PageBinder {

  const Page404() : super('');

  @override
  bool binding(BuildContext context, PresenterBinder binder, Map<String, String> queryParameter, Object? arguments) {
    return true;
  }

  @override
  Widget builder(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text('404 Error', style: TextStyle(color: Colors.black, fontSize: 32),),
          SizedBox(height: 16,),
          Text('Not Found', style: TextStyle(color: Colors.black87, fontSize: 24),),
        ],
      ),
    );
  }
}

class NonAnimationPage<T> extends Page<T> {
  const NonAnimationPage({
    required this.child,
    LocalKey? key,
    String? name,
    Object? arguments,
    String? restorationId,
  }) : super(
            key: key,
            name: name,
            arguments: arguments,
            restorationId: restorationId);

  final Widget child;

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteNonAnimation<T>(
        builder: (context) {
          return Semantics(
            scopesRoute: true,
            explicitChildNodes: true,
            child: child,
          );
        },
        settings: this,);
  }
}

class PageRouteNonAnimation<T> extends MaterialPageRoute<T> {
  PageRouteNonAnimation({ required WidgetBuilder builder, RouteSettings? settings })
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}