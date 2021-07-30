typedef NodeNotifyChangedCallback = void Function();

abstract class NodeBase<E> {

  dynamic key;

  NodeBase(this.key);

  int get length;

  E get value;

  final List<NodeNotifyChangedCallback> _callbacks = [];

  void addNodeNotifyChangedCallback(NodeNotifyChangedCallback callback) {
    _callbacks.add(callback);
  }

  void removeNodeNotifyChangedCallback(NodeNotifyChangedCallback callback) {
    _callbacks.remove(callback);
  }

  void nodeNotifyChanged() {
    for(final callback in _callbacks) {
      callback();
    }
  }

  T? findNodeByKey<T extends NodeBase>(dynamic key);
}

class Node<E> extends NodeBase<E> {

  E _value;

  Node({required E value, dynamic key}): _value = value, super(key);

  @override
  T? findNodeByKey<T extends NodeBase>(dynamic key) {
    if (key != null && key == this.key && this is T) {
      return this as T;
    }
    return null;
  }

  @override
  int get length => 1;

  @override
  E get value => _value;

  set value(E v) {
    _value = v;
    nodeNotifyChanged();
  }
}

class Nodes extends NodeBase<List> {

  final List<NodeBase> _nodes;
  List<dynamic>? _list;

  Nodes({List<NodeBase> list = const [], dynamic key}): _nodes = list, super(key) {
    _nodes.forEach((element) {
      element.addNodeNotifyChangedCallback(nodeNotifyChanged);
    });
  }

  @override
  T? findNodeByKey<T extends NodeBase>(dynamic key) {
    if (key != null) {
      if (key == this.key && this is T) {
        return this as T;
      }

      for (final node in _nodes) {
        final result = node.findNodeByKey(key);
        if (result != null && result is T) {
          return result;
        }
      }
    }
    return null;
  }

  @override
  int get length => value.length;

  @override
  List get value {
    if(_list != null) {
      return _list!;
    }

    _list = List.unmodifiable([
      for(final node in _nodes)
        if(node.value is Iterable)
          ...node.value
        else if(node.value != null)
          node.value
    ]);
    return _list!;
  }

  dynamic operator [](int index) => value[index];

  @override
  void nodeNotifyChanged() {
    _list = null;
    super.nodeNotifyChanged();
  }

  void add(NodeBase node) {
    node.addNodeNotifyChangedCallback(nodeNotifyChanged);
    _nodes.add(node);
    nodeNotifyChanged();
  }

  void insert(int index, NodeBase node) {
    node.addNodeNotifyChangedCallback(nodeNotifyChanged);
    _nodes.insert(index, node);
    nodeNotifyChanged();
  }

  void clear() {
    for(final node in _nodes) {
      node.removeNodeNotifyChangedCallback(nodeNotifyChanged);
    }
    _nodes.clear();
    nodeNotifyChanged();
  }

  bool remove(NodeBase? node) {
    final result = _nodes.remove(node);
    if(result) {
      node?.removeNodeNotifyChangedCallback(nodeNotifyChanged);
      nodeNotifyChanged();
    }

    return result;
  }

  NodeBase removeAt(int index) {
    final result = _nodes.removeAt(index);
    result.removeNodeNotifyChangedCallback(nodeNotifyChanged);
    nodeNotifyChanged();
    return result;
  }

  Iterable<T> findNodeByType<T>() => _nodes.whereType();
}

