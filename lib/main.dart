import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_2/dialog.dart';
import 'package:flutter_application_2/dialogv2.dart';
import 'package:flutter_application_2/ems.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ntfluttery/ntfluttery.dart';
import 'package:real_volume/real_volume.dart';
import 'package:vibration/vibration.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';

FlutterTts flutterTts = FlutterTts();
final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey(debugLabel: "Main Navigator");
var last = '';
var emergency = false;
final deviceInfoPlugin = DeviceInfoPlugin();
BaseDeviceInfo? deviceInfo;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  runApp(const MyApp());
}

void startBackgroundService() {
  final service = FlutterBackgroundService();
  service.startService();
}

void stopBackgroundService() {
  final service = FlutterBackgroundService();
  service.invoke("stop");
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      autoStart: true,
      onStart: onStart,
      isForegroundMode: true,
      autoStartOnBoot: true,
    ),
  );
  bool? isPermissionGranted = await RealVolume.isPermissionGranted();

  while (!isPermissionGranted!) {
    // Opens Do Not Disturb Access settings to grant the access
    Fluttertoast.showToast(
        msg:
            "Please select flutter_application_2 and enable DND settings to allow app to run in background.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
    await RealVolume.openDoNotDisturbSettings();
    isPermissionGranted = await RealVolume.isPermissionGranted();
  }

  startBackgroundService();
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;
}

String formatJson(String jsonString) {
  // Parse the JSON string
  final Map<String, dynamic> jsonData = json.decode(jsonString);

  // Create a list to hold formatted lines
  List<String> formattedLines = [];

  // Iterate over the key-value pairs in the JSON
  jsonData.forEach((key, value) {
    if (value is List) {
      // If the value is a List, format it accordingly
      formattedLines.add('\n$key:');
      for (var item in value) {
        formattedLines.add('-$item');
      }
    } else {
      // Otherwise, just add the key-value pair
      formattedLines.add('$key:$value');
    }
  });

  // Join the formatted lines with newline characters
  return formattedLines.join('\n');
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  final client = NtflutteryService(
      credentials: Credentials(
          username: 'emergencybroadcast',
          password: 'emergencybroadcastsystem'));
  //client.addLogging(true);
  deviceInfo = await deviceInfoPlugin.deviceInfo;
  Timer.periodic(const Duration(seconds: 5), (timer) async {
    final result = await client.getLatestMessage(
        'https://push.meowtechopensource.com/emergencybroadcast/json?poll=1');
    final url = 'https://push.meowtechopensource.com/ebs';
    var allInfo = '';
    try {
      allInfo = formatJson(jsonEncode(deviceInfo!.data));
    } catch (e) {
      allInfo = e.toString();
    }
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'text/plain; charset=utf-8'},
      body: 'Device Online, ' + allInfo.toString(),
    );
    //print(response.body);
    if (last == "") {
      last = result.toJson;
    } else {
      int i = 0;
      if (last != result.toJson) {
        last = result.toJson;
        Timer.periodic(Duration(seconds: 1), (timer) {
          VolumeController().setVolume(100, showSystemUI: false);
          RealVolume.setVolume(1, showUI: true, streamType: StreamType.RING);
          Vibration.vibrate(duration: 100);
          FlutterBeep.playSysSound(AndroidSoundIDs.TONE_CDMA_ABBR_ALERT);
          emergency = !emergency;
          if (i == 30) {
            timer.cancel();
          }
          i++;
        });
        flutterTts.speak(jsonDecode(last)["message"]);
        await flutterTts.awaitSpeakCompletion(true);
      }
    }
  });
  // Received the data as a touple ready to be used.
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Wall Defect Detection',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'HarmonyOS Sans TC',
        useMaterial3: true,
        cardTheme: CardTheme(color: Color.fromARGB(255, 229, 229, 234)),
      ),
      home: const WallDefectDetectionPage(title: 'Wall Defect Detection'),
    );
  }
}

class WallDefectDetectionPage extends StatefulWidget {
  const WallDefectDetectionPage({super.key, required this.title});

  final String title;

  @override
  State<WallDefectDetectionPage> createState() =>
      _WallDefectDetectionPageState();
}

class MyWidget extends StatelessWidget {
  const MyWidget(
      {super.key,
      required this.name,
      required this.value,
      required this.color});
  final String name;
  final int value;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              name,
              style: TextStyle(fontSize: 15),
            )
          ],
        ),
      ),
    );
  }
}

class _WallDefectDetectionPageState extends State<WallDefectDetectionPage> {
  int level1Defects = 7;
  int level2Defects = 0;
  int level3Defects = 0;
  int totalDefects = 7;
  List defectsList = [
    {
      'image': 'assets/ss.png',
      'suggestion':
          'Repair affected parts as soon as possible to prevent further damages.',
      'severity': 1,
      'cracks': 8,
      'location': '11m - 20m'
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          emergency ? Colors.red : Color.fromARGB(255, 241, 243, 245),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 241, 243, 245),
        title: Text(widget.title),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Color.fromARGB(255, 242, 242, 242),
              child: IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    "assets/gearshape.svg",
                  )),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/dot_radiowaves_left_and_right.svg",
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "GoPro-0102",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Spacer(),
                    TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DialogPage();
                            },
                          );
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/video_fill.svg",
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text("Live & Controls")
                          ],
                        )),
                    SizedBox(
                      width: 5,
                    ),
                    SvgPicture.asset(
                      "assets/battery_75percent.svg",
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("90%")
                  ],
                ),
              ),
            )),
            Container(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Defects Detected',
                              style: Theme.of(context).textTheme.headlineSmall),
                          Spacer(),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialogv2();
                                },
                              );
                            },
                            icon: SvgPicture.asset(
                              "assets/questionmark_circle.svg",
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: MyWidget(
                              name: 'Level 1',
                              value: level1Defects,
                              color: Colors.lightGreen.shade200,
                            ),
                          ),
                          Expanded(
                            child: MyWidget(
                              name: 'Level 2',
                              value: level2Defects,
                              color: Colors.yellowAccent.shade100,
                            ),
                          ),
                          Expanded(
                            child: MyWidget(
                              name: 'Level 3',
                              value: level3Defects,
                              color: Colors.red.shade200,
                            ),
                          ),
                          Expanded(
                            child: MyWidget(
                              name: 'Total',
                              value: totalDefects,
                              color: Colors.red.shade200,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: defectsList.length,
              itemBuilder: (context, index) {
                return Container(
                  width: double.infinity,
                  child: Card(
                    color: (defectsList[index]["severity"] == 1)
                        ? Colors.lightGreen.shade200
                        : (defectsList[index]["severity"] == 2)
                            ? Colors.yellow.shade100
                            : Colors.red.shade200,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Defect Surface #" +
                                    index.toString() +
                                    "(Level " +
                                    defectsList[index]["severity"].toString() +
                                    ")",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                defectsList[index]["cracks"].toString() +
                                    " Cracks",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Image.asset(
                                defectsList[index]["image"],
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                "assets/local_fill.svg",
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(defectsList[index]["location"]),
                            ],
                          ),
                          Container(
                            width: double.infinity,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.star_rounded),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        defectsList[index]["suggestion"],
                                        maxLines: 20,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
