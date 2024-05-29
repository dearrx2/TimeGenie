import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:untitled/utils/color_utils.dart';
import '../../../components/TextFormField.dart';
import '../../../components/long_button.dart';
import '../../utils/localizations.dart';
import '../../utils/style.dart';
import '../long_button_disable.dart';
import '../request/date_picker_field.dart';
import '../date_picker.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({Key? key}) : super(key: key);

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _noteTextController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isButtonEnabled = false; // Initialize as false

  @override
  void initState() {
    super.initState();
    // Add listeners to the text controllers
    _titleTextController.addListener(_updateButtonState);
    _noteTextController.addListener(_updateButtonState);
    _dueDateController.addListener(_updateButtonState);
  }

  String? _validateTitleField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a title';
    }
    if (value.length > 100) {
      return 'Title cannot exceed 100 characters';
    }
    return null;
  }

  String? _validateNoteField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a note';
    }
    if (value.length > 256) {
      return 'Note cannot exceed 256 characters';
    }
    return null;
  }

  String? _validateDueDateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a due date';
    }
    return null;
  }

  void _updateButtonState() {
    // Update the button state based on the text fields' values
    setState(() {
      _isButtonEnabled = (_titleTextController.text.isNotEmpty &&
          _noteTextController.text.isNotEmpty &&
          _dueDateController.text.isNotEmpty);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          MyLocalizations.translate("appbar_NewTask"),
          style: tabBarText.copyWith(
            color: black,
          ),
        ),
        backgroundColor: cream,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView( // Wrap with SingleChildScrollView
        child: Container(
          decoration: const BoxDecoration(
            color: cream,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                child: Container(
                  color: white,
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SetTextFormField(
                          title: MyLocalizations.translate("text_Title"),
                          hint: MyLocalizations.translate("hint_Title"),
                          controller: _titleTextController,
                          validate: _validateTitleField,
                        ),
                        SetTextFormField(
                          title: MyLocalizations.translate("text_Note"),
                          hint: MyLocalizations.translate("hint_Note"),
                          controller: _noteTextController,
                          validate: _validateNoteField,
                        ),
                        GestureDetector(
                          onTap: () async {
                            DateTime? selectedDate = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return DatePicker(
                                  initialDate: DateTime.now(),
                                );
                              },
                            );
                            if (selectedDate != null) {
                              setState(() {
                                String formattedDate = DateFormat('dd/MM/yyyy')
                                    .format(selectedDate);
                                _dueDateController.text = formattedDate;
                              });
                            }
                          },
                          child: AbsorbPointer(
                            child: SelectDateFormField(
                              controller: _dueDateController,
                              title: MyLocalizations.translate("text_DueDate"),
                              hint: MyLocalizations.translate("hint_SelectDueDate"),
                              validate: _validateDueDateField,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding( // Use bottomNavigationBar for the button
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
        child: _isButtonEnabled
            ? LongButton(
          title: MyLocalizations.translate("button_Add"),
          ontap: () {
            if (_formKey.currentState!.validate()) {
              _addNewTask();
            }
          },
        )
            : LongButtonDisable(
          title: MyLocalizations.translate("button_Add"),
          textColor: Colors.white,
          disabledColor: Color(0xFFD8D8D8),
        ),
      ),
    );
  }

  Future<void> _addNewTask() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentReference newTaskRef =
            await FirebaseFirestore.instance.collection('tasks').doc();
        String taskId = newTaskRef.id; // Get the generated taskID
        await newTaskRef.set({
          'userID': user.uid,
          'taskID': taskId, // Store the taskID in the database
          'title': _titleTextController.text,
          'note': _noteTextController.text,
          'dueDate': DateFormat('dd/MM/yyyy').parse(_dueDateController.text),
          'createDate': FieldValue.serverTimestamp(),
          'checked': false,
          'checkedDate': null,
        });
      } else {
        // User is not signed in, handle accordingly (e.g., show a login screen)
        return;
      }
      _clearTextFields();
      Navigator.of(context).pop();
    } catch (e) {
      // Handle any errors that occur during task creation
      if (kDebugMode) {
        print("Error adding new task: $e");
      }
    }
  }

  void _clearTextFields() {
    _titleTextController.clear();
    _noteTextController.clear();
    _dueDateController.clear();
  }
}
