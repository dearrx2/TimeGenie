import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package
import 'package:lottie/lottie.dart';
import 'package:untitled/utils/color_utils.dart';
import 'package:untitled/utils/localizations.dart';
import '../dialog/dialog.dart';
import '../short_button.dart';

class ApprovalRequestCard extends StatelessWidget {
  final String displayName;
  final String profileImageUrl;
  final String approveStatus;
  final DateTime createDate;
  final DateTime selectDate;
  final DateTime? endDate;
  final String type;
  final String? image;
  final String? reason;
  final int? daysDuration;
  final String requestID;
  final String? managerName;
  final String? role;
  final VoidCallback refreshCallback;

  ApprovalRequestCard({
    Key? key,
    required this.displayName,
    required this.profileImageUrl,
    required this.approveStatus,
    required this.createDate,
    required this.selectDate,
    required this.endDate,
    required this.type,
    required this.image,
    required this.reason,
    required this.daysDuration,
    required this.requestID,
    required this.refreshCallback,
    required this.managerName,
    required this.role,
  });

  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  final Map<String, TypeInfo> typeInfoMap = {
    'request_wfh': TypeInfo('assets/images/icon_tag_leave/wfh_tag.png', wfhIcon),
    'request_business': TypeInfo('assets/images/icon_tag_leave/business_tag.png', Colors.green),
    'request_sick': TypeInfo('assets/images/icon_tag_leave/sick_tag.png', sickIcon),
    'request_annual': TypeInfo('assets/images/icon_tag_leave/annual_tag.png', annualIcon),
  };



  @override
  Widget build(BuildContext context) {
    TypeInfo typeInfo = typeInfoMap[type] ?? TypeInfo('', Colors.black);
    String typeImageAsset = typeInfo.imageAsset;
    Color typeColor = typeInfo.color;

    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        //border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16,right: 16,left: 16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: cream,
                  backgroundImage: profileImageUrl.isNotEmpty
                      ? NetworkImage(profileImageUrl)
                      : null,
                  child: profileImageUrl.isEmpty
                      ? SvgPicture.asset(
                    'assets/images/no_data/undraw_images_no_data.svg',
                    width: 56,
                    height: 56,
                  )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Text(
                          displayName.length > 22
                              ? '${displayName.substring(0, 22)}...'
                              : displayName,
                          style: const TextStyle(
                            fontSize: 18,
                            color: primaryTextColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (typeImageAsset.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(right: 4, top: 4),
                                child: Image.asset(
                                  typeImageAsset,
                                  width: 14,
                                  height: 14,
                                ),
                              ),
                            Text(
                              type,
                              style: TextStyle(
                                fontSize: 14,
                                color: typeColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 1.0),
                              child: Icon(
                                Icons.calendar_month_rounded,
                                color: primaryTextColor,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text.rich(
                              TextSpan(
                                text:
                                '${_dateFormat.format(selectDate)}${endDate != null ? ' - ${_dateFormat.format(endDate!)}' : ''}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: primaryTextColor,
                                ),
                                children: [
                                  if (daysDuration != null && type != 'request_wfh')
                                    TextSpan(
                                      text: ' (${daysDuration! + 1} days)',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.red,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          MyLocalizations.translate("text_Created_Date")+': ${_dateFormat.format(createDate)}',
                          style: const TextStyle(
                            color: grey,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (reason != null)
            Padding(
              padding: const EdgeInsets.only(right: 16,left: 16,bottom: 4),
              child: Text(
                'Reason: ${reason ?? ' '}',
                style: const TextStyle(
                  fontSize: 14,
                  color: primaryTextColor,
                ),
              ),
            ),
          if (image != null && image != '')
            Padding(
              padding: const EdgeInsets.only(right: 16,left: 16,bottom: 8,top: 4),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.network(
                                    image!,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: Lottie.asset(
                                          'assets/animation/dancing_loading.json',
                                          width: 200,
                                          height: 200,
                                        ),
                                      );
                                    },
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: IconButton(
                                        icon: Center(child: Icon(Icons.close)),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: const Text(
                  'view image',
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline,
                    color: Color(0xFF0C99B7),
                  ),
                ),
              ),
            ),

          const SizedBox(height: 10),
          if (approveStatus == 'approved')
            FutureBuilder<Map<String, dynamic>>(
              future: getApproveByAndDate(),
              builder: (context, snapshot) {
                final approvedBy = snapshot.data?['approveBy'] ?? 'N/A';
                final approvedDate = snapshot.data?['approveDate'] != null
                    ? DateFormat('dd/MM/yy').format(snapshot.data?['approveDate'].toDate())
                    : 'N/A';

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                      color: approvalApprovedCard,
                    ),
                    width: double.infinity,
                    height: 58,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Padding(
                          padding: EdgeInsets.only(left: 16,right: 8,top: 16,bottom: 16),
                          child: Text(
                            MyLocalizations.translate("text_Approval"),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          MyLocalizations.translate("text_By_Approval")+': ${approvedBy.length > 10 ? '${approvedBy.substring(0, 10)}...' : approvedBy}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Text(
                            MyLocalizations.translate("text_Date_Approval")+': $approvedDate',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

          if (approveStatus == 'rejected')
          FutureBuilder<Map<String, dynamic>>(
            future: getApproveByAndDate(),
            builder: (context, snapshot) {
              final approvedBy = snapshot.data?['approveBy'] ?? 'N/A';
              final approvedDate = snapshot.data?['approveDate'] != null
                  ? DateFormat('dd/MM/yy').format(snapshot.data?['approveDate'].toDate())
                  : 'N/A';

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                    color: approvalRejectedCard,
                  ),
                  width: double.infinity,
                  height: 58,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16,right: 8,top: 16,bottom: 16),
                        child: Text(
                          MyLocalizations.translate("text_Rejected_Approval"),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        MyLocalizations.translate("text_By_Approval")+': ${approvedBy.length > 10 ? '${approvedBy.substring(0, 10)}...' : approvedBy}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Text(
                          MyLocalizations.translate("text_Date_Approval")+': $approvedDate',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),



          if (approveStatus == 'waiting' && managerName != null)
            if ((role == 'senior' || role == 'ซีเนียร์' || role == 'manager' || role == 'เมเนเจอร์') && (role != 'senior' || type == 'request_wfh'))
              Padding(
                padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ShortButton(
                    titleLeft: MyLocalizations.translate("button_Reject"),
                    titleRight: MyLocalizations.translate("button_Approve"),
                    ontapLeft: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return ConfirmDialog(
                            type: 'confirm',
                            message: 'Are you sure you want to reject this request?',
                            onConfirm: () {
                              _updateApproveStatus('rejected');
                            },
                          );
                        },
                      );
                    },
                    ontapRight: () {
                      _updateApproveStatus('approved');
                    },
                  ),
                ),
              ),
        ],
      ),
    );
  }





  Future<void> _updateApproveStatus(String status) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      CollectionReference? requestCollection; // Declare a variable to hold the collection reference

      if (type == 'request_wfh') {
        requestCollection = firestore.collection('request_wfh');
      } else if (type == 'request_annual') {
        requestCollection = firestore.collection('request_annual');
      } else if (type == 'request_business') {
        requestCollection = firestore.collection('request_business');
      } else if (type == 'request_sick') {
        requestCollection = firestore.collection('request_sick');
      }


      if (requestCollection == null) {
        // Handle unsupported type or missing collection
        return;
      }

      final DocumentReference requestDocument = requestCollection.doc(requestID);

      final DocumentSnapshot requestSnapshot = await requestDocument.get();
      if (requestSnapshot.exists) {
        final requestData = requestSnapshot.data() as Map<String, dynamic>;

        // Check if requestID matches and other conditions
        if (managerName != null && requestData['requestID'] == requestID  ) {
          await requestDocument.update({
            'approveStatus': status,
            'approveBy': managerName,
            'approveDate': FieldValue.serverTimestamp(),
          });
          // Handle success or display a message
        } else {
          // Handle mismatched requestID or other conditions
        }
      } else {
        // Handle document not found
      }

      refreshCallback();
    } catch (error) {
      // Handle error
    }
  }



  Future<Map<String, dynamic>> getApproveByAndDate() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      CollectionReference? requestCollection;

      if (type == 'request_wfh') {
        requestCollection = firestore.collection('request_wfh');
      } else if (type == 'request_annual') {
        requestCollection = firestore.collection('request_annual');
      } else if (type == 'request_business') {
        requestCollection = firestore.collection('request_business');
      } else if (type == 'request_sick') {
        requestCollection = firestore.collection('request_sick');
      }

      if (requestCollection == null) {
        print("requestCollection == null");
        return {};
      }

      final DocumentReference requestDocument = requestCollection.doc(requestID);
      print('request $requestID');

      final DocumentSnapshot requestSnapshot = await requestDocument.get();
      if (requestSnapshot.exists) {
        final requestData = requestSnapshot.data() as Map<String, dynamic>;

        // Check if requestID matches and other conditions
        if (requestData['requestID'] == requestID) {
          // Extract the 'approveBy' and 'approveDate' fields
          final approveBy = requestData['approveBy'];
          final approveDate = requestData['approveDate'];
          print(approveBy);

          if (approveBy != null && approveDate != null) {
            return {
              'approveBy': approveBy,
              'approveDate': approveDate,
            };
          }
        }
      }
    } catch (error) {
      // Handle error
    }

    return {}; // Return an empty map if data is not found or there's an error.
  }
}

class TypeInfo {
  final String imageAsset;
  final Color color;

  TypeInfo(this.imageAsset, this.color);
}
