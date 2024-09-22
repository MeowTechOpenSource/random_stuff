import 'package:flutter/material.dart';
import 'package:flutter_application_2/dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wall Defect Detection',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
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
  int level1Defects = 3;
  int level2Defects = 2;
  int level3Defects = 1;
  int totalDefects = 6;
  List defectsList = [
    {
      'image': 'https://via.placeholder.com/150',
      'suggestion': 'ABCD',
      'severity': 3,
      'location': '11m - 20m'
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
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
                    Icon(Icons.wifi_rounded),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "GoPro-0102",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Spacer(),
                    IconButton(
                        onPressed: () {}, icon: Icon(Icons.videocam_rounded)),
                    Icon(Icons.battery_6_bar_outlined),
                    Text("90%")
                  ],
                ),
              ),
            )),
            ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const DialogPage();
                    },
                  );
                },
                child: Text("EMERGENCY CONTROLS")),
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
                              onPressed: () {}, icon: Icon(Icons.info_rounded))
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
                                "Defects #" + index.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                              ),
                            ),
                          ),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Image.network(
                                defectsList[index]["image"],
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.location_on_rounded),
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
                                    Icon(Icons.settings_suggest_rounded),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(defectsList[index]["suggestion"]),
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
