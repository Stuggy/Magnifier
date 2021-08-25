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
    /*    return Scaffold(
    appBar: AppBar(
      title: const Text('Sample Code'),
    ),
    body: Center(
      child: Text('You have pressed the button times.')
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
     
      }
    ),
//	child: CameraApp(),
  ); */
//}

    return MaterialApp(
      /* appBar: AppBar(
			title: Text('test'),
			), */
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

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      /* hg AspectRatio(		// Using Aspectratio got the camera to show again
				aspectRatio: controller.value.aspectRatio,	// just sets the aspectratio of the view I think
				child: CameraPreview(controller)
			), */
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
        child: Icon(Icons.add),
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
            );
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
      body: Image.file(File(imagePath)),
    );
  } //
}
