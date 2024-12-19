import '../models/todo_model.dart';
import 'package:flutter/material.dart';

import '../services/api_services.dart';

class UpdateController {
  Future<void> update({required int id, required String text, required String description, required bool inCompleted, required BuildContext context}) async {
    // Create updated TodoModel
    TodoModel updatedTodo = TodoModel(
      id: id, // Keep the same ID
      title: text,
      description: description,
      isCompleted: inCompleted,
    );

    // Call updateTodo to update the todo in the backend
    bool success = await ApiService.updateTodo(updatedTodo);

    if (success) {
      // Go back to the previous screen on success
      Navigator.pop(context);
    } else {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update todo')),
      );
    }
  }

  Future<void> createTodo(TodoModel todo, BuildContext context) async {
    try {
      // API call to create a new todo (replace with actual service code)
      final response = await ApiService.createTodo(todo);
      if (response) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Todo created successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to create todo")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create todo')),
      );
    }
  }
}
