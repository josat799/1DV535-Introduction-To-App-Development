import 'dart:collection';
import 'dart:math' as math;

import 'package:assignment_2/models/todos.dart';
import 'package:assignment_2/placerholder_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/todo.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => Todos(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

enum FilterStates {
  unfinished,
  finished;
}

class _HomeState extends State<Home> {
  FilterStates filter = FilterStates.unfinished;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late UnmodifiableListView<Todo> filteredTodos;
  late int amountOfTodos;
  bool placeHolderDataLoaded = false;
  bool showHelp = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: !showHelp
            ? [
                DropdownButton<FilterStates>(
                    items: FilterStates.values
                        .map<DropdownMenuItem<FilterStates>>(
                          (state) => DropdownMenuItem<FilterStates>(
                            enabled: state != filter,
                            value: state,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(state.name.toUpperCase()),
                                state == filter
                                    ? Icon(
                                        Icons.done,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          filter = value;
                        });
                      }
                    },
                    icon: const Icon(Icons.filter_1)),
                TextButton.icon(
                    onLongPress: () => {
                          if (!placeHolderDataLoaded)
                            Provider.of<Todos>(context, listen: false)
                                .addMany(PlaceHolderData().placeHolderTodos),
                          placeHolderDataLoaded = true
                        },
                    onPressed: () => {
                          setState(() {
                            showHelp = true;
                          })
                        },
                    icon: const Icon(Icons.question_mark),
                    label: const SizedBox())
              ]
            : [],
        title: showHelp
            ? const Text("How to Todo!")
            : filter == FilterStates.unfinished
                ? Text(
                    "Todos ${Provider.of<Todos>(context, listen: true).amountOfUnfinishedTodos}")
                : Text(
                    "Finished Todos ${Provider.of<Todos>(context, listen: true).amountOfFinishedTodos}"),
      ),
      body: showHelp
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Icon(Icons.swipe_left),
                  const Text("To finish a Todo you must swipe left!"),
                  const Icon(Icons.swipe_right),
                  const Text("To remove a Todo you must swipe right!"),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showHelp = false;
                        });
                      },
                      child: const Text("Go Back"))
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: Consumer<Todos>(
                    builder: (_, todos, __) {
                      if (filter == FilterStates.unfinished) {
                        filteredTodos = todos.unfinishedTodos;
                        amountOfTodos = todos.amountOfUnfinishedTodos;
                      } else {
                        filteredTodos = todos.finishedTodos;
                        amountOfTodos = todos.amountOfFinishedTodos;
                      }

                      if (filteredTodos.isEmpty &&
                          filter == FilterStates.unfinished) {
                        return SizedBox(
                          width: 300,
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Align(
                                alignment: AlignmentDirectional.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.all(32.0),
                                  // The image need to be rotated 90 degrees
                                  child: Transform.rotate(
                                    angle: math.pi / 2,
                                    child: const Image(
                                      width: 200,
                                      image:
                                          AssetImage('assets/curly_arrow.png'),
                                    ),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 32.0),
                                child: Align(
                                  alignment: AlignmentDirectional.bottomEnd,
                                  child: Text("A new Todo you might add?"),
                                ),
                              )
                            ],
                          ),
                        );
                      } else {
                        return DismissibleTodoListWdget(
                          amountOfTodos: amountOfTodos,
                          filteredTodos: filteredTodos,
                          executeFallbackFunction:
                              filter == FilterStates.finished
                                  ? null
                                  : todos.executeTodo,
                          removeFallbackFunction:
                              filter == FilterStates.finished
                                  ? null
                                  : todos.removeTodo,
                        );
                      }
                    },
                  ),
                ),
                if (filter == FilterStates.unfinished)
                  NewTodoWidget(formKey: _formKey),
              ],
            ),
    );
  }
}

class DismissibleTodoListWdget extends StatelessWidget {
  const DismissibleTodoListWdget({
    super.key,
    required this.amountOfTodos,
    required this.filteredTodos,
    required this.executeFallbackFunction,
    required this.removeFallbackFunction,
  });

  final int amountOfTodos;
  final UnmodifiableListView<Todo> filteredTodos;
  final Function? executeFallbackFunction;
  final Function? removeFallbackFunction;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (context, index) => const Divider(),
      itemCount: amountOfTodos,
      itemBuilder: (context, index) => Dismissible(
        key: Key(filteredTodos[index].id.toString()),
        direction:
            executeFallbackFunction != null && removeFallbackFunction != null
                ? DismissDirection.horizontal
                : DismissDirection.none,
        background: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 8.0),
          decoration: const BoxDecoration(
            color: Colors.red,
          ),
          child: const Icon(Icons.delete_forever_outlined),
        ),
        secondaryBackground: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 8),
          decoration: const BoxDecoration(
            color: Colors.green,
          ),
          child: const Icon(Icons.done_all),
        ),
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            executeFallbackFunction!(filteredTodos[index].id);
          } else {
            removeFallbackFunction!(filteredTodos[index].id);
          }
        },
        child: ListTile(
          title: Center(child: Text(filteredTodos[index].title)),
        ),
      ),
    );
  }
}

class NewTodoWidget extends StatelessWidget {
  NewTodoWidget({
    super.key,
    required GlobalKey<FormState> formKey,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      shadowColor: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextFormField(
                validator: (value) =>
                    value != '' ? null : "A Todo title you must have!",
                controller: _titleController
                  ..text = Provider.of<Todos>(context, listen: true)
                          .retriveDeletedTodo
                          ?.title ??
                      '',
                autocorrect: true,
                decoration: InputDecoration(
                    labelText: "Title",
                    hintText: "My Awesome Todo",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8))),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Provider.of<Todos>(context, listen: false)
                        .addTodo(_titleController.text);

                    _formKey.currentState!.reset();
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text("Add a new Todo"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
