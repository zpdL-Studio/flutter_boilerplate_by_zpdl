import 'dart:math';

import 'node.dart';

class NodeList<E> extends NodeBase<List<E>> implements List<E> {

  final List<E> _list;
  NodeList({List<E>? initial, dynamic key}): _list = initial ?? <E>[], super(key);

  @override
  List<E> get value => _list;

  @override
  E get first => _list.first;

  @override
  set first(E value) {
    _list.first = value;
    nodeNotifyChanged();
  }

  @override
  E get last => _list.last;

  @override
  set last(E value) {
    _list.last = value;
    nodeNotifyChanged();
  }

  @override
  int get length => _list.length;

  @override
  set length(int newLength) {
    _list.length = newLength;
    nodeNotifyChanged();
  }

  @override
  List<E> operator +(List<E> other) => _list + other;

  @override
  E operator [](int index) => _list[index];

  @override
  void operator []=(int index, E value) {
    _list[index] = value;
    nodeNotifyChanged();
  }

  @override
  void add(E value) {
    _list.add(value);
    nodeNotifyChanged();
  }

  @override
  void addAll(Iterable<E> iterable) {
    _list.addAll(iterable);
    nodeNotifyChanged();
  }

  @override
  bool any(bool Function(E element) test) => _list.any(test);

  @override
  Map<int, E> asMap() => _list.asMap();

  @override
  List<R> cast<R>() => _list.cast();

  @override
  void clear() {
    _list.clear();
    nodeNotifyChanged();
  }

  @override
  bool contains(Object? element) => _list.contains(element);

  @override
  E elementAt(int index) => _list.elementAt(index);

  @override
  bool every(bool Function(E element) test) => _list.every(test);

  @override
  Iterable<T> expand<T>(Iterable<T> Function(E element) f) => _list.expand(f);

  @override
  void fillRange(int start, int end, [E? fillValue]) => _list.fillRange(start, end, fillValue);

  @override
  E firstWhere(bool Function(E element) test, {E Function()? orElse}) => _list.firstWhere(test, orElse: orElse);

  @override
  T fold<T>(T initialValue, T Function(T previousValue, E element) combine) => _list.fold(initialValue, combine);

  @override
  Iterable<E> followedBy(Iterable<E> other) => _list.followedBy(other);

  @override
  void forEach(void Function(E element) f) => _list.forEach(f);

  @override
  Iterable<E> getRange(int start, int end) => _list.getRange(start, end);

  @override
  int indexOf(E element, [int start = 0]) => _list.indexOf(element, start);

  @override
  int indexWhere(bool Function(E element) test, [int start = 0]) => _list.indexWhere(test, start);

  @override
  void insert(int index, E element) {
    _list.insert(index, element);
    nodeNotifyChanged();
  }

  @override
  void insertAll(int index, Iterable<E> iterable) {
    _list.insertAll(index, iterable);
    nodeNotifyChanged();
  }

  @override
  bool get isEmpty => _list.isEmpty;

  @override
  bool get isNotEmpty => _list.isNotEmpty;

  @override
  Iterator<E> get iterator => _list.iterator;

  @override
  String join([String separator = '']) => _list.join(separator);

  @override
  int lastIndexOf(E element, [int? start]) => _list.lastIndexOf(element, start);

  @override
  int lastIndexWhere(bool Function(E element) test, [int? start]) => _list.lastIndexWhere(test, start);

  @override
  E lastWhere(bool Function(E element) test, {E Function()? orElse}) => _list.lastWhere(test, orElse: orElse);

  @override
  Iterable<T> map<T>(T Function(E e) f) => _list.map(f);

  @override
  E reduce(E Function(E value, E element) combine) => _list.reduce(combine);

  @override
  bool remove(Object? value) {
    final result = _list.remove(value);
    nodeNotifyChanged();
    return result;
  }

  @override
  E removeAt(int index) {
    final result = _list.removeAt(index);
    nodeNotifyChanged();
    return result;
  }

  @override
  E removeLast() {
    final result = _list.removeLast();
    nodeNotifyChanged();
    return result;
  }

  @override
  void removeRange(int start, int end) {
    _list.removeRange(start, end);
    nodeNotifyChanged();
  }

  @override
  void removeWhere(bool Function(E element) test) {
    _list.removeWhere(test);
    nodeNotifyChanged();
  }

  @override
  void replaceRange(int start, int end, Iterable<E> replacements) {
    _list.replaceRange(start, end, replacements);
    nodeNotifyChanged();
  }

  @override
  void retainWhere(bool Function(E element) test) {
    _list.retainWhere(test);
    nodeNotifyChanged();
  }

  @override
  Iterable<E> get reversed => _list.reversed;

  @override
  void setAll(int index, Iterable<E> iterable) {
    _list.setAll(index, iterable);
    nodeNotifyChanged();
  }

  @override
  void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0]) {
    _list.setRange(start, end, iterable, skipCount);
    nodeNotifyChanged();
  }

  @override
  void shuffle([Random? random]) {
    _list.shuffle(random);
    nodeNotifyChanged();
  }

  @override
  E get single => _list.single;

  @override
  E singleWhere(bool Function(E element) test, {E Function()? orElse}) => _list.singleWhere(test, orElse: orElse);

  @override
  Iterable<E> skip(int count) => _list.skip(count);

  @override
  Iterable<E> skipWhile(bool Function(E value) test) => _list.skipWhile(test);

  @override
  void sort([int Function(E a, E b)? compare]) {
    _list.sort(compare);
    nodeNotifyChanged();
  }

  @override
  List<E> sublist(int start, [int? end]) => _list.sublist(start, end);

  @override
  Iterable<E> take(int count) => _list.take(count);

  @override
  Iterable<E> takeWhile(bool Function(E value) test) => _list.takeWhile(test);

  @override
  List<E> toList({bool growable = true}) => _list.toList(growable: growable);

  @override
  Set<E> toSet() => _list.toSet();

  @override
  Iterable<E> where(bool Function(E element) test) => _list.where(test);

  @override
  Iterable<T> whereType<T>() => _list.whereType();

  @override
  T? findNodeByKey<T extends NodeBase>(dynamic key) {
    if (key != null && key == this.key && this is T) {
      return this as T;
    }
    return null;
  }
}

extension ListExtension<E> on List<E> {
  E? firstWhereOrNull(bool Function(E element) test) {
    for(final element in this) {
      if(test(element)) {
        return element;
      }
    }
    return null;
  }

  T? firstWhereMap<T>(T? Function(E element) test) {
    for(final element in this) {
      final result = test(element);
      if(result != null) {
        return result;
      }
    }

    return null;
  }

  int countWhere(bool Function(E element) test) {
    var count = 0;
    for(final element in this) {
      final result = test(element);
      if(result) {
        count++;
      }
    }
    return count;
  }
}