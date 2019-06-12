// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:test/test.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import 'driver_resolution.dart';

main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(FunctionTypeAliasResolutionTest);
  });
}

@reflectiveTest
class FunctionTypeAliasResolutionTest extends DriverResolutionTest {
  test_type_element() async {
    addTestFile(r'''
G<int> g;

typedef T G<T>();
''');
    await resolveTestFile();

    var type = findElement.topVar('g').type;
    assertElementTypeString(type, 'int Function()');

    var typedefG = findElement.genericTypeAlias('G');
    var functionG = typedefG.function;

    expect(type.element?.enclosingElement, typedefG);
    expect(type.element, functionG);
  }
}
