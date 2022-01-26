part of 'contract.dart';

class _Configure {
  final Uri uri;
  final Object? arguments;

  _Configure(this.uri, {this.arguments});

  _Configure.home({this.arguments}): uri = Uri.parse('/');

  String get path => uri.path;

  List<String> get pathSegments => uri.pathSegments;
}

class _RouteInformationParser extends RouteInformationParser<_Configure> {

  const _RouteInformationParser(): super();

  @override
  Future<_Configure> parseRouteInformation(RouteInformation routeInformation) async {
    final location = routeInformation.location;
    if(location != null) {
      final uri = Uri.parse(location);
      return _Configure(uri, arguments: routeInformation.state);
    }

    return _Configure.home(arguments: routeInformation.state);
  }

  @override
  RouteInformation? restoreRouteInformation(_Configure configuration) {
    return RouteInformation(
      location: configuration.uri.toString(),
      state: configuration.arguments
    );
  }
}

class _RouterDelegate extends RouterDelegate<_Configure>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<_Configure> {   // ignore: prefer_mixin

  final Contract contract;
  final HomePageBinder home;
  final PageBinder page404;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  String? _currentLocation;

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  _RouterDelegate({required this.contract, required this.home, required this.page404, List<PageBinder>? pages}) {
    // SystemNavigator.selectSingleEntryHistory().then((value) {
    //   print('selectSingleEntryHistory');
    // });
    // SystemNavigator.selectMultiEntryHistory();
    this.pages = {};
    if(pages != null) {
      for (final page in pages) {
        this.pages[page.path] = page;
      }
    }
  }

  late final Map<String, PageBinder> pages;

  @override
  _Configure? get currentConfiguration =>
      contract.lastBinder?.configure;

  @override
  Widget build(BuildContext context) {
    List<Page> stack = contract._binders
        .map((e) => e.page
            .createPage(context, e.configure.uri, e.configure.arguments, _ContractWidget(bucket: e)))
        .toList();

    if(stack.isEmpty) {
      stack.add(MaterialPage(child: Container()));
    }

    // final currentLocation = currentConfiguration?.uri.toString();
    // if(currentLocation != null && _currentLocation != currentLocation) {
    //   print('_currentLocation ${_currentLocation} $currentLocation');
    //   _currentLocation = currentLocation;
    //   SystemNavigator.routeInformationUpdated(location: currentLocation);
    // }

    return Navigator(
      key: navigatorKey,
      pages: stack,
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        final name = route.settings.name;
        if(name != null && _popPage(name, result)) {
          // SystemNavigator.pop();
          SystemNavigator.routeInformationUpdated(location: currentConfiguration!.uri.toString());
          // notifyListeners();
        }
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(_Configure configure) async {
    print('setNewRoutePath ${configure.uri}');
    _currentLocation = configure.uri.toString();
    contract._setNewContract(this, configure);
    notifyListeners();
  }

  bool _popPage(String name, dynamic result) {
    for(final binder in contract._binders.reversed) {
      if(binder.configure.uri.toString() == name) {
        contract._popBinder(binder, result);
        return true;
      }
    }
    return false;
  }

  PageBinder _getPage(String name) {
    return pages[name] ?? page404;
  }

  void _notifyListeners() => notifyListeners();
}