import 'package:flutter/material.dart';

class BaseViewModel<T> extends ChangeNotifier {
  bool _disposed = false;
  T? _state;

  bool get disposed => _disposed;

  T? get state => _state;

  void initialize(T state) {
    _state = state;
  }

  void setState(
    T state, {
    String? description,
  }) {
    _state = state;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}
