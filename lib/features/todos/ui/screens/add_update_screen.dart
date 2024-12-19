import 'package:flutter/material.dart';
import 'package:todo_app/features/todos/data/controller/update_controller.dart';
import 'package:todo_app/features/todos/data/models/todo_model.dart';

import '../../data/services/api_services.dart';
import '../widgets/customize_text.dart';

class AddUpdateScreen extends StatefulWidget {
  const AddUpdateScreen({super.key, required this.todoModel, required this.isEdit});

  final TodoModel todoModel;
  final bool isEdit;

  @override
  State<AddUpdateScreen> createState() => _AddUpdateScreenState();
}

class _AddUpdateScreenState extends State<AddUpdateScreen> {
  final TextEditingController titleTextController = TextEditingController();
  final TextEditingController descriptionTextController = TextEditingController();
  bool isCompleted = false;
  UpdateController updateController = UpdateController();


  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      // Initialize controllers with the passed todo data when editing
      titleTextController.text = widget.todoModel.title!;
      descriptionTextController.text = widget.todoModel.description!;
      isCompleted = widget.todoModel.isCompleted!;
    } else {
      // Initialize controllers as empty when adding a new todo
      titleTextController.text = '';
      descriptionTextController.text = '';
      isCompleted = false;
    }
  }


  void create() async{
    if (titleTextController.text.isNotEmpty && descriptionTextController.text.isNotEmpty) {
      TodoModel newTodo = TodoModel(
        title: titleTextController.text,
        description: descriptionTextController.text,
        isCompleted: isCompleted,
      );

      // Call API to create new todo
      await updateController.createTodo(newTodo, context);
      // You can navigate back or show a success message after creating the todo
      Navigator.pop(context);
    } else {
      // Handle case where the fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields')),
      );
    }
  }


  @override
  void dispose() {
    titleTextController.dispose();
    descriptionTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the back button color to white
        ),
        title: CustomizeText(
          text: widget.isEdit ? "Update Todo" : "Add Todo",
          fontSize: 28,
          fontWeight: FontWeight.bold,
          colors: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Column(
          children: [
            TextFormField(
              maxLength: 25,
              controller: titleTextController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey), // Change this to your desired color
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0), // Color when the field is focused
                  ),
                labelText: "Title"
              ),
            ),
            const SizedBox(height: 15,),
            TextFormField(
              controller: descriptionTextController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey), // Change this to your desired color
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0), // Color when the field is focused
                  ),
                labelText: "Description"
              ),
            ),
            const SizedBox(height: 20.0),
            Text("Is Completed",textAlign: TextAlign.start,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Replace Text widget with Switch widget
                Switch(
                  value: isCompleted, // Initial value (toggle on/off)
                  onChanged: (bool value) {
                    // Handle switch state change
                    setState(() {
                      isCompleted = value;
                    });
                  },
                  activeColor: Colors.green, // Active switch color
                  inactiveThumbColor: Colors.grey, // Inactive switch color
                ),
                // Adjust ElevatedButton size
                ElevatedButton(
                  onPressed: () async {
                    if(widget.isEdit){
                      updateController.update(id: widget.todoModel.id!, text: titleTextController.text, description: descriptionTextController.text, inCompleted: isCompleted, context: context);
                    }else{
                      create();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(40, 40), // Set width and height of the button
                    padding: EdgeInsets.zero, // Remove default padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Rounded corners
                    ),
                  ),
                  child: const Icon(Icons.done, size: 20), // Adjust icon size
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
