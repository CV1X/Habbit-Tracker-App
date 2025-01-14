import 'package:isar/isar.dart';

part 'habit.g.dart';

@Collection()
class Habit {
  // ID
  Id id = Isar.autoIncrement;

  // Name
  late String name;

  // completed days
  List<DateTime> completedDays = [
    // DateTime (year, month, day)
  ];
}
