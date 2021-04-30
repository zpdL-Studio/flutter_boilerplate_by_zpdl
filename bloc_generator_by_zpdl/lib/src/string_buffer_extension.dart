
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