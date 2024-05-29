import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:untitled/components/todo/todo_addnewtask.dart';
import 'package:untitled/utils/color_utils.dart';
import '../../../components/loading_animation.dart';
import '../../../components/todo/todocard.dart';
import '../../../components/todo/todocard_manager.dart';
import '../../../utils/localizations.dart';
import '../../../utils/style.dart';

class TodoPageMobile extends StatefulWidget {
  const TodoPageMobile({Key? key}) : super(key: key);

  @override
  State<TodoPageMobile> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPageMobile>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  late TabController _tabController;
  final _selectedColor = orange;
  final _tabs = [
    Tab(text: MyLocalizations.translate("tabbar_Tasks")),
    Tab(text: MyLocalizations.translate("tabbar_Completed")),
  ];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _getUserIDAndRole();
    super.initState();
  }



  void _getUserIDAndRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userID = user.uid;
      });

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userSnapshot.exists) {
        setState(() {
          _role = userSnapshot['role'];
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _navigateToAddNewTask() {
    showDialog(
      context: context,
      builder: (context) => const AddNewTask(),
    );
  }

  String? _userID;
  String? _role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: cream,
          centerTitle: true,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            MyLocalizations.translate("appbar_TODO"),
            style: appBar.copyWith(
              color: orange,
            ),
          ),
          actions: [
            if (_role != null && _role != 'manager' && _role != 'เมเนเจอร์')
              IconButton(
                icon: const Icon(
                  Icons.add_sharp,
                  color: orange,
                  size: 32,
                ),
                onPressed: () {
                  _navigateToAddNewTask();
                },
              ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: bg,
          ),

          child: Column(
            children: [
              Column(
                children: [
                  Stack(
                    children: [
                      ClipPath(
                        clipper: BazierCurve(),
                        child: Container(
                          color: cream,
                          height: 50,
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 4.0),
                          child: Container(
                            height: kToolbarHeight,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 8.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(80.0),
                            ),
                            child: TabBar(
                              controller: _tabController,
                              indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(80.0),
                                color: _selectedColor,
                              ),
                              labelColor: Colors.white,
                              unselectedLabelColor: _selectedColor,
                              tabs: _tabs,
                              labelStyle: tabBarText,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),

              Expanded(
                child: _role == null
                    ? const LoadingAnimation()
                    : TabBarView(
                  controller: _tabController,
                  children: [
                    if (_role == 'manager' || _role == 'เมเนเจอร์')
                      ...[
                        TodoCardManager.buildTaskListStream(_userID!, false),
                        TodoCardManager.buildTaskListStream(_userID!, true),
                      ]
                    else
                      ...[
                        TodoCard.buildTaskListStream(_userID!, false),
                        TodoCard.buildTaskListStream(_userID!, true),
                      ]
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
}

class BazierCurve extends CustomClipper<Path> {  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height * 0.5);

    path.quadraticBezierTo(
        size.width * 0.25,
        size.height,
        size.width * 0.5,
        size.height
    );

    path.quadraticBezierTo(
        size.width * 0.75,
        size.height ,
        size.width,
        size.height * 0.5
    );


    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}