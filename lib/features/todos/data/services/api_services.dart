import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:todo_app/features/todos/data/models/todo_model.dart';

class ApiService {
  ApiService._();

  static const String _baseUrl = "http://10.0.2.2:8083/api/task";

  //To test on windows you can use = localhost
  //To test on emulator you can use = 10.0.2.2

  //Get all todos
  static Future<void> getAllTodos(List todoLists) async {
    Uri uri = Uri.parse('$_baseUrl/all_task');
    Response getResponse = await http.get(uri);

    if (getResponse.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(getResponse.body);

      for (var items in jsonResponse['data']) {
        TodoModel todoModel = TodoModel(
            id: items['id'],
            title: items['title'],
            description: items['description'],
            isCompleted: items['isCompleted']);
        todoLists.add(todoModel);
      }
    }

    print(getResponse);
    print(getResponse.body);
    print(getResponse.statusCode);
  }

  //Create todos
  static Future<bool> createTodo(TodoModel todo) async {
    Uri uri = Uri.parse('$_baseUrl/create');
    Response postResponse = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": todo.title,
        "description": todo.description,
        "isCompleted": todo.isCompleted,
      }),
    );

    if (postResponse.statusCode == 201 || postResponse.statusCode == 200) {
      print("Todo Created: ${postResponse.body}");
      return true; // Return true if creation is successful
    } else {
      print("Failed to create todo: ${postResponse.body}");
      return false; // Return false if creation fails
    }
  }

  //Update todos
  static Future<bool> updateTodo(TodoModel todo) async {
    Uri uri = Uri.parse('$_baseUrl/update/${todo.id}');
    Response putResponse = await http.put(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": todo.title,
        "description": todo.description,
        "isCompleted": todo.isCompleted,
      }),
    );

    if (putResponse.statusCode == 200) {
      print("Todo Updated: ${putResponse.body}");
      return true; // Return true if update is successful
    } else {
      print("Failed to update todo: ${putResponse.body}");
      return false; // Return false if update fails
    }
  }

  //Delete
  static Future<bool> deleteTodo(int id) async {
    Uri uri = Uri.parse('$_baseUrl/delete/$id');
    Response deleteResponse = await http.delete(uri);

    if (deleteResponse.statusCode == 200) {
      print("Todo Deleted: ${deleteResponse.body}");
      return true; // Return true if deletion is successful
    } else {
      print("Failed to delete todo: ${deleteResponse.body}");
      return false; // Return false if deletion fails
    }
  }

}
