//  given habit days of completion day
// is the habit completed day

import '../models/habit.dart';

bool isHabitCompletedToday(List<DateTime> completedDays) {
  final today = DateTime.now();

  return completedDays.any((date) =>
      date.year == today.year &&
      date.month == today.month &&
      date.day == today.day);
}

// prepare heatmap dataset

Map<DateTime, int> prepareHeatMapDataset(List<Habit> habits) {
  Map<DateTime, int> datasets = {};

  // habits.forEach((habit) {
  //   habit.completedDays.forEach((date) {
  //     final normalizedData = DateTime(date.year, date.month, date.day);

  //     if (datasets.containsKey(normalizedData)) {
  //       datasets[normalizedData] = datasets[normalizedData]! + 1;
  //       return;
  //     } else {
  //       datasets[normalizedData] = 1;
  //     }
  //   });
  // });

  for (var habit in habits) {
    for (var date in habit.completedDays) {
      final normalizedData = DateTime(date.year, date.month, date.day);

      if (datasets.containsKey(normalizedData)) {
        datasets[normalizedData] = datasets[normalizedData]! + 1;
      } else {
        datasets[normalizedData] = 1;
      }
    }
  }

  return datasets;
}
