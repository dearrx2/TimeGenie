import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:untitled/utils/localizations.dart';

import '../../../utils/style.dart';

class ShowData extends StatefulWidget {
  const ShowData({Key? key}) : super(key: key);

  @override
  State<ShowData> createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  final String emptyProfie = 'assets/svg/signup/signup.svg';
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        MyLocalizations.translate("text_WFH"),
                        style: text,
                      ),
                      Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('request_wfh')
                                .where('date',
                                    isEqualTo: DateFormat('d/M/y')
                                        .format(DateTime.now()))
                                .where('approveStatus', isEqualTo: "approved")
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                int count = snapshot.data?.docs.length ?? 0;
                                return Text(
                                    '$count ${MyLocalizations.translate("text_People")}');
                              }
                            },
                          ))
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("request_wfh")
                    .where('date',
                        isEqualTo: DateFormat('d/M/y').format(DateTime.now()))
                    .where('approveStatus', isEqualTo: "approved")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Error fetching data."),
                    );
                  }

                  var documents = snapshot.data?.docs;
                  bool hasApprovedRequest = false;

                  if (documents != null) {
                    for (var doc in documents) {
                      var documentData = doc.data();
                      var approve = documentData['approveStatus'];
                      if (approve == "approved") {
                        hasApprovedRequest = true;
                        break;
                      }
                    }
                  }
                  if (!hasApprovedRequest) {
                    return Text(MyLocalizations.translate("text_NoWFH"));
                  }
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            List.generate(documents?.length ?? 0, (index) {
                          var documentData = documents![index].data();
                          var userID = documentData['userID'];
                          return StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("users")
                                .doc(userID)
                                .snapshots(),
                            builder: (context, userSnapshot) {
                              if (!userSnapshot.hasData) {
                                return const ListTile(
                                  title: Text('Loading...'),
                                );
                              }
                              var userData = userSnapshot.data?.data();
                              var username = userData?['name'];
                              // return Text(userData?['name']);
                              return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Column(
                                    children: [
                                      Stack(
                                          alignment: Alignment.bottomRight,
                                          children: [
                                            userData!['image'] == ""
                                                ? SvgPicture.asset(
                                                    emptyProfie,
                                                    width: 67,
                                                    height: 67,
                                                  )
                                                : ClipOval(
                                                    child: Image.network(
                                                      userData!['image']
                                                          .toString(),
                                                      width: 60,
                                                      height: 60,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                            Image.asset(
                                              'assets/images/calendar/wfh.png',
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
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
