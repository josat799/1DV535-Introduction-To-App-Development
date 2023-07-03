import 'dart:collection';

import 'package:assignment_2/models/todo.dart';
import 'package:flutter/widgets.dart';

class Todos extends ChangeNotifier {
  final List<Todo> _todos = [];
  Todo? retriveDeletedTodo;

  UnmodifiableListView<Todo> get todos => UnmodifiableListView(_todos);

  UnmodifiableListView<Todo> get unfinishedTodos =>
      UnmodifiableListView(_todos.where((todo) => !todo.finished).toList());

  int get amountOfUnfinishedTodos => unfinishedTodos.length;
  int get amountOfFinishedTodos => finishedTodos.length;

  UnmodifiableListView<Todo> get finishedTodos =>
      UnmodifiableListView(_todos.where((todo) => todo.finished).toList());

  void addTodo(String title) {
    Todo _newTodo = Todo(id: _todos.length + 1, title: title);
    _todos.add(_newTodo);
    retriveDeletedTodo = null;
    notifyListeners();
  }

  void addMany(List<Todo> todos) {
    _todos.addAll(todos);
    notifyListeners();
  }

  void removeTodo(int id) {
    retriveDeletedTodo = _todos.firstWhere((todo) => todo.id == id);
    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
  }

  void executeTodo(int id) {
    retriveDeletedTodo = _todos.firstWhere((todo) => todo.id == id);
    _todos.firstWhere((todo) => todo.id == id).finishTodo();
    notifyListeners();
  }
}
