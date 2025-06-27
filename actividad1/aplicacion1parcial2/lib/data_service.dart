// lib/data_service.dart
import 'dart:convert';
import 'package:flutter/services.dart';

class DataService {
  static Future<Map<String, dynamic>> loadData() async {
    final String response = await rootBundle.loadString('assets/data.json');
    return json.decode(response);
  }
}