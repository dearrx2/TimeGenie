import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/responsive/app/home/success_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

class checkin_pageee extends StatefulWidget {
  @override
  _checkin_pageState createState() => _checkin_pageState();
}

class _checkin_pageState extends State<checkin_pageee> {
  late CameraController _cameraController;
  XFile? _imageFile;
  bool _isCameraReady = false;
  bool _isUploadingImage = false;

  // Replace this with your Line Notify access token
  static const String lineNotifyAccessToken =
      'baCzvuNcjbuOeMAZzvv0pUUjyAIrDfvcXW67H0C7n3c';

  @override
  void initState() {
    super.initState();
    initializeCamera();
    checkLocationPermission(); // Request location permission
  }

  Future<void> checkLocationPermission() async {
    // Check if location permission is granted, if not, request it
    if (await Permission.location.request().isGranted) {
      print("Location permission granted");
    } else {
      print("Location permission not granted");
    }
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first);
    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    _cameraController.initialize().then((_) {
      if (!mounted) return;
      setState(() {
        _isCameraReady = true;
      });
    }).catchError((error) {
      print('Error initializing camera: $error');
    });
  }

  Future<void> takePicture() async {
    if (!_cameraController.value.isInitialized) {
      return;
    }
    try {
      final XFile? xFile = await _cameraController.takePicture();
      if (xFile == null) {
        return;
      }
      final img.Image image =
          img.decodeImage(File(xFile.path).readAsBytesSync())!;
      final img.Image grayscaleImage = img.grayscale(image);
      File grayscaleFile =
          File(xFile.path.replaceAll('.jpg', '_grayscale.jpg'));
      grayscaleFile.writeAsBytesSync(img.encodeJpg(grayscaleImage));
      XFile grayscaleXFile = XFile(grayscaleFile.path);

      setState(() {
        _imageFile = grayscaleXFile;
      });
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  Future<void> uploadImageToFirebase() async {
    if (_imageFile == null) {
      return;
    }
    setState(() {
      _isUploadingImage = true;
    });

    final File image = File(_imageFile!.path);

    final Reference ref =
        FirebaseStorage.instance.ref().child('check_ins/${DateTime.now()}.jpg');

    try {
      await ref.putFile(image);
      final imageUrl = await ref.getDownloadURL();
      final imageThumbnail = await ref.getDownloadURL();
      final address = await getAddressFromCoordinates();
      final time = DateTime.now().toString();
      await saveCheckInDataToFirestore(imageUrl, address, time);
      await sendLineNotify(
          'New check-in:', imageUrl, address, time, imageThumbnail);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessPage(
            checkInTime: DateTime.now(),
            imageUrl: imageUrl,
          ),
        ),
      );
    } on FirebaseException catch (e) {
      print('Error uploading image to Firebase: $e');
      // TODO: Handle error, e.g., show error message
    } catch (e) {
      print('Error sending Line Notify message: $e');
    } finally {
      setState(() {
        _isUploadingImage = false;
      });
    }
  }

  Future<void> saveCheckInDataToFirestore(
      String imageUrl, String address, String time) async {
    final checkInTime = DateTime.now();

    // Get the user's current location
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    await FirebaseFirestore.instance.collection('check_ins').add({
      'imageUrl': imageUrl,
      'checkInTime': checkInTime,
      'latitude': position.latitude,
      'longitude': position.longitude,
      'address': address,
      'time': time, // Store the time
    });
  }

  Future<void> sendLineNotify(String message, String imageFullsize,
      String address, String time, String imageThumbnail) async {
    final String url = 'https://notify-api.line.me/api/notify';
    final Map<String, String> headers = {
      'Authorization': 'Bearer $lineNotifyAccessToken',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    final formattedDateTime =
        DateFormat('yyyy-MM-dd \nHH:mm:ss').format(DateTime.parse(time));
    final Map<String, String> data = {
      'message':
          '$message $address at $formattedDateTime', // Include address and time in the message
      'imageFullsize': imageFullsize,
      'imageThumbnail': imageThumbnail,
    };

    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: data);
      if (response.statusCode == 200) {
        print('Notification sent successfully!');
      } else {
        print(
            'Failed to send notification. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check In Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: _imageFile != null
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Image.file(File(_imageFile!.path)),
                    )
                  : _cameraPreviewWidget(),
            ),
            ElevatedButton(
              onPressed: _isCameraReady ? takePicture : null,
              child: Text('Take Picture'),
            ),
            ElevatedButton(
              onPressed: _imageFile != null && !_isUploadingImage
                  ? uploadImageToFirebase
                  : null,
              child: Text('Upload Image to Firebase'),
            ),
            if (_isUploadingImage) CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _cameraPreviewWidget() {
    if (!_isCameraReady) {
      return Center(child: CircularProgressIndicator());
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: CameraPreview(_cameraController),
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }
}

Future<String> getAddressFromCoordinates() async {
  final Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
  final placemarks = await GeocodingPlatform.instance?.placemarkFromCoordinates(
    position.latitude,
    position.longitude,
  );
  final placemark = placemarks?.first;
  return '${placemark?.locality}, ${placemark?.administrativeArea}, ${placemark?.country}';
}
