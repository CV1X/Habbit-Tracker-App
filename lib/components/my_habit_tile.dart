import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTile extends StatelessWidget {
  final bool isCompleted;
  final String text;
  final void Function(bool?) onChanged;
  final void Function(BuildContext)? editHabit;
  final void Function(BuildContext)? deleteHabit;
  const HabitTile({
    super.key,
    required this.isCompleted,
    required this.text,
    required this.onChanged,
    this.editHabit,
    this.deleteHabit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            // edit button
            SlidableAction(
              onPressed: editHabit,
              backgroundColor: Colors.grey.shade800,
              icon: Icons.settings,
              borderRadius: BorderRadius.circular(10),
            ),

            // delete button
            SlidableAction(
              onPressed: deleteHabit,
              backgroundColor: Colors.red,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(10),
            )
          ],
        ),
        child: GestureDetector(
          onTap: () {
            if (onChanged != null) {
              onChanged(!isCompleted);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: isCompleted
                  ? Colors.green
                  : Theme.of(context).colorScheme.secondary,
            ),
            padding: const EdgeInsets.all(12),
            child: ListTile(
              title: Text(text,
                  style: TextStyle(
                    color: isCompleted
                        ? Theme.of(context).colorScheme.tertiary
                        : Theme.of(context).colorScheme.inversePrimary,
                  )),
              leading: Checkbox(
                value: isCompleted,
                onChanged: onChanged,
                activeColor: Colors.green,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
