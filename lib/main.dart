import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras = [] ;  // I added the default initialisation

Future<void> main() async {
	WidgetsFlutterBinding.ensureInitialized();

	cameras = await availableCameras();
	runApp(MyApp());
}

class MyApp extends StatelessWidget {   // This is where the app starts
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
	late CameraController controller;  // I added late stating that it would be initialised later

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
		//			child: Text('You have pressed the button?? times.'),
				children: <Widget>[
				Center (

					child: CameraPreview(controller),
          

				),
				],
			// well
      
        	
			),
      floatingActionButton: FloatingActionButton(
         		 elevation: 10.0,
         		 child: Icon(Icons.add),
         		 onPressed: (){
            		print('I am Floating button');
          		}
		      ), 

    );
		/* floatingActionButton: FloatingActionButton(
         		 elevation: 10.0,
         		 child: Icon(Icons.add),
         		 onPressed: (){
            		print('I am Floating button');
          		}
		), */
			
		//	CameraPreview(controller)
		   
		
		//child: CameraPreview(controller)

	}	// BuildContext
}	// end of _CameraAppState