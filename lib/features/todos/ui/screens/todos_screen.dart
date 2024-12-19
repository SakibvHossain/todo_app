import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:todo_app/features/todos/data/services/api_services.dart';
import 'package:todo_app/features/todos/ui/widgets/customize_text.dart';

import '../../data/models/todo_model.dart';
import 'add_update_screen.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({super.key, required this.todos});

  final List<TodoModel> todos;

  @override
  State<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  Future<void> delete(int id, int index) async {
    // Call delete function from the API service
    bool success = await ApiService.deleteTodo(id);
    if (success) {
      // Only remove the item from the list after successful deletion
      setState(() {
        widget.todos.removeAt(index);
      });
      // Optionally show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todo deleted successfully')),
      );
    } else {
      // Show an error message if deletion fails
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete todo')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.todos.length,
      separatorBuilder: (context, i) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final todo = widget.todos[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Card(
            elevation: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomizeText(
                    text: todo.title!,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  CustomizeText(
                    text: todo.description!,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                          color: todo.isCompleted! ? Colors.green : Colors.orange,
                        ),
                        child: Text(
                           todo.isCompleted! ? "Completed" : "Pending",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Navigate to AddUpdateScreen with the selected todo for editing
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddUpdateScreen(todoModel: todo, isEdit: true), // Pass the selected todo
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                              size: 24.0,
                            ),
                          ),

                          const SizedBox(width: 4.0,),
                          GestureDetector(
                            onTap: () {
                              delete(todo.id!, index);
                            },
                            child: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 24.0,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

