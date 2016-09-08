// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library analyzer.src.generated.java_core;

final Stopwatch nanoTimeStopwatch = new Stopwatch();

/**
 * Inserts the given arguments into [pattern].
 *
 *     format('Hello, {0}!', 'John') = 'Hello, John!'
 *     format('{0} are you {1}ing?', 'How', 'do') = 'How are you doing?'
 *     format('{0} are you {1}ing?', 'What', 'read') = 'What are you reading?'
 */
String format(String pattern,
    [arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7]) {
  // TODO(rnystrom): This is not used by analyzer, but is called by
  // analysis_server. Move this code there and remove it from here.
  return formatList(pattern, [arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7]);
}

/**
 * Inserts the given [arguments] into [pattern].
 *
 *     format('Hello, {0}!', ['John']) = 'Hello, John!'
 *     format('{0} are you {1}ing?', ['How', 'do']) = 'How are you doing?'
 *     format('{0} are you {1}ing?', ['What', 'read']) = 'What are you reading?'
 */
String formatList(String pattern, List<Object> arguments) {
  if (arguments == null || arguments.isEmpty) {
    assert(!pattern.contains(new RegExp(r'\{(\d+)\}')));
    return pattern;
  }
  return pattern.replaceAllMapped(new RegExp(r'\{(\d+)\}'), (match) {
    String indexStr = match.group(1);
    int index = int.parse(indexStr);
    Object arg = arguments[index];
    assert(arg != null);
    return arg?.toString();
  });
}

/// Parses given string to [Uri], throws [URISyntaxException] if invalid.
Uri parseUriWithException(String str) {
  Uri uri;
  try {
    uri = Uri.parse(str);
  } on FormatException catch (e) {
    throw new URISyntaxException(e.toString());
  }
  if (uri.path.isEmpty) {
    throw new URISyntaxException('empty path');
  }
  return uri;
}

/**
 * Very limited printf implementation, supports only %s and %d.
 */
String _printf(String fmt, List args) {
  StringBuffer sb = new StringBuffer();
  bool markFound = false;
  int argIndex = 0;
  for (int i = 0; i < fmt.length; i++) {
    int c = fmt.codeUnitAt(i);
    if (c == 0x25) {
      if (markFound) {
        sb.writeCharCode(c);
        markFound = false;
      } else {
        markFound = true;
      }
      continue;
    }
    if (markFound) {
      markFound = false;
      // %d
      if (c == 0x64) {
        sb.write(args[argIndex++]);
        continue;
      }
      // %s
      if (c == 0x73) {
        sb.write(args[argIndex++]);
        continue;
      }
      // unknown
      throw new IllegalArgumentException(
          '[$fmt][$i] = 0x${c.toRadixString(16)}');
    } else {
      sb.writeCharCode(c);
    }
  }
  return sb.toString();
}

class Character {
  static const int MAX_VALUE = 0xffff;
  static const int MAX_CODE_POINT = 0x10ffff;
  static const int MIN_SUPPLEMENTARY_CODE_POINT = 0x010000;
  static const int MIN_LOW_SURROGATE = 0xDC00;
  static const int MIN_HIGH_SURROGATE = 0xD800;

  static int digit(int codePoint, int radix) {
    if (radix != 16) {
      throw new ArgumentError("only radix == 16 is supported");
    }
    if (0x30 <= codePoint && codePoint <= 0x39) {
      return codePoint - 0x30;
    }
    if (0x41 <= codePoint && codePoint <= 0x46) {
      return 0xA + (codePoint - 0x41);
    }
    if (0x61 <= codePoint && codePoint <= 0x66) {
      return 0xA + (codePoint - 0x61);
    }
    return -1;
  }

  static bool isDigit(int c) => c >= 0x30 && c <= 0x39;

  static bool isLetter(int c) =>
      c >= 0x41 && c <= 0x5A || c >= 0x61 && c <= 0x7A;

  static bool isLetterOrDigit(int c) => isLetter(c) || isDigit(c);

  static bool isWhitespace(int c) =>
      c == 0x09 || c == 0x20 || c == 0x0A || c == 0x0D;

  static String toChars(int codePoint) {
    if (codePoint < 0 || codePoint > MAX_CODE_POINT) {
      throw new IllegalArgumentException();
    }
    if (codePoint < MIN_SUPPLEMENTARY_CODE_POINT) {
      return new String.fromCharCode(codePoint);
    }
    int offset = codePoint - MIN_SUPPLEMENTARY_CODE_POINT;
    int c0 = ((offset & 0x7FFFFFFF) >> 10) + MIN_HIGH_SURROGATE;
    int c1 = (offset & 0x3ff) + MIN_LOW_SURROGATE;
    return new String.fromCharCodes([c0, c1]);
  }
}

abstract class Enum<E extends Enum> implements Comparable<E> {
  /// The name of this enum constant, as declared in the enum declaration.
  final String name;

  /// The position in the enum declaration.
  final int ordinal;
  const Enum(this.name, this.ordinal);
  int get hashCode => ordinal;
  int compareTo(E other) => ordinal - other.ordinal;
  String toString() => name;
}

class IllegalArgumentException extends JavaException {
  IllegalArgumentException([message = "", cause = null])
      : super(message, cause);
}

class IllegalStateException extends JavaException {
  IllegalStateException([message = ""]) : super(message);
}

class JavaArrays {
  static int makeHashCode(List a) {
    // TODO(rnystrom): This is not used by analyzer, but is called by
    // analysis_server. Move this code there and remove it from here.
    if (a == null) {
      return 0;
    }
    int result = 1;
    for (var element in a) {
      result = 31 * result + (element == null ? 0 : element.hashCode);
    }
    return result;
  }
}

class JavaException implements Exception {
  final String message;
  final Object cause;
  JavaException([this.message = "", this.cause = null]);
  JavaException.withCause(this.cause) : message = null;
  String toString() => "$runtimeType: $message $cause";
}

class JavaIOException extends JavaException {
  JavaIOException([message = "", cause = null]) : super(message, cause);
}

class JavaPatternMatcher {
  Iterator<Match> _matches;
  Match _match;
  JavaPatternMatcher(RegExp re, String input) {
    _matches = re.allMatches(input).iterator;
  }
  int end() => _match.end;
  bool find() {
    if (!_matches.moveNext()) {
      return false;
    }
    _match = _matches.current;
    return true;
  }

  String group(int i) => _match[i];
  bool matches() => find();
  int start() => _match.start;
}

class JavaString {
  static int indexOf(String target, String str, int fromIndex) {
    if (fromIndex > target.length) return -1;
    if (fromIndex < 0) fromIndex = 0;
    return target.indexOf(str, fromIndex);
  }

  static int lastIndexOf(String target, String str, int fromIndex) {
    if (fromIndex > target.length) return -1;
    if (fromIndex < 0) fromIndex = 0;
    return target.lastIndexOf(str, fromIndex);
  }
}

class JavaSystem {
  static int currentTimeMillis() {
    return (new DateTime.now()).millisecondsSinceEpoch;
  }

  static int nanoTime() {
    if (!nanoTimeStopwatch.isRunning) {
      nanoTimeStopwatch.start();
    }
    return nanoTimeStopwatch.elapsedMicroseconds * 1000;
  }
}

class MissingFormatArgumentException implements Exception {
  final String s;

  MissingFormatArgumentException(this.s);

  String toString() => "MissingFormatArgumentException: $s";
}

class NoSuchElementException extends JavaException {
  String toString() => "NoSuchElementException";
}

class NotImplementedException extends JavaException {
  NotImplementedException(message) : super(message);
}

class NumberFormatException extends JavaException {
  String toString() => "NumberFormatException";
}

class PrintStringWriter extends PrintWriter {
  final StringBuffer _sb = new StringBuffer();

  void print(x) {
    _sb.write(x);
  }

  String toString() => _sb.toString();
}

abstract class PrintWriter {
  void newLine() {
    this.print('\n');
  }

  void print(x);

  void printf(String fmt, List args) {
    this.print(_printf(fmt, args));
  }

  void println(String s) {
    this.print(s);
    this.newLine();
  }
}

class RuntimeException extends JavaException {
  RuntimeException({String message: "", Exception cause: null})
      : super(message, cause);
}

class StringIndexOutOfBoundsException extends JavaException {
  StringIndexOutOfBoundsException(int index) : super('$index');
}

class UnsupportedOperationException extends JavaException {
  UnsupportedOperationException([message = ""]) : super(message);
}

class URISyntaxException implements Exception {
  final String message;
  URISyntaxException(this.message);
  String toString() => "URISyntaxException: $message";
}
