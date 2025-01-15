import 'package:flutter/material.dart';
import 'package:habbit_tracker_app/pages/home_page.dart';
import 'package:provider/provider.dart';

import 'database/habit_database.dart';
import 'pages/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HabitDatabase.initialize();
  await HabitDatabase.saveFirstLaunchDate();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ChangeNotifierProvider(create: (context) => HabitDatabase()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
