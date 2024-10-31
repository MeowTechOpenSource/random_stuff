import 'package:flutter/material.dart';
import 'package:flutter_application_2/constants.dart';
import 'package:flutter_application_2/dialog.dart';
import 'package:flutter_application_2/dialogv2.dart';
import 'package:flutter_svg/svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      backgroundColor: Color.fromARGB(255, 241, 243, 245),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 241, 243, 245),
        title: Text(widget.title),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Color.fromARGB(255, 242, 242, 242),
              child: IconButton(
                  onPressed: () {
                    setState(() {});
                  },
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
                          // Expanded(
                          //   child: MyWidget(
                          //     name: 'Level 1',
                          //     value: level1Defects,
                          //     color: Colors.lightGreen.shade200,
                          //   ),
                          // ),
                          // Expanded(
                          //   child: MyWidget(
                          //     name: 'Level 2',
                          //     value: level2Defects,
                          //     color: Colors.yellowAccent.shade100,
                          //   ),
                          // ),
                          // Expanded(
                          //   child: MyWidget(
                          //     name: 'Level 3',
                          //     value: level3Defects,
                          //     color: Colors.red.shade200,
                          //   ),
                          // ),
                          Expanded(
                            child: MyWidget(
                              name: 'Total',
                              value: crackNums,
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
              itemCount: combinedList.length,
              itemBuilder: (context, index) {
                return Container(
                  width: double.infinity,
                  child: Card(
                    color: Colors.red.shade200,
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
                                "Group Of Cracks #" + index.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                              ),
                            ),
                          ),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Image.network(
                                "http://192.168.0.250:5000/" +
                                    combinedList[index][2],
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
                              Text(combinedList[index][0].toString() +
                                  "m, " +
                                  combinedList[index][1].toString() +
                                  "m"),
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
                                        "Fix Soon",
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
