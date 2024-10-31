import 'dart:convert';

import 'package:http/http.dart' as http;
import 'constants.dart';

class CaptureResult {
  final int numCracks;
  final List<String> cropArea;
  final String imageUrl;
  final int x;
  final int y;

  CaptureResult({
    required this.numCracks,
    required this.cropArea,
    required this.imageUrl,
    required this.x,
    required this.y,
  });
}

class CrackDetectionService {
  static const String BASE_URL = 'http://192.168.0.250:5000';

  // Store results with location as key
  final Map<String, CaptureResult> captureResults = {};

  Future<CaptureResult> captureAndAnalyze(int x, int y) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/capture'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'location': {'x': x, 'y': y}
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<String> cropAreas = List<String>.from(data['crop_area']);
        for (String area in cropAreas) {
          combinedList.add([x, y, area]);
        }

        final result = CaptureResult(
          numCracks: (data['num_cracks'] as num).toInt(),
          cropArea: List<String>.from(data['crop_area']),
          imageUrl: data['image_url'],
          x: x,
          y: y,
        );
        crackNums += (data['num_cracks'] as num).toInt();
        // Store result with location key
        captureResults['$x,$y'] = result;

        return result;
      } else {
        throw Exception('Failed to capture image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during capture: $e');
    }
  }

  CaptureResult? getResultForLocation(double x, double y) {
    return captureResults['$x,$y'];
  }

  List<CaptureResult> getAllResults() {
    return captureResults.values.toList();
  }

  Future<void> fetchMergedImage() async {
    final response = await http.get(Uri.parse(BASE_URL + '/merge'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      mergedImageUrl = data['merged_image'];
    } else {
      throw Exception('Failed to load merged image');
    }
  }
}
