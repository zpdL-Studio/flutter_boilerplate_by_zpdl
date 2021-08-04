library assets_generator_by_zpdl;

import 'dart:async';
import 'dart:io';

import 'package:assets_annotation_by_zpdl/assets_annotation_by_zpdl.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:yaml/yaml.dart';

class AssetsGenerator
    extends GeneratorForAnnotation<AssetsAnnotation> {
  const AssetsGenerator();

  @override
  FutureOr<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    print('AssetsGenerator element : $element name : ${element.name}');

    if (element is! ClassElement) {
      final name = element.name;
      throw InvalidGenerationSourceError('Generator cannot target `$name`.',
          todo: 'Remove the Assets annotation from `$name`.',
          element: element);
    }

    final pubspec = loadYaml(File('pubspec.yaml').readAsStringSync());
    print('AssetsGenerator pubspec : $pubspec');

    final assets = pubspec['flutter']['assets'] as YamlList;
    print('AssetsGenerator assets $assets');

    final root = <String, dynamic>{};
    for(final assetsPath in assets) {
      var uri = Uri.parse(assetsPath);
      print('uri ${uri.pathSegments}');
      if(uri.pathSegments.isNotEmpty) {
        final name = uri.pathSegments.last;

        if(name.isEmpty) { // Directory
          final directory = Directory.fromUri(uri);
          if(directory.existsSync()) {
            var node = _addPath(root, directory.uri.pathSegments);
            for(final file in directory.listSync()) {
              if(file is File) {
                _addFile(node, file);
              }
            }
          }
        } else { // File
          final file = File.fromUri(uri);
          if(file.existsSync()) {
            var node = _addPath(root, file.parent.uri.pathSegments);
            _addFile(node, file);
          }
        }
      }
    }

    var entries = root.entries;
    while(entries.length <= 1) {
      if(entries.isNotEmpty) {
        final value = entries.first.value;
        if(value is Map<String, dynamic>) {
          entries = value.entries;
          continue;
        }
      }
      break;
    }

    final writeClass = <_WriteClass>[];
    final writeFile = <String, List<File>>{};
    final childrenWriteLine = <_WriteLine>[];

    for(final entry in entries) {
      final key = entry.key;
      final value = entry.value;
      if(value is Map<String, dynamic>) {
        final childClassName = '_' + _firstUpper(key);
        childrenWriteLine.addAll(_writeCodeBody(childClassName, value.entries, singleInstance: true));
        writeClass.add(_WriteClass(key, childClassName));
      } else if(value is File) {
        var list = writeFile[value.name];
        if(list == null) {
          list = [value];
          writeFile[value.name] = list;
        } else {
          list.add(value);
        }
      }
    }

    final code = StringBuffer();
    code.writeLine(0, 'extension ${element.name}Extension on ${element.name} {');
    for(final write in writeClass) {
      code.writeLine(1, '${write.className} get ${write.key} => ${write.className}();');
    }
    code.writeLine(0, '');
    _writeFiles(writeFile,
        (key, value) => code.writeLine(1, 'String get $key => \'$value\';'));

    code.writeLine(0, '}');
    code.writeLine(0, '');

    for(final writeLine in childrenWriteLine) {
      code.writeLine(writeLine.tab, writeLine.str);
    }

    return code.toString();
  }

  Map<String, dynamic> _addPath(Map<String, dynamic> root, List<String> pathSegments) {
    final list = pathSegments.toList()..removeWhere((element) => element.isEmpty);

    var node = root;
    for(final pathSegment in list) {
      final value = node[pathSegment];
      if(value == null) {
        final newNode = <String, dynamic>{};
        node[pathSegment] = newNode;
        node = newNode;
      } else if(value is Map<String, dynamic>) {
        node = value;
      } else {
        throw ArgumentError('AssetsGenerator _addPath is not directory $pathSegments');
      }
    }

    return node;
  }

  void _addFile(Map<String, dynamic> node, File file) {
    if(file.existsSync()) {
      node[file.fileName] = file;
    }
  }

  List<_WriteLine> _writeCodeBody(String className, Iterable<MapEntry<String, dynamic>> entries, {bool singleInstance = false}) {
    final results = <_WriteLine>[];
    final childrenWriteLine = <_WriteLine>[];

    final writeClass = <_WriteClass>[];
    final writeFile = <String, List<File>>{};

    for(final entry in entries) {
      final key = entry.key;
      final value = entry.value;
      if(value is Map<String, dynamic>) {
        final childClassName = className + _firstUpper(key);
        childrenWriteLine.addAll(_writeCodeBody(childClassName, value.entries));
        childrenWriteLine.add(_WriteLine.empty());

        writeClass.add(_WriteClass(key, childClassName));
      } else if(value is File) {
        var list = writeFile[value.name];
        if(list == null) {
          list = [value];
          writeFile[value.name] = list;
        } else {
          list.add(value);
        }
      }
    }

    results.add(_WriteLine(0, 'class $className {'));
    if(singleInstance) {
      results.add(_WriteLine(1, 'static final $className _instance = $className._();'));
      results.add(_WriteLine(1, 'factory $className() => _instance;'));
      results.add(_WriteLine(1, '$className._();'));
    } else {
      results.add(_WriteLine(1, 'const $className();'));
    }
    results.add(_WriteLine.empty());
    for(final write in writeClass) {
      results.add(_WriteLine(1, 'final ${write.className} ${write.key} = const ${write.className}();'));
    }
    results.add(_WriteLine.empty());
    _writeFiles(
        writeFile,
        (key, value) =>
            results.add(_WriteLine(1, 'final String $key = \'$value\';')));
    results.add(_WriteLine(0, '}'));
    results.addAll(childrenWriteLine);
    return results;
  }

  String _firstUpper(String str) {
    if(str.isNotEmpty) {
      var sb = StringBuffer();
      var upper = true;
      for(var i = 0; i < str.length; i++) {
        if(upper) {
          sb.write(str[i].toUpperCase());
          upper = false;
        } else if(str[i] == '_') {
          upper = true;
        } else {
          sb.write(str[i]);
        }
      }

      return sb.toString();
    }
    return str;
  }

  void _writeFiles(Map<String, List<File>> files, void Function(String key, String value) onWriter) {
    // final writeMap = <String, List<File>>{};
    // for(final file in files) {
    //   var list = writeMap[file.name];
    //   if(list == null) {
    //     list = [file];
    //     writeMap[file.name] = list;
    //   } else {
    //     list.add(file);
    //   }
    // }

    for(final entry in files.entries) {
      final value = entry.value;
      if(value.isNotEmpty) {
        if(value.length == 1) {
          onWriter(value.first.name, value.first.path);
        } else {
          for(final file in value) {
            onWriter(file.name + _firstUpper(file.extension), file.path);
          }
        }
      }
    }
  }
}

// class AssetsNode {
//   final String name;
//   final List<AssetsNode> children = [];
//
//   AssetsNode(this.name);
//
//   AssetsNode? _findNodeByName(String name) {
//     for (final child in children) {
//       if (child.name == name) {
//         return child;
//       }
//     }
//     return null;
//   }
//
//   AssetsNode put(List<String> pathSegments) {
//     var currentNode = this;
//
//     for(final segment in pathSegments) {
//       var node = currentNode._findNodeByName(segment);
//       if(node == null) {
//         node = AssetsNode(segment);
//         currentNode.children.add(node);
//       }
//       currentNode = node;
//     }
//
//     return currentNode;
//   }
//
//   void add(String name) {
//     if(children == null) {
//       children = [];
//     }
//     children?.add(AssetsNode(name, this, null));
//   }
// }

extension FileExtension on File {

  String get fileName => path.split('/').last;

  String get name {
    final fileName = this.fileName;
    return fileName.contains('.') ? fileName.split('.').first : fileName;
  }

  String get extension {
    final fileName = this.fileName;
    return fileName.contains('.') ? fileName.split('.').last : '';
  }
}

extension StringBufferExtension on StringBuffer {
  void writeLine(int tab, [Object? obj = '']) {
    var write = '';
    for(var i = 0; i < tab; i++) {
      write += '\t';
    }
    write += '$obj';
    writeln(write);
  }
}

class _WriteLine {
  final int tab;
  final String str;

  _WriteLine(this.tab, this.str);

  factory _WriteLine.empty() => _WriteLine(0, '');
}

class _WriteClass {
  final String key;
  final String className;

  _WriteClass(this.key, this.className);
}

