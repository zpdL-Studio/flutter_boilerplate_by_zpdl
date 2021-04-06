
extension StringBufferExtension on StringBuffer {
  void writeLine(int tab, [Object? obj = '']) {
    String write = '';
    for(int i = 0; i < tab; i++) {
      write += '\t';
    }
    write += '$obj';
    writeln(write);
  }
}