import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../utils/color_utils.dart';
import '../../utils/localizations.dart';
import '../../utils/style.dart';
import '../TextFormField.dart';
import '../date_picker.dart';
import '../long_button.dart';
import '../long_button_disable.dart';
import '../request/date_picker_field.dart';

class EditTask extends StatefulWidget {
  final String taskId;
  final String initialTitle;
  final String initialNote;
  final DateTime initialDueDate;
  final DateTime initialCreateDate;
  final bool initialChecked;

  const EditTask({
    required this.taskId,
    required this.initialTitle,
    required this.initialNote,
    required this.initialDueDate,
    required this.initialCreateDate,
    required this.initialChecked,
  });

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  late TextEditingController _titleTextController;
  late TextEditingController _noteTextController;
  late TextEditingController _dueDateController;
  late bool _checked;

  bool _isButtonEnabled = false; // Initialize as false

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
    if (value.length > 400) {
      return 'Note cannot exceed 400 characters';
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
  void initState() {
    super.initState();
    _titleTextController = TextEditingController(text: widget.initialTitle);
    _noteTextController = TextEditingController(text: widget.initialNote);
    _dueDateController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(widget.initialDueDate),
    );
    _checked = widget.initialChecked;

    _titleTextController.addListener(_updateButtonState);
    _noteTextController.addListener(_updateButtonState);
    _dueDateController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _noteTextController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          MyLocalizations.translate("appbar_Task"),
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
                            DateTime? selectedDate = await await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return DatePicker(
                                  // Use the custom date picker widget
                                  initialDate: DateTime.now(),
                                );
                              },
                            );
                            if (selectedDate != null) {
                              setState(() {
                                String formattedDate =
                                DateFormat('dd/MM/yyyy').format(selectedDate);
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
          title: MyLocalizations.translate("button_Done"),
          ontap: () {
            _updateTask();
          },
        )
            : LongButtonDisable(
          title: MyLocalizations.translate("button_Done"),
          textColor: Colors.white,
          disabledColor: Color(0xFFD8D8D8),
        ),
      ),
    );
  }


  Future<void> _updateTask() async {
    try {
      // Fetch the current user
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Update the task document in Firestore
        await FirebaseFirestore.instance
            .collection('tasks')
            .doc(widget.taskId)
            .update({
          'title': _titleTextController.text,
          'note': _noteTextController.text,
          'dueDate': DateFormat('dd/MM/yyyy').parse(_dueDateController.text),
          'checked': _checked,
        });
      }
      // Close the dialog after updating the task
      if (mounted) {
        Navigator.of(context).pop(); // Close EditTask screen
        Navigator.of(context).pop(); // Close TodoCard screen and return to previous screen
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
  }
}
