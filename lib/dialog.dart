import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/capture.dart';
import 'package:flutter_application_2/test.dart';
import 'package:flutter_svg/svg.dart';
import 'package:video_player/video_player.dart';

class DialogPage extends StatefulWidget {
  const DialogPage({super.key});

  @override
  State<DialogPage> createState() => _DialogPageState();
}

class _DialogPageState extends State<DialogPage> {
  int x = 0;
  int y = 0;
  bool _isLoading = false;
  CaptureResult? _lastResult;
  final CrackDetectionService _service = CrackDetectionService();
  @override
  @override
  void initState() {
    super.initState();
  }

  Future<void> _capture(int x, int y) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _service.captureAndAnalyze(x, y);
      setState(() {
        _lastResult = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
              icon: SvgPicture.asset(
                "assets/xmark.svg",
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
              Center(
                child: Container(
                  height: 250,
                  child: AspectRatio(
                    aspectRatio: 1,
                    // Use the VideoPlayer widget to display the video.
                    child: ClipRRect(child: VideoScreen()),
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: MaterialButton(
                        height: 50,
                        color: Colors.white,
                        onPressed: () {
                          y += 1;
                          _capture(x, y);
                        },
                        child: Text("^")),
                  ),
                  Expanded(
                    child: MaterialButton(
                        height: 50,
                        color: Colors.white,
                        onPressed: () {
                          y -= 1;
                          _capture(x, y);
                        },
                        child: Text("v")),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: MaterialButton(
                        height: 50,
                        color: Colors.white,
                        onPressed: () {
                          x -= 1;
                          _capture(x, y);
                        },
                        child: Text("<")),
                  ),
                  Expanded(
                    child: MaterialButton(
                        height: 50,
                        color: Colors.white,
                        onPressed: () {
                          x += 1;
                          _capture(x, y);
                        },
                        child: Text(">")),
                  ),
                ],
              ),
              Text(
                "Metres: " + x.toString() + "," + y.toString(),
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Expanded(
                child: MaterialButton(
                    height: 50,
                    color: Colors.white,
                    onPressed: () {
                      _service.fetchMergedImage();
                    },
                    child: Text("DONE")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
