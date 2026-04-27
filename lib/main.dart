import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'profile_page.dart';
import 'scan.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: const Color.fromRGBO(255, 165, 0, 100)),
      ),
      home: const MyHomePage(title: 'PicFindr'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  MapController? mc;

  Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the 
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale 
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately. 
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

  Future<void> _initMap() async {
  final position = await _determinePosition();

  mc = MapController(
    initPosition: GeoPoint(
      latitude: position.latitude,
      longitude: position.longitude,
    ),
  );

  if (mounted) {
    setState(() {});
  }
}
  

  Icon marker = Icon(Icons.place, size: 50, color: Colors.red);

  @override
  void initState() {
    super.initState();

    _initMap();

  }

  // Your helper method stays exactly the same
  Future<void> _addHardcodedMarkers() async {
    List<GeoPoint> myMarkers = [
      GeoPoint(latitude: 57.0488, longitude: 9.9217), 
      GeoPoint(latitude: 57.0425, longitude: 9.9189), 
      GeoPoint(latitude: 57.0288, longitude: 9.9535), 
      GeoPoint(latitude: 57.0238, longitude: 9.9335), 
    ];

    for (GeoPoint point in myMarkers) {
      await mc?.addMarker(
        point,
        markerIcon: MarkerIcon(icon: marker),
        iconAnchor: IconAnchor(anchor: Anchor.top),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

  
    // This method is rerun every time setState is called, for instance as done
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: mc == null
    ? const Center(child: CircularProgressIndicator())
    : Center(
        child: Stack(
  children: [
    OSMFlutter(
      onMapIsReady: (isReady) {
                if (isReady) {
                  _addHardcodedMarkers();
                }
              },
      onGeoPointClicked: (value) {
        print(value);
      },
      controller: mc!,
      osmOption: OSMOption(zoomOption: ZoomOption(initZoom: 12.3)),
    ),
    Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Center(
        child: ElevatedButton.icon(
          onPressed: () async {
                    // 1. Open the scanner and wait for the result
                    final scannedCode = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ScanPage()),
                    );

                    // 2. If we got a result, REPLACE the current view with Profile
                    // This ensures the "back" button goes to Map, not the Scanner.
                    if (scannedCode != null && context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(
                            scannedCode: scannedCode.toString(),
                          ),
                        ),
                      );
                    }
                  },
          icon: const Icon(Icons.qr_code_scanner),
          label: const Text("Scan"),
        ),
      ),
    ),
  ],
),
      ),
      bottomNavigationBar: BottomNavigationBar(
  currentIndex: 0,
  onTap: (index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfilePage(),
        ),
      );
    }
  },
  items: const [
    BottomNavigationBarItem(
      icon: Icon(Icons.location_on_outlined),
      label: "Map",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      label: "Your coupons",
    ),
  ],
),
    );
  }
}
