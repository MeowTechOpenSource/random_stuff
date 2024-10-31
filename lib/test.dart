import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:async';

class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  static const String VIDEO_STREAM_URL = 'http://192.168.0.250:5000/video_feed';
  StreamController<Uint8List>? _streamController;
  Timer? _frameTimer;
  bool _isProcessing = false;
  bool _isFirstFrame = true;

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<Uint8List>.broadcast();
    _startVideoStream();
  }

  void _startVideoStream() async {
    try {
      final response = await http.Client()
          .send(http.Request('GET', Uri.parse(VIDEO_STREAM_URL)));

      List<int> buffer = [];
      bool isHeaderFound = false;

      response.stream.listen((List<int> data) {
        buffer.addAll(data);

        while (buffer.isNotEmpty) {
          if (!isHeaderFound) {
            // Look for the JPEG header (0xFF 0xD8)
            for (int i = 0; i < buffer.length - 1; i++) {
              if (buffer[i] == 0xFF && buffer[i + 1] == 0xD8) {
                buffer = buffer.sublist(i);
                isHeaderFound = true;
                break;
              }
            }
            if (!isHeaderFound) {
              buffer.clear();
              return;
            }
          }

          // Look for the JPEG footer (0xFF 0xD9)
          for (int i = 0; i < buffer.length - 1; i++) {
            if (buffer[i] == 0xFF && buffer[i + 1] == 0xD9) {
              // We found a complete JPEG image
              List<int> frameData = buffer.sublist(0, i + 2);
              if (mounted) {
                _streamController?.add(Uint8List.fromList(frameData));
                _isFirstFrame = false;
              }
              buffer = buffer.sublist(i + 2);
              isHeaderFound = false;
              break;
            }
          }

          // If we didn't find a footer, wait for more data
          if (isHeaderFound) break;
        }
      }, onError: (error) {
        print('Error streaming video: $error');
      });
    } catch (e) {
      print('Failed to connect to video stream: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Uint8List>(
      stream: _streamController?.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        return Image.memory(
          snapshot.data!,
          gaplessPlayback: true,
          filterQuality: FilterQuality.low,
        );
      },
    );
  }

  @override
  void dispose() {
    _frameTimer?.cancel();
    _streamController?.close();
    super.dispose();
  }
}
