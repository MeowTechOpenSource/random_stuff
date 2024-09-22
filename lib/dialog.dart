import 'dart:ui';

import 'package:flutter/material.dart';

class DialogPage extends StatefulWidget {
  const DialogPage({super.key});

  @override
  State<DialogPage> createState() => _DialogPageState();
}

class _DialogPageState extends State<DialogPage> {
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 9, sigmaY: 9),
      child: AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.grey,
        insetPadding: EdgeInsets.zero,
        title: Row(
          children: [
            Text(
              "Drone001 | GoPro-0305",
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
            Spacer(),
            IconButton(
              icon: const Icon(
                Icons.close_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Live Feed",
                  style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ),
              ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.network("https://picsum.photos/1920/1080")),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Emergency Controls",
                  style: TextStyle(
                      fontSize: 32,
                      color: Colors.red.shade300,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Emergency Controls are used when the drone is out of control, out of reach or in any case of emergency. Do not use when not neccessary",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: MaterialButton(
                        height: 100,
                        color: Colors.red.shade300,
                        onPressed: () {},
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.arrow_downward_rounded),
                            Text("LAND NOW")
                          ],
                        )),
                  ),
                  Expanded(
                    child: MaterialButton(
                        height: 100,
                        color: Colors.red.shade300,
                        onPressed: () {},
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [Icon(Icons.home_rounded), Text("DOCK")],
                        )),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: MaterialButton(
                        height: 100,
                        color: Colors.red.shade300,
                        onPressed: () {},
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.arrow_upward_rounded),
                            Text("TAKE OFF")
                          ],
                        )),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
