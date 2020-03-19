import 'dart:async';

import 'package:flutter/material.dart';

/// A base class that holds some data and allows other classes to listen to
/// changes to that data.
///
/// In order to notify listeners that the data has changed, you must explicitly
/// call the [notifyListeners] method.
///
/// Generally used in conjunction with a [ScopedStateModel] Widget, but if you do not
/// need to pass the Widget down the tree, you can use a simple
/// [AnimatedBuilder] to listen for changes and rebuild when the model notifies
/// the listeners.
///
/// ### Example
///
/// ```
/// class CounterStateModel extends StateModel {
///   int _counter = 0;
///
///   int get counter => _counter;
///
///   void increment() {
///     // First, increment the counter
///     _counter++;
///
///     // Then notify all the listeners.
///     notifyListeners();
///   }
/// }
/// ```
abstract class StateModel extends Listenable {
  final Set<VoidCallback> _listeners = Set<VoidCallback>();
  int _version = 0;
  int _microtaskVersion = 0;

  /// [listener] will be invoked when the model changes.
  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  /// [listener] will no longer be invoked when the model changes.
  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  /// Returns the number of listeners listening to this model.
  int get listenerCount => _listeners.length;

  /// Should be called only by [StateModel] when the model has changed.
  @protected
  void notifyListeners() {
    // We schedule a microtask to debounce multiple changes that can occur
    // all at once.
    if (_microtaskVersion == _version) {
      _microtaskVersion++;
      scheduleMicrotask(() {
        _version++;
        _microtaskVersion = _version;

        // Convert the Set to a List before executing each listener. This
        // prevents errors that can arise if a listener removes itself during
        // invocation!
        _listeners.toList().forEach((VoidCallback listener) => listener());
      });
    }
  }
}

/// Finds a [StateModel]. Deprecated: Use [ScopedStateModel.of] instead.
@deprecated
class StateModelFinder<T extends StateModel> {
  /// Returns the [StateModel] of type [T] of the closest ancestor [ScopedStateModel].
  ///
  /// [Widget]s who call [of] with a [rebuildOnChange] of true will be rebuilt
  /// whenever there's a change to the returned model.
  T of(BuildContext context, {bool rebuildOnChange = false}) {
    return ScopedStateModel.of<T>(context, rebuildOnChange: rebuildOnChange);
  }
}

/// Provides a [StateModel] to all descendants of this Widget.
///
/// Descendant Widgets can access the model by using the
/// [ScopedStateModelDescendant] Widget, which rebuilds each time the model changes,
/// or directly via the [ScopedStateModel.of] static method.
///
/// To provide a StateModel to all screens, place the [ScopedStateModel] Widget above the
/// [WidgetsApp] or [MaterialApp] in the Widget tree.
///
/// ### Example
///
/// ```
/// ScopedStateModel<CounterStateModel>(
///   model: CounterStateModel(),
///   child: ScopedStateModelDescendant<CounterStateModel>(
///     builder: (context, child, model) => Text(model.counter.toString()),
///   ),
/// );
/// ```
class ScopedStateModel<T extends StateModel> extends StatelessWidget {
  /// The [StateModel] to provide to [child] and its descendants.
  final T model;

  /// The [Widget] the [model] will be available to.
  final Widget child;

  ScopedStateModel({@required this.model, @required this.child})
      : assert(model != null),
        assert(child != null);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: model,
      builder: (context, _) =>
          _InheritedStateModel<T>(model: model, child: child),
    );
  }

  /// Finds a [StateModel] provided by a [ScopedStateModel] Widget.
  ///
  /// Generally, you'll use a [ScopedStateModelDescendant] to access a model in the
  /// Widget tree and rebuild when the model changes. However, if you would to
  /// access the model directly, you can use this function instead!
  ///
  /// ### Example
  ///
  /// ```
  /// final model = ScopedStateModel.of<CounterStateModel>();
  /// ```
  ///
  /// If you find yourself accessing your StateModel multiple times in this way, you
  /// could also consider adding a convenience method to your own StateModels.
  ///
  /// ### StateModel Example
  ///
  /// ```
  /// class CounterStateModel extends StateModel {
  ///   static CounterStateModel of(BuildContext context) =>
  ///       ScopedStateModel.of<CounterStateModel>(context);
  /// }
  ///
  /// // Usage
  /// final model = CounterStateModel.of(context);
  /// ```
  ///
  /// ## Listening to multiple StateModels
  ///
  /// If you want a single Widget to rely on multiple models, you can use the
  /// `of` method! No need to manage subscriptions, Flutter takes care of all
  ///  of that through the magic of InheritedWidgets.
  ///
  /// ```
  /// class CombinedWidget extends StatelessWidget {
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     final username =
  ///       ScopedStateModel.of<UserStateModel>(context, rebuildOnChange: true).username;
  ///     final counter =
  ///       ScopedStateModel.of<CounterStateModel>(context, rebuildOnChange: true).counter;
  ///
  ///     return Text('$username tapped the button $counter times');
  ///   }
  /// }
  /// ```
  static T of<T extends StateModel>(
    BuildContext context, {
    bool rebuildOnChange = false,
  }) {
    final Type type = _type<_InheritedStateModel<T>>();

    Widget widget = rebuildOnChange
        ? context.dependOnInheritedWidgetOfExactType<_InheritedStateModel<T>>(
            aspect: type)
        : context
            .getElementForInheritedWidgetOfExactType<_InheritedStateModel<T>>()
            ?.widget;

    if (widget == null) {
      throw ScopedStateModelError();
    } else {
      return (widget as _InheritedStateModel<T>).model;
    }
  }

  static Type _type<T>() => T;
}

/// Provides [model] to its [child] [Widget] tree via [InheritedWidget].  When
/// [version] changes, all descendants who request (via
/// [BuildContext.dependOnInheritedWidgetOfExactType]) to be rebuilt when the model
/// changes will do so.
class _InheritedStateModel<T extends StateModel> extends InheritedWidget {
  final T model;
  final int version;

  _InheritedStateModel({Key key, Widget child, T model})
      : this.model = model,
        this.version = model._version,
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedStateModel<T> oldWidget) =>
      (oldWidget.version != version);
}

/// Builds a child for a [ScopedStateModelDescendant].
typedef Widget ScopedStateModelDescendantBuilder<T extends StateModel>(
  BuildContext context,
  Widget child,
  T model,
);

/// Finds a specific [StateModel] provided by a [ScopedStateModel] Widget and rebuilds
/// whenever the [StateModel] changes.
///
/// Provides an option to disable rebuilding when the [StateModel] changes.
///
/// Provide a constant [child] Widget if some portion inside the builder does
/// not rely on the [StateModel] and should not be rebuilt.
///
/// ### Example
///
/// ```
/// ScopedStateModel<CounterStateModel>(
///   model: CounterStateModel(),
///   child: ScopedStateModelDescendant<CounterStateModel>(
///     child: Text('Button has been pressed:'),
///     builder: (context, child, model) {
///       return Column(
///         children: [
///           child,
///           Text('${model.counter}'),
///         ],
///       );
///     }
///   ),
/// );
/// ```
class ScopedStateModelDescendant<T extends StateModel> extends StatelessWidget {
  /// Builds a Widget when the Widget is first created and whenever
  /// the [StateModel] changes if [rebuildOnChange] is set to `true`.
  final ScopedStateModelDescendantBuilder<T> builder;

  /// An optional constant child that does not depend on the model.  This will
  /// be passed as the child of [builder].
  final Widget child;

  /// An optional value that determines whether the Widget will rebuild when
  /// the model changes.
  final bool rebuildOnChange;

  /// Creates the ScopedStateModelDescendant
  ScopedStateModelDescendant({
    @required this.builder,
    this.child,
    this.rebuildOnChange = true,
  });

  @override
  Widget build(BuildContext context) {
    return builder(
      context,
      child,
      ScopedStateModel.of<T>(context, rebuildOnChange: rebuildOnChange),
    );
  }
}

/// The error that will be thrown if the ScopedStateModel cannot be found in the
/// Widget tree.
class ScopedStateModelError extends Error {
  ScopedStateModelError();

  String toString() {
    return '''Error: Could not find the correct ScopedStateModel.
    
To fix, please:
          
  * Provide types to ScopedStateModel<MyStateModel>
  * Provide types to ScopedStateModelDescendant<MyStateModel> 
  * Provide types to ScopedStateModel.of<MyStateModel>() 
  * Always use package imports. Ex: `import 'package:my_app/my_model.dart';
  
If none of these solutions work, please file a bug at:
https://github.com/brianegan/scoped_model/issues/new
      ''';
  }
}
