import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/my_drawer.dart';
import '../components/my_habit_tile.dart';
import '../components/my_heat_map.dart';
import '../database/habit_database.dart';
import '../models/habit.dart';
import '../util/habit_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    // read habits from db
    Provider.of<HabitDatabase>(context, listen: false).readHabits();

    // TODO: implement initState
    super.initState();
  }

  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: _textController,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
          decoration: InputDecoration(
            hintText: 'Enter habit name',
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              String newHabitName = _textController.text;

              // save to db
              context.read<HabitDatabase>().addHabit(newHabitName);

              // pop box
              Navigator.pop(context);

              // clear text field
              _textController.clear();
            },
            child: const Text('Save'),
          ),

          // cancel button
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              _textController.clear();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // check habit on of
  void checkHabitOnOff(bool? value, Habit habit) {
    // update habit
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

// edit habit
  void editHabitBox(Habit habit) {
    _textController.text = habit.name;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: _textController,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
          decoration: InputDecoration(
            hintText: 'Enter habit name',
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        actions: [
          // save
          MaterialButton(
            onPressed: () {
              String newHabitName = _textController.text;

              // save to db
              context
                  .read<HabitDatabase>()
                  .updateHabitName(habit.id, newHabitName);

              // pop box
              Navigator.pop(context);

              // clear text field
              _textController.clear();
            },
            child: const Text('Save'),
          ),

          // cancel button
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              _textController.clear();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

// delete habit
  void deleteHabit(Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text("Are you sure you want to delete this habit?"),
        actions: [
          // delete
          MaterialButton(
            onPressed: () {
              // delete from db
              context.read<HabitDatabase>().deleteHabit(habit.id);

              // pop box
              Navigator.pop(context);

              // clear text field
              _textController.clear();
            },
            child: const Text('Delete'),
          ),

          // cancel button
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              _textController.clear();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 1,
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        children: [
          // heat map
          _buildHeatMap(),

          // habit list
          _buildHabitList(),
        ],
      ),
    );
  }

// build heat map
  Widget _buildHeatMap() {
    final habitDatabase = context.watch<HabitDatabase>();

    List<Habit> currentHabits = habitDatabase.currentHabits;

    return FutureBuilder<DateTime?>(
      future: habitDatabase.getFirstLaunchDate(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (snapshot.hasData && snapshot.data != null) {
          return MyHeadMap(
            startDate: snapshot.data!,
            datasets: prepareHeatMapDataset(currentHabits),
          );
        } else {
          return Container(
            child: Text("No data available for heatmap"),
          );
        }
      },
    );
  }

  // build habit list
  Widget _buildHabitList() {
    final habitDatabase = context.watch<HabitDatabase>();

    List<Habit> currentHabits = habitDatabase.currentHabits;

    return ListView.builder(
      itemCount: currentHabits.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        // get habit
        final habit = currentHabits[index];

        // check if its completed
        bool isCompletedToday = isHabitCompletedToday(habit.completedDays);

        return HabitTile(
          isCompleted: isCompletedToday,
          text: habit.name,
          onChanged: (value) => checkHabitOnOff(value, habit),
          editHabit: (context) => editHabitBox(habit),
          deleteHabit: (context) => deleteHabit(habit),
        );
      },
    );
  }
}
