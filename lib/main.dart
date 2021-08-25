import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras = []; // I added the default initialisation

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This is where the app starts
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CameraApp(),
    );
  }
}

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

/// This is the private State class that goes with CameraApp StatefulWidget above
class _CameraAppState extends State<CameraApp> {
  XFile? imageFile; // the file for the camera capture
  late CameraController
      controller; // I added late stating that it would be initialised later

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {  // _CameraAppState
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Home Route'),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: CameraPreview(controller),
          ),
        ],
      ), // end of Stack
      floatingActionButton: FloatingActionButton(
        elevation: 10.0,
        child: Icon(Icons.camera_alt),
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
//                await _initializeControllerFuture; // mine is already initialised elsewhere

            // Attempt to take a picture and then get the location
            // where the image file is saved.
            final image = await controller.takePicture();
            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                  
                ),
              ),
            );  // end of await
            String msg = "The image was saved to: " + image.path;
            showInSnackBar(msg);
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        //onPressed: (){
        //	print('I am Floating button');
        //}
      ),
    );  // end of scaffold
  } // BuildContext for camerapp
  
  void showInSnackBar(String message) {
      // I had to move this class within the _CameraAppState or _scaffoldKey was undefined
   //   _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(message)));
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            /* action: SnackBarAction(
              label: 'Action',
              onPressed: () {
                // Code to execute.
              },
            ), */
          ),
      );
  }

} // end of _CameraAppState

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),  // this is the already saved image
    );
  } //
}
