import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled/utils/color_utils.dart';
import '../../responsive/app/approval/approval_screen_mobile.dart';
import '../../utils/localizations.dart';
import '../../utils/style.dart';
import '../dialog/dialog.dart';
import '../long_button.dart';
import '../no_data.dart';
import 'todo_checkbox.dart';
import '../../../components/todo/todo_edittask.dart';

class TodoCard extends StatelessWidget {
  final String taskId;
  final String title;
  final String note;
  final String dueDate;
  final String createDate;
  final bool checked;
  final Function(bool) onCheckboxChanged;
  final Function? onCardTap;


  const TodoCard({
    Key? key,
    required this.taskId,
    required this.title,
    required this.note,
    required this.dueDate,
    required this.createDate,
    required this.checked,
    required this.onCheckboxChanged,
    this.onCardTap,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final bool isDueDatePassed = DateTime.parse(dueDate)
        .isBefore(DateTime.now().subtract(const Duration(days: 1)));
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 4.0),
      child: Material(
        color: Colors.white, // Replace 'white' with your desired color
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: titleText,
                          ),
                          Text(
                            '${MyLocalizations.translate("text_DueDate")}: ${dateFormat.format(DateTime.parse(dueDate))}',
                            style: dueDateText.copyWith(
                              color: checked
                                  ? orange
                                  : isDueDatePassed
                                  ? red
                                  : orange,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            note,
                            style: noteText,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(height: 8.0),
                        TodoCheckbox(
                          key: Key(taskId), // Pass a unique key based on the taskId
                          isChecked: checked,
                          onToggle: onCheckboxChanged,
                        ),
                      ],
                    ),
                  ],
                ),
                if (!checked) // Show edit and delete icons only if not checked
                  Positioned(
                    bottom: -20,
                    right: -12,
                    child: IconButton(
                      icon: const Icon(
                        Icons.keyboard_control_rounded,
                        color: grey,
                      ),
                      onPressed: () {
                        _showEditOptions(context);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(32.0),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.only(top: 17.0, bottom: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 27.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Center(
                        child: Text(
                          MyLocalizations.translate("appbar_Task"),
                          style: text.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 8.0,
                        child: IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            color: black,
                            size: 24,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                LongButton(
                  title: MyLocalizations.translate("button_Edit"),
                  ontap: () {
                    _openEditTask(context);
                  },
                ),
                const SizedBox(height: 16.0),
                LongButton(
                  title: MyLocalizations.translate("button_Delete"),
                  ontap: () {
                    _showDeleteTaskAlert(context, title);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteTaskAlert(BuildContext context, String taskTitle) {
    String deleteConfirmationMessage = MyLocalizations.translate("text_DeleteTheTask");
    String messageWithTaskTitle = deleteConfirmationMessage.replaceAll("\$taskTitle", taskTitle);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDialog(
          type: 'delete',
          message: messageWithTaskTitle,
          onConfirm: () {
            _deleteTask();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }


  void _deleteTask() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await FirebaseFirestore.instance
            .collection('tasks')
            .doc(taskId)
            .delete();
      }
      // Navigator.of(context).pop();
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
  }

  void _openEditTask(BuildContext context) {
    if (!checked) {
      // Only open dialog if task is not checked
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return EditTask(
            taskId: taskId,
            initialTitle: title,
            initialNote: note,
            initialDueDate: DateTime.parse(dueDate),
            initialCreateDate: DateTime.parse(createDate),
            initialChecked: checked,
          );
        },
      );
    }
  }

  static Widget buildTaskListStream(String userID, bool showCompleted) {
    final DateTime sevenDaysAgo = DateTime.now().subtract(Duration(days: 7));

    return showCompleted

        /// Completed
        ? StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('tasks')
                .where('userID', isEqualTo: userID)
                .where('checkedDate', isGreaterThanOrEqualTo: sevenDaysAgo)
                .orderBy('checkedDate', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(MyLocalizations.translate("text_Errorfetchingtasks")),
                );
              }
              if (!snapshot.hasData) {
                return const LoadingAnimation();
              }
              final tasks = snapshot.data!.docs;

              // Group tasks by checkedDate
              Map<String, List<DocumentSnapshot>> groupedTasks = {};
              for (var taskDocument in tasks) {
                final taskData = taskDocument.data() as Map<String, dynamic>;
                final checkedDate = taskData['checkedDate']
                        ?.toDate()
                        ?.toString()
                        .split(' ')[0] ??
                    '';
                if (checkedDate.isNotEmpty) {
                  // Check if checkedDate is not empty
                  if (!groupedTasks.containsKey(checkedDate)) {
                    groupedTasks[checkedDate] = [];
                  }
                  groupedTasks[checkedDate]!.add(taskDocument);
                }
              }

              if (groupedTasks.isEmpty) {
                return Center(
                  child: noData(text: (MyLocalizations.translate("text_NoCompletedtasks")),
                  )
                );
              }

              return ListView.builder(
                itemCount: groupedTasks.length,
                itemBuilder: (context, index) {
                  final sortedKeys = groupedTasks.keys.toList()
                    ..sort((a, b) => DateTime.parse(b).compareTo(DateTime.parse(a)));
                  final checkedDate = sortedKeys[index];
                  final sectionTasks = groupedTasks[checkedDate]!
                    ..sort((a, b) =>
                        DateTime.parse(b['checkedDate'].toDate().toString())
                            .compareTo(DateTime.parse(a['checkedDate'].toDate().toString())));
                  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 12.0, 0.0, 4.0),
                        child: Text(
                          "${MyLocalizations.translate("text_CompletedDate")}: ${dateFormat.format(DateTime.parse(checkedDate))}",
                          // Display the checkedDate as the section header
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: sectionTasks.length,
                        itemBuilder: (context, subIndex) {
                          final taskDocument = sectionTasks[subIndex];
                          final taskData =
                              taskDocument.data() as Map<String, dynamic>;
                          final bool checked = taskData['checked'] ?? false;
                          return checked
                              ? TodoCard(
                                  title: taskData['title'],
                                  note: taskData['note'],
                                  dueDate: taskData['dueDate']
                                          ?.toDate()
                                          ?.toString()
                                          .split(' ')[0] ??
                                      '',
                                  createDate: taskData['createDate']
                                          ?.toDate()
                                          ?.toString()
                                          .split(' ')[0] ??
                                      '',
                                  checked: taskData['checked'] ?? false,
                                  onCheckboxChanged: (newStatus) async {
                                    _updateTaskStatus(taskDocument, newStatus);
                                  },
                                  taskId: taskData['taskID'],
                                  onCardTap: null,
                                )
                              : Container();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          )

        ///Tasks
        : StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('tasks')
                .where('userID', isEqualTo: userID)
                .orderBy('dueDate', descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: noData(text: (MyLocalizations.translate("text_Errorfetchingtasks"))),
                );
              }
              if (!snapshot.hasData) {
                return const LoadingAnimation();
              }
              final tasks = snapshot.data!.docs;

              final upcomingTasks = tasks.where((taskDocument) {
                final taskData = taskDocument.data();
                return !(taskData['checked'] ?? true);
              }).toList();

              if (upcomingTasks.isEmpty) {
                return Center(
                  child: noData(text: (MyLocalizations.translate("text_NoUpcomingtasks"))),
                );
              }

              return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final taskDocument = tasks[index];
                  final taskData = taskDocument.data();
                  final check = taskData['checked'];
                  return check
                      ? Container()
                      : TodoCard(
                          title: taskData['title'],
                          note: taskData['note'],
                          dueDate: taskData['dueDate']
                                  ?.toDate()
                                  ?.toString()
                                  .split(' ')[0] ??
                              '',
                          createDate: taskData['createDate']
                                  ?.toDate()
                                  ?.toString()
                                  .split(' ')[0] ??
                              '',
                          checked: taskData['checked'] ?? true,
                          onCheckboxChanged: (newStatus) async {
                            _updateTaskStatus(taskDocument, newStatus);
                          },
                          taskId: taskData['taskID'],
                          onCardTap: null,
                        );
                },
              );
            });
  }

  static void _updateTaskStatus(DocumentSnapshot taskDocument, bool newStatus) {
    taskDocument.reference.update({'checked': newStatus});
    if (newStatus) {
      taskDocument.reference.update({'checkedDate': DateTime.now()});
    } else {
      taskDocument.reference.update({'checkedDate': null});
    }
  }
}
