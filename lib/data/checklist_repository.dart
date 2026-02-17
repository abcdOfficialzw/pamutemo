import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/checklist_item.dart';

class ChecklistRepository {
  static const _prefsKey = 'am_i_ready_items';

  static const List<ChecklistItem> defaults = [
    ChecklistItem(
      id: 'triangles',
      label: 'Two reflective warning triangles',
      fine: 15,
      checked: false,
    ),
    ChecklistItem(
      id: 'extinguisher',
      label: 'Fire extinguisher (minimum 0.75kg)',
      fine: 15,
      checked: false,
    ),
    ChecklistItem(
      id: 'spare_wheel',
      label: 'Spare wheel and wheel spanner',
      fine: 5,
      checked: false,
    ),
    ChecklistItem(
      id: 'lights_indicators',
      label: 'Working headlights and indicators',
      fine: 30,
      checked: false,
    ),
    ChecklistItem(
      id: 'drivers_licence',
      label: 'Valid driver’s licence',
      fine: 15,
      checked: false,
    ),
    ChecklistItem(
      id: 'licence_disc',
      label: 'Vehicle licence disc displayed',
      fine: 5,
      checked: false,
    ),
    ChecklistItem(
      id: 'insurance',
      label: 'Insurance cover/third-party',
      fine: 15,
      checked: false,
    ),
    ChecklistItem(
      id: 'reflectors',
      label: 'Reflective tape/reflectors clean',
      fine: 5,
      checked: false,
    ),
  ];

  static Future<List<ChecklistItem>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);

    if (raw == null || raw.isEmpty) {
      return defaults.map((item) => item).toList();
    }

    final decoded = jsonDecode(raw) as List<dynamic>;
    final checkedMap = <String, bool>{};
    for (final entry in decoded) {
      if (entry is Map) {
        final id = (entry['id'] ?? '').toString();
        final checked = entry['checked'] == true;
        if (id.isNotEmpty) {
          checkedMap[id] = checked;
        }
      }
    }

    return defaults
        .map((item) => item.copyWith(checked: checkedMap[item.id] ?? false))
        .toList();
  }

  static Future<void> save(List<ChecklistItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      items.map((item) => item.toStorageJson()).toList(),
    );
    await prefs.setString(_prefsKey, encoded);
  }
}
