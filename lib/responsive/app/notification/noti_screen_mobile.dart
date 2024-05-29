// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:flutter/material.dart';
// import 'package:untitled/responsive/hwak_playground.dart';
//
// import '../../../components/notification/button.dart';
// import '../../../services/notification_service.dart';
//
// class NotiPageMobile extends StatefulWidget {
//   const NotiPageMobile({Key? key}) : super(key: key);
//
//   @override
//   State<NotiPageMobile> createState() => _NotiPageMobileState();
// }
//
// class _NotiPageMobileState extends State<NotiPageMobile> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         NotificationButton(
//           text: "Normal Notification",
//           onPressed: () async {
//             await NotificationService.showNotification(
//               title: "Title of the notification",
//               body: "Body of the notification",
//             );
//           },
//         ),
//         NotificationButton(
//           text: "Notification With Summary",
//           onPressed: () async {
//             await NotificationService.showNotification(
//               title: "Title of the notification",
//               body: "Body of the notification",
//               summary: "Small Summary",
//               notificationLayout: NotificationLayout.Inbox,
//             );
//           },
//         ),
//         NotificationButton(
//           text: "Progress Bar Notification",
//           onPressed: () async {
//             await NotificationService.showNotification(
//               title: "Title of the notification",
//               body: "Body of the notification",
//               summary: "Small Summary",
//               notificationLayout: NotificationLayout.ProgressBar,
//             );
//           },
//         ),
//         NotificationButton(
//           text: "Message Notification",
//           onPressed: () async {
//             await NotificationService.showNotification(
//               title: "Title of the notification",
//               body: "Body of the notification",
//               summary: "Small Summary",
//               notificationLayout: NotificationLayout.Messaging,
//             );
//           },
//         ),
//         NotificationButton(
//           text: "Big Image Notification",
//           onPressed: () async {
//             await NotificationService.showNotification(
//               title: "Title of the notification",
//               body: "Body of the notification",
//               summary: "Small Summary",
//               notificationLayout: NotificationLayout.BigPicture,
//               bigPicture:
//                   "https://files.tecnoblog.net/wp-content/uploads/2019/09/emoji.jpg",
//             );
//           },
//         ),
//         NotificationButton(
//           text: "Action Buttons Notification",
//           onPressed: () async {
//             await NotificationService.showNotification(
//                 title: "Title of the notification",
//                 body: "Body of the notification",
//                 payload: {
//                   "navigate": "true",
//                 },
//                 actionButtons: [
//                   NotificationActionButton(
//                     key: 'check',
//                     label: 'Check it out',
//                     actionType: ActionType.SilentAction,
//                     color: Colors.green,
//                   )
//                 ]);
//           },
//         ),
//         NotificationButton(
//           text: "Scheduled Notification",
//           onPressed: () async {
//             await NotificationService.showNotification(
//               title: "Scheduled Notification",
//               body: "Notification was fired after 5 seconds",
//               scheduled: true,
//               interval: 5,
//             );
//           },
//         ),
//         TextButton(
//             onPressed: () {
//               Navigator.push(
//                   context, MaterialPageRoute(builder: (context) => Hwak()));
//             },
//             child: const Text('Hwak'))
//       ],
//     );
//   }
// }
