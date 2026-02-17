import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/fine.dart';

class FinesRepository {
  static Future<List<Fine>> loadFines() async {
    final raw = await rootBundle.loadString('assets/fines.json');
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => Fine.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
