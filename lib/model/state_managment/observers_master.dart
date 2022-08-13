//Will change it as per the commands

import 'package:flutter/material.dart';

enum ObserverState {
  init,
  listChanged,
}

abstract class StateListener {
  void onStateChanged(ObserverState state, var stateValue);
}

//Singleton reusable class
class StateProvider {
  late List<StateListener> observers = [];

  static final StateProvider _instance = StateProvider.internal();
  factory StateProvider() => _instance;

  StateProvider.internal() {
    initState();
  }

  void initState() async {
    notify(ObserverState.init, null);
  }

  void subscribe(StateListener listener) {
    observers.add(listener);
  }

  void notify(dynamic state, dynamic value) {
    for (var obj in observers) {
      obj.onStateChanged(state, value);
    }
  }

  void dispose(StateListener thisObserver) {
    try {
      for (var obj in observers) {
        if (obj == thisObserver) {
          observers.remove(obj);
        }
      }
    } catch (e) {
      debugPrint(
          "\n=================\n StateListener $e \n=================\n");
    }
  }

  void clear() {
    observers.clear();
  }
}
