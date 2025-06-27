import 'dart:convert';
import 'package:flutter/services.dart';

class ImageService {
  static Future<List<Map<String, dynamic>>> loadImagesData() async {
    final String response = await rootBundle.loadString('assets/imagesdata.json');
    return List<Map<String, dynamic>>.from(json.decode(response));
  }
}