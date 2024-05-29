import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:async';
import 'face_api.dart' as Regula;


class checkin_page extends StatefulWidget {
  @override
  _checkin_pageState createState() => _checkin_pageState();
}

class _checkin_pageState extends State<checkin_page> {


  bool _hasLocationPermission = false;
  bool _hasCameraPermission = false;

  var image1 = new Regula.MatchFacesImage();
  var img1 = Image.asset('assets/images/portrait.png');


  // Replace this with your Line Notify access token
  static const String lineNotifyAccessToken1 =
      'baCzvuNcjbuOeMAZzvv0pUUjyAIrDfvcXW67H0C7n3c';
  static const String lineNotifyAccessToken2 =
      '8rGxOE2bx5iLL4tlOmyA3NzFXlQ8dV4qbZasr2zwStM';

  @override
  void initState() {
    super.initState();
    //checkPermissions();
    initPlatformState();
    const EventChannel('flutter_face_api/event/video_encoder_completion')
        .receiveBroadcastStream()
        .listen((event) {
      var completion =
      Regula.VideoEncoderCompletion.fromJson(json.decode(event))!;
      print("VideoEncoderCompletion:");
      print("    success:  ${completion.success}");
      print("    transactionId:  ${completion.transactionId}");
    });
    const EventChannel('flutter_face_api/event/onCustomButtonTappedEvent')
        .receiveBroadcastStream()
        .listen((event) {
      print("Pressed button with id: $event");
    });
    const EventChannel('flutter_face_api/event/livenessNotification')
        .receiveBroadcastStream()
        .listen((event) {
      var notification =
      Regula.LivenessNotification.fromJson(json.decode(event));
      print("LivenessProcessStatus: ${notification!.status}");
    });
  }

  Future<void> initPlatformState() async {
    Regula.FaceSDK.init().then((json) {
      var response = jsonDecode(json);
      if (!response["success"]) {
        print("Init failed: ");
        print(json);
      }
    });
  }

  setImage(bool first, Uint8List? imageFile, int type) {
    if (imageFile == null) return;
    print("image file is null");
    if (first) {
      image1.bitmap = base64Encode(imageFile);
      image1.imageType = type;
      setState(() {
        img1 = Image.memory(imageFile);
      });
    }
  }

  liveness() => Regula.FaceSDK.startLiveness().then((value) {
    var result = Regula.LivenessResponse.fromJson(json.decode(value));
    if (result!.bitmap == null) return;
    setImage(true, base64Decode(result.bitmap!.replaceAll("\n", "")),
        Regula.ImageType.LIVE);
  });

  Widget createButton(String text, VoidCallback onPress) => Container(
    // ignore: deprecated_member_use
    child: TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.black12),
        ),
        onPressed: onPress,
        child: Text(text)),
    width: 250,
  );

  Widget createImage(image) => Material(
      child: InkWell(
        child: Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image(height: 150, width: 150, image: image),
          ),
        ),
      ));

  Future<void> checkPermissions() async {
    // Check if both location and camera permissions are granted
    final locationStatus = await Permission.location.status;
    final cameraStatus = await Permission.camera.status;

    setState(() {
      _hasLocationPermission = locationStatus.isGranted;
      _hasCameraPermission = cameraStatus.isGranted;
    });

    if (!_hasLocationPermission || !_hasCameraPermission) {
      // Request both permissions if not granted
      final permissions = [Permission.location, Permission.camera];
      final results = await permissions.request();
      if (results[Permission.location] == PermissionStatus.granted &&
          results[Permission.camera] == PermissionStatus.granted) {
        // Both permissions granted, continue
        setState(() {
          _hasLocationPermission = true;
          _hasCameraPermission = true;
        });
      } else {
        print('Permissions not granted.');
      }
    }
  }

  // Future<void> initializeCamera() async {
  //   final cameras = await availableCameras();
  //   final frontCamera = cameras.firstWhere(
  //           (camera) => camera.lensDirection == CameraLensDirection.front,
  //       orElse: () => cameras.first);
  //
  //   setState(() {
  //     _cameraController = CameraController(
  //       frontCamera,
  //       ResolutionPreset.high,
  //       enableAudio: false,
  //     );
  //   });
  //
  //   await _cameraController.initialize();
  //   if (mounted) {
  //     setState(() {
  //       _isCameraReady = true;
  //     });
  //   }
  // }


  // Future<void> sendLineNotify(
  //     String message,
  //     String imageFullsize,
  //     String address,
  //     String time,
  //     String imageThumbnail,
  //     String accessToken) async {
  //   final String url = 'https://notify-api.line.me/api/notify';
  //   final Map<String, String> headers = {
  //     'Authorization': 'Bearer $accessToken',
  //     'Content-Type': 'application/x-www-form-urlencoded'
  //   };
  //   final formattedDateTime =
  //   DateFormat('yyyy-MM-dd \nHH:mm:ss').format(DateTime.parse(time));
  //   final Map<String, String> data = {
  //     'message':
  //     '$message $address at $formattedDateTime', // Include address and time in the message
  //     'imageFullsize': imageFullsize,
  //     'imageThumbnail': imageThumbnail,
  //   };
  //
  //   try {
  //     final response =
  //     await http.post(Uri.parse(url), headers: headers, body: data);
  //     if (response.statusCode == 200) {
  //       print('Notification sent successfully!');
  //     } else {
  //       print(
  //           'Failed to send notification. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error sending notification: $e');
  //   }
  // }

  Future<String> getAddressFromCoordinates() async {
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    final placemarks =
    await GeocodingPlatform.instance?.placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    final placemark = placemarks?.first;
    return '${placemark?.locality}, ${placemark?.administrativeArea}, ${placemark?.country}';
  }





  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 100),
        width: double.infinity,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              createImage(img1.image),
              Container(margin: EdgeInsets.fromLTRB(0, 0, 0, 15)),
              createButton("Liveness", () => liveness()),
              Container(
                  margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                  ))
            ])),
  );

  @override
  void dispose() {
    super.dispose();
  }
}
