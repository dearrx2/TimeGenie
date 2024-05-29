import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/utils/color_utils.dart';
import 'package:lottie/lottie.dart';
import '../../../components/approval/approval_request_card.dart';
import '../../../utils/localizations.dart';
import '../main/main_page.dart';

class UserProfile {
  final String displayName;
  final String profileImageUrl;


  UserProfile({
    required this.displayName,
    required this.profileImageUrl,
  });
}

class ApprovalPageWeb extends StatefulWidget {
  const ApprovalPageWeb({Key? key}) : super(key: key);

  @override
  State<ApprovalPageWeb> createState() => _ApprovalPageState();
}

//animation loading
class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/animation/animation_loading.json', // Replace with your loading animation file path
        width: 200,
        height: 200,
      ),
    );
  }
}

//no_data picture
Widget _buildNoDataWidget() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 5.0), // Add bottom padding
        child: Image.asset(
          'assets/images/no_data/no_data.png',
          width: 150,
          height: 125,
        ),
      ),
      const SizedBox(height: 8),
      const Center(
        child: Text(
          'No request',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    ],
  );
}





class _ApprovalPageState extends State<ApprovalPageWeb>
    with SingleTickerProviderStateMixin {
  String? _userID;
  String? _userRole;
  String? _managerName;

  SharedPreferences? _prefs;

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _prefs?.setBool('checkNotification', true);
    print('from approved ${_prefs?.getBool('checkNotification')}');
  }

  void refreshUI() {
    setState(() {
      // Trigger UI refresh
    });
  }


  late TabController _tabController;
  final _tabs = [
    Tab(text: MyLocalizations.translate("text_Waiting_Approval")),
    Tab(text: MyLocalizations.translate("text_Approved_Approval")),
    Tab(text: MyLocalizations.translate("text_Rejected_Approval")),
  ];

  @override
  void initState() {
    _tabController = TabController(length: _tabs.length, vsync: this);
    _getUserID();
    _initSharedPreferences();
    super.initState();
  }

  void _getUserID() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userID = user.uid;
        _getUserRole(); // Moved _getUserRole call here after setting _userID
      });
    }
  }


  void _getUserRole() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userID)
          .get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
        setState(() {
          _userRole = userData['role'] ?? '';
          _managerName = userData['name']; // Fetch manager's name
          print('User Role: $_userRole');
          print('Manager Name: $_managerName'); // Print the manager's name
        });
      }
    } catch (e) {
      print('Error fetching user role: $e');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        backgroundColor: cream,
        centerTitle: true,
        elevation: 0,
        title: Text(
          MyLocalizations.translate("text_Approval"),
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: GestureDetector(
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: orange),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreenPage(uid: '',),
                ),
              );
            },
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: bg,
        ),
        child: Column(
          children: [
            Container(
              height: kToolbarHeight,
              padding:
              const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(80.0),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(80.0),
                  color: primaryColor,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: primaryColor,
                tabs: _tabs,
                labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'prompt'
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildApprovalListView(status: 'waiting'),
                  _buildApprovalListView(status: 'approved'),
                  _buildApprovalListView(status: 'rejected'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildApprovalListView({required String status}) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getRequestStream(status: status),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingAnimation(); // Show loading animation
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error fetching data'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return  _buildNoDataWidget();
        }

        List<String> userIds = snapshot.data!
            .map<String>((doc) => doc['userID'] as String)
            .toList();

        return FutureBuilder<List<UserProfile?>>(
          future: _fetchAllUserDetails(userIds),
          builder: (context, userSnapshots) {
            if (userSnapshots.connectionState == ConnectionState.waiting) {
              return LoadingAnimation(); // Show loading animation
            }

            if (userSnapshots.hasError) {
              return const Center(child: Text('Error fetching user data'));
            }

            List<UserProfile?> userDetailsList = userSnapshots.data!;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> requestData = snapshot.data![index];

                  UserProfile? userDetails = userDetailsList[index];

                  if (userDetails == null) {
                    return const Center(child: Text(''));
                  }

                  Timestamp? createDateTimestamp = requestData['createDate'] as Timestamp?;
                  Timestamp? startDateTimestamp = requestData['startDate'] as Timestamp?;
                  Timestamp? endDateTimestamp = requestData['endDate'] as Timestamp?;
                  Timestamp? selectDateTimestamp = requestData['selectDate'] as Timestamp?;


                  DateTime createDate = createDateTimestamp?.toDate() ?? DateTime.now();
                  DateTime startDate = startDateTimestamp?.toDate() ?? DateTime.now();
                  DateTime? endDate = endDateTimestamp?.toDate();
                  DateTime selectDate = selectDateTimestamp?.toDate() ?? startDate; // Use startDate if selectDate is not available

                  int daysDuration = 0; // Initialize the daysDuration

                  if (endDate != null) {
                    Duration duration = endDate.difference(selectDate);
                    daysDuration = duration.inDays;
                  }



                  return ApprovalRequestCard(
                    displayName: userDetails.displayName,
                    profileImageUrl: userDetails.profileImageUrl,
                    approveStatus: requestData['approveStatus'] ?? '',
                    createDate: createDate,
                    selectDate: selectDate, //selectDate=startDate
                    endDate: endDate,
                    type: requestData['collectionName'],
                    image: requestData['image']??'',
                    reason: requestData['reason'],
                    daysDuration: daysDuration,
                    requestID:requestData['requestID'],
                    role:_userRole,
                    managerName: _userRole == 'manager' || _userRole == 'เมเนเจอร์' || _userRole == 'senior' || _userRole == 'ซีเนียร์'
                        ? _managerName
                        : null,
                    refreshCallback: refreshUI,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }


  Future<List<Map<String, dynamic>>> _getRequestData(
      CollectionReference collectionRef, String status,String collectionName) async {
    QuerySnapshot querySnapshot;

    if (_userRole == 'manager' || _userRole == 'เมเนเจอร์' || _userRole == 'senior' || _userRole == 'ซีเนียร์') {
      querySnapshot = await collectionRef.where('approveStatus', isEqualTo: status).get();
    } else {
      querySnapshot = await collectionRef.where('userID', isEqualTo: _userID)
          .where('approveStatus', isEqualTo: status)
          .get();

    }

    List<Map<String, dynamic>> dataList = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['collectionName'] = collectionName; // Add collection name field
      return data;
    }).toList();

    return dataList;
  }

  Future<List<Map<String, dynamic>>> _getRequestStream({required String status}) async {
    CollectionReference requestWFHCollection =
    FirebaseFirestore.instance.collection('request_wfh');
    CollectionReference requestAnnualCollection =
    FirebaseFirestore.instance.collection('request_annual');
    CollectionReference requestBusinessCollection =
    FirebaseFirestore.instance.collection('request_business');
    CollectionReference requestSickCollection =
    FirebaseFirestore.instance.collection('request_sick');

    List<Future<List<Map<String, dynamic>>>> streamFutures = [];

    streamFutures.add(_getRequestData(requestWFHCollection, status, 'request_wfh'));
    streamFutures.add(_getRequestData(requestAnnualCollection, status, 'request_annual'));
    streamFutures.add(_getRequestData(requestBusinessCollection, status, 'request_business'));
    streamFutures.add(_getRequestData(requestSickCollection, status, 'request_sick'));

    List<List<Map<String, dynamic>>> dataList = await Future.wait(streamFutures);

    List<Map<String, dynamic>> mergedList = dataList.fold<List<Map<String, dynamic>>>(
        [], (previousValue, element) => previousValue..addAll(element));

    return mergedList;
  }


  Future<List<UserProfile?>> _fetchAllUserDetails(List<String> userIds) async {
    List<Future<UserProfile?>> userDetailFutures = userIds.map((userId) {
      return getUserDetails(userId);
    }).toList();

    return Future.wait(userDetailFutures);
  }

  Future<UserProfile?> getUserDetails(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData = userSnapshot.data()!;
        return UserProfile(
          displayName: userData['name'] ?? '',
          profileImageUrl: userData['image'] ?? '',
        );
      }
      return null; // Return null if user doesn't exist
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

}
