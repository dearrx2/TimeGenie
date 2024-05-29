import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../utils/localizations.dart';
import 'leave_model.dart';

class Annual extends StatefulWidget {
  final List<LeaveModel>? listLeaves;

  const Annual({Key? key, required this.listLeaves}) : super(key: key);

  @override
  State<Annual> createState() => _AnnualState();
}

class _AnnualState extends State<Annual> {
  @override
  Widget build(BuildContext context) {
    List<LeaveModel>? listLeaves = widget.listLeaves ?? [];
    const String emptyProfile = 'assets/svg/signup/signup.svg';
    return listLeaves.isEmpty
        ? SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    MyLocalizations.translate("text_NoLeave"),
                  ),
                ]),
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(listLeaves.length, (index) {
              var userID = listLeaves[index].userID;
              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(userID)
                    .snapshots(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  var userData = userSnapshot.data?.data();
                  var username = userData?['name'];
                  var imageAsset = "";
                  if (listLeaves[index].type == "annual") {
                    imageAsset = 'assets/images/calendar/annual.png';
                  } else if (listLeaves[index].type == "business") {
                    imageAsset = 'assets/images/calendar/business.png';
                  } else {
                    imageAsset = 'assets/images/calendar/sick.png';
                  }

                  return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Column(
                        children: [
                          Stack(alignment: Alignment.bottomRight, children: [
                            userData!['image'] == ""
                                ? SvgPicture.asset(
                                    emptyProfile,
                                    width: 67,
                                    height: 67,
                                  )
                                : ClipOval(
                                    child: Image.network(
                                      userData!['image'].toString(),
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                            Image.asset(
                              imageAsset,
                              width: 26,
                              height: 26,
                              fit: BoxFit.fitWidth,
                            ),
                          ]),
                          Text(
                              "${username.split(" ")[0]} ${username.split(" ")[1].substring(0, 1)}")
                        ],
                      ));
                },
              );
            }),
          );
  }
}
