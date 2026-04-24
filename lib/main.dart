import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'profile_page.dart';
import 'scan.dart';

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

  // map controller is initialized here as we need it in initState
  MapController mc = MapController(
    initPosition: GeoPoint(latitude: 57.0, longitude: 10.0),
  );

  // create a suitable marker icon
  Icon marker = Icon(Icons.place, size: 50);

  @override
  void initState() {
    super.initState();

    // add a long press listener to the map
    mc.listenerMapLongTapping.addListener(() {
      // get the pressed location (if available)
      GeoPoint? p = mc.listenerMapLongTapping.value;
      if (p == null) return;

      // add marker at location p
      mc.addMarker(
        p,
        markerIcon: MarkerIcon(icon: marker),
        iconAnchor: IconAnchor(anchor: Anchor.top),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
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
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Stack(
  children: [
    OSMFlutter(
      onGeoPointClicked: (value) {
        print(value);
      },
      controller: mc,
      osmOption: OSMOption(zoomOption: ZoomOption(initZoom: 10)),
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
