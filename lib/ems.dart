import 'package:flutter/material.dart';

class RedThing extends StatefulWidget {
  RedThing({super.key, required this.info});
  String info;
  @override
  State<RedThing> createState() => _RedThingState();
}

class _RedThingState extends State<RedThing> {
  @override
  var timer2;

  void initState() {
    super.initState();
    //VolumeController().setVolume(1);
    // Timer.periodic(Duration(milliseconds: 200), (timer) {
    //   timer2 = timer;
    //   HapticFeedback.vibrate();
    //   FlutterBeep.beep();
    // });
  }

  void dispose() {
    super.dispose();
    timer2.cancel();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '3A Homework Board',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red,
      ),
      backgroundColor: Colors.red,
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Emergency Notification:",
              style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              widget.info.replaceAll("EMERGENCY:", ""),
              style: TextStyle(fontSize: 30, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.exit_to_app,
                  size: 40,
                  color: Colors.white,
                ))
          ],
        ),
      ),
    );
  }
}
