// Copyright (c) 2021, Apparence.io.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Annotation to use on a class factory or constructor
/// - the return type is entered into the dependency graph. The method will be
///   executed with injected arguments when the return type is injected.
///
/// The type provided by this annotation can be further specified by including a
/// [Qualifier] annotation.
class Provide {
  const Provide();
}

/// Annotation to use on a class factory or constructor
class Singleton {
  const Singleton();
}

/// Annotation to use on a class
/// - the return type is entered into the dependency graph.
class Injectable {
  const Injectable();
}

/// @Inject
/// - add this on a factory constructor
/// - will try to inject all dependencies of this constructor
class Inject {
  final List<InjectedChild> children;

  const Inject({required this.children});
}

class InjectedChild {
  final Type type;
  final String? factoryName, attrName;

  const InjectedChild(this.type, {this.factoryName, this.attrName});
}
