import 'package:flutter/material.dart';
import 'package:habbit_tracker_app/models/app_settings.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/habit.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

//////////////! SETUP

////////////////////! INIT DATABASE
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();

    isar =
        await Isar.open([HabitSchema, AppSettingsSchema], directory: dir.path);
  }

////////////////////! Save first launch date
  static Future<void> saveFirstLaunchDate() async {
    final existingSettings = isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

//////////////! get first date of app startup
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

//////////////////! CRUD OPERATIONS

// List of habits
  final List<Habit> currentHabits = [];

// CREATE habit
  Future<void> addHabit(String habitName) async {
    // create habit
    final newHabit = Habit()..name = habitName;

    // save to db
    await isar.writeTxn(() => isar.habits.put(newHabit));

    readHabits();
  }

  // READ habits
  Future<void> readHabits() async {
    List<Habit> fetchedHabits = await isar.habits.where().findAll();
    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);

    // updateUI
    notifyListeners();
  }

  // UPDATE habit

  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    final habit = await isar.habits.get(id);

    if (habit != null) {
      await isar.writeTxn(() async {
        if (isCompleted && !habit.completedDays.contains(DateTime.now())) {
          final today = DateTime.now();
          habit.completedDays.add(DateTime(today.year, today.month, today.day));
        } else {
          habit.completedDays.removeWhere((date) =>
              date.year == DateTime.now().year &&
              date.month == DateTime.now().month &&
              date.day == DateTime.now().day);
        }
        // save to db
        await isar.habits.put(habit);
      });
    }

    readHabits();

    // update habit name

    Future<void> updateHabitName(int id, String newName) async {
      final habit = await isar.habits.get(id);

      if (habit != null) {
        await isar.writeTxn(() async {
          habit.name = newName;
          // save to db
          await isar.habits.put(habit);
        });
      }

      readHabits();
    }

    // DELETE habit
    Future<void> deleteHabit(int id) async {
      await isar.writeTxn(() async {
        await isar.habits.delete(id);
      });

      readHabits();
    }
  }
}
