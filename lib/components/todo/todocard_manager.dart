import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled/components/no_data.dart';
import 'package:untitled/utils/color_utils.dart';

import '../../responsive/app/approval/approval_screen_mobile.dart';
import '../../utils/localizations.dart';
import '../../utils/style.dart';

class TodoCardManager extends StatelessWidget {
  final String taskId;
  final String name;
  final String image;
  final String title;
  final String note;
  final String dueDate;
  final String createDate;
  final bool checked;
  final Function(bool) onCheckboxChanged;
  final Function? onCardTap;

  const TodoCardManager({
    Key? key,
    required this.taskId,
    required this.name,
    required this.image,
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

    final imageProvider = image.startsWith('http')
        ? NetworkImage(image)
        : Image.network(
            'https://firebasestorage.googleapis.com/v0/b/checkin-app-31ea8.appspot.com/o/gs://checkin-app-31ea8.appspot.com/profile.png?alt=media&token=access-token',
          ).image;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 4.0),
      child: Material(
        color: Colors.white, // Replace 'white' with your desired color
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            // onTap: () {
            //   _openEditTask(context);
            // },
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: imageProvider,
                      radius: 20.0,
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            title,
                            style: titleText.copyWith(
                              color: primaryTextColor,
                            ),
                          ),
                          Text(
                            'Due Date: ${dateFormat.format(DateTime.parse(dueDate))}',
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
                            style: noteText.copyWith(
                              color: primaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget buildTaskListStream(String userID, bool showCompleted) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tasks')
          .orderBy('dueDate', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingAnimation();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        // Get a list of task documents from the 'tasks' collection
        final taskDocs = snapshot.data!.docs;

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (userSnapshot.hasError) {
              return Text('Error: ${userSnapshot.error}');
            }
            final userDocs = userSnapshot.data!.docs;

            // Group tasks by checkedDate
            Map<String, List<DocumentSnapshot>> groupedTasks = {};

            for (var taskDocument in taskDocs) {
              final taskData = taskDocument.data() as Map<String, dynamic>;
              final checkedDate =
                  taskData['checkedDate']?.toDate()?.toString().split(' ')[0] ?? '';
              if (checkedDate.isNotEmpty) {
                // Check if checkedDate is not empty
                if (!groupedTasks.containsKey(checkedDate)) {
                  groupedTasks[checkedDate] = [];
                }
                groupedTasks[checkedDate]!.add(taskDocument);
              }
            }

            // Check if there are no completed tasks
            if (showCompleted && groupedTasks.isEmpty) {
              return Center(
                child: noData(text: MyLocalizations.translate("text_NoCompletedtasks")),
              );
            }

            // Filter upcoming tasks
            final upcomingTasks = taskDocs.where((taskDocument) {
              final taskData = taskDocument.data() as Map<String, dynamic>;
              return !(taskData['checked'] ?? true);
            }).toList();

            // Check if there are no upcoming tasks
            if (!showCompleted && upcomingTasks.isEmpty) {
              return Center(
                child: noData(text: MyLocalizations.translate("text_NoUpcomingtasks")),
              );
            }

            return showCompleted

                ///Completed
                ? ListView.builder(
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
                            padding:
                                const EdgeInsets.fromLTRB(16.0, 12.0, 0.0, 4.0),
                            child: Text(
                              "Completed Date: ${dateFormat.format(DateTime.parse(checkedDate))}",
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
                              final taskDocument = sectionTasks[subIndex].data()
                                  as Map<String, dynamic>;
                              final taskUserID = taskDocument['userID'];
                              final bool checked =
                                  taskDocument['checked'] ?? false;
                              // Create a map of user IDs to user data from the 'users' collection
                              final usersMap = Map.fromEntries(userDocs.map(
                                  (userDoc) =>
                                      MapEntry(userDoc.id, userDoc.data())));
                              final userData =
                                  usersMap[taskUserID] as Map<String, dynamic>;
                              return checked
                                  ? TodoCardManager(
                                      name: userData['name'],
                                      image: userData['image'],
                                      title: taskDocument['title'],
                                      note: taskDocument['note'],
                                      dueDate: taskDocument['dueDate']
                                          .toDate()
                                          .toString()
                                          .split(' ')[0],
                                      createDate: taskDocument['createDate']
                                          .toDate()
                                          .toString()
                                          .split(' ')[0],
                                      checked: taskDocument['checked'] ?? true,
                                      onCheckboxChanged: (newStatus) async {},
                                      taskId: taskDocument['taskID'],
                                      onCardTap: null,
                                    )
                                  : Container();
                            },
                          ),
                        ],
                      );
                    })

                ///Tasks
                : ListView.builder(
                    itemCount: taskDocs.length,
                    itemBuilder: (context, index) {
                      final taskDocument =
                          taskDocs[index].data() as Map<String, dynamic>;
                      final taskUserID = taskDocument['userID'];
                      final bool checked = taskDocument['checked'];
                      // Create a map of user IDs to user data from the 'users' collection
                      final userDocs = userSnapshot.data!.docs;
                      final usersMap = Map.fromEntries(userDocs.map(
                          (userDoc) => MapEntry(userDoc.id, userDoc.data())));
                      final userData =
                          usersMap[taskUserID] as Map<String, dynamic>;
                      return checked
                          ? Container()
                          : TodoCardManager(
                              name: userData['name'],
                              image: userData['image'],
                              title: taskDocument['title'],
                              note: taskDocument['note'],
                              dueDate: taskDocument['dueDate']
                                  .toDate()
                                  .toString()
                                  .split(' ')[0],
                              createDate: taskDocument['createDate']
                                  .toDate()
                                  .toString()
                                  .split(' ')[0],
                              checked: taskDocument['checked'] ?? false,
                              onCheckboxChanged: (newStatus) async {},
                              taskId: taskDocument['taskID'],
                              onCardTap: null,
                            );
                    },
                  );
          },
        );
      },
    );
  }
}
