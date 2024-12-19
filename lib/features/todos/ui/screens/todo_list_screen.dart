import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:todo_app/features/todos/data/models/todo_model.dart';
import 'package:todo_app/features/todos/data/services/api_services.dart';
import 'package:todo_app/features/todos/ui/screens/add_update_screen.dart';
import 'package:todo_app/features/todos/ui/screens/todos_screen.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<TodoModel> todoCompleteList = [];
  List<TodoModel> todoInCompleteList = [];
  List<TodoModel> allTodos = [];

  bool inProgress = false;

  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    setState(() {
      inProgress = true;
      // Clear the lists to prevent duplication
      allTodos.clear();
      todoCompleteList.clear();
      todoInCompleteList.clear();
    });

    // Fetch new data
    await ApiService.getAllTodos(allTodos);

    setState(() {
      // Update the lists based on the fetched data
      todoCompleteList = allTodos.where((todo) => todo.isCompleted!).toList();
      todoInCompleteList = allTodos.where((todo) => !todo.isCompleted!).toList();
      inProgress = false;
    });

    print("Print all todos: $allTodos");
  }

  Future<void> _refreshTodos() async {
    await Future.delayed(const Duration(seconds: 2));
    await fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: const Text(
            "Todo Lists", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
           centerTitle: true,
          bottom: TabBar(
            tabs: [
              Text(
                "Todos (${allTodos.length})",
                style: const TextStyle(fontSize: 14),
              ),
              Text("Pending (${todoInCompleteList.length})",
                  style: const TextStyle(fontSize: 14)),
              Text("Completed (${todoCompleteList.length})",
                  style: const TextStyle(fontSize: 14)),
            ],
            labelPadding: const EdgeInsets.symmetric(vertical: 10),
            labelStyle: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
            unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 20,
                color: Colors.black38),
          ),
        ),


        body: TabBarView(
          children: _buildTodoLabs(),
        ),


        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddUpdateScreen(todoModel: TodoModel(
                        id: 1,
                        title: 'title',
                        description: 'description',
                        isCompleted: false), isEdit: false)));
          },
          child: const Icon(
            Icons.add,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }

  Widget _buildTodoLab(List<TodoModel> todos){
    return inProgress
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
      onRefresh: _refreshTodos,
      child: TodosScreen(todos: todos),
    );
  }

  List<Widget> _buildTodoLabs(){
    return [
      _buildTodoLab(allTodos),
      _buildTodoLab(todoInCompleteList),
      _buildTodoLab(todoCompleteList)
    ];
  }
}
