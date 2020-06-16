// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// @dart = 2.7

import "native_testing.dart";

abstract class Window {
  int get document native;
}

// Defining this global object makes Frog eager on optimizing
// call sites where the receiver is typed 'Window'.
@Native("@*DOMWindow")
class _DOMWindowJs implements Window {
  int get document native;
}

class Win implements Window {
  noSuchMethod(m) => super.noSuchMethod(m);
}

main() {
  nativeTesting();
  // By not typing the variable, Frog does not try to optimize calls
  // on it.
  dynamic win = new Win();
  Expect.throws(() => win.document, (e) => e is NoSuchMethodError);
}
