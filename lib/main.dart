import 'package:flutter/material.dart';
import 'package:to_do_app/data/database.dart';
import 'package:to_do_app/pages/home_page.dart';
import 'package:to_do_app/theme/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final ToDoDatabase database = ToDoDatabase();
  await database.init();

  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final ToDoDatabase database;

  const MyApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: tealColor,
      brightness: Brightness.light,
      surface: Colors.white,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: canvasColor,
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: inkColor,
          displayColor: inkColor,
        ),
        checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          side: const BorderSide(color: Color(0xFFB8C3BD), width: 1.5),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: tealColor,
          foregroundColor: Colors.white,
          elevation: 5,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
      ),
      home: HomePage(database: database),
    );
  }
}
