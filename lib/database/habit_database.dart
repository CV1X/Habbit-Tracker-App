import 'package:flutter/material.dart';
import 'package:habbit_tracker_app/models/app_settings.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/habit.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

//! SETUP

// INIT DATABASE
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();

    isar =
        await Isar.open([HabitSchema, AppSettingsSchema], directory: dir.path);
  }

// Save first launch date
  static Future<void> saveFirstLaunchDate() async {
    final existingSettings = isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

// get first date of app startup
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

// CRUD OPERATIONS

// List of habits

// CRUD for habbits

// DELETE habbit
}
