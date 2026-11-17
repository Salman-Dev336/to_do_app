import 'dart:async';

import 'package:flutter/material.dart';
import 'package:to_do_app/data/database.dart';
import 'package:to_do_app/pages/splash_screen.dart';
import 'package:to_do_app/theme/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final ToDoDatabase database = ToDoDatabase();
  await database.init();

  runApp(MyApp(database: database));
}

class MyApp extends StatefulWidget {
  final ToDoDatabase database;

  const MyApp({super.key, required this.database});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.database.loadDarkMode();
  }

  void _toggleTheme() {
    setState(() => _isDarkMode = !_isDarkMode);
    unawaited(widget.database.saveDarkMode(_isDarkMode));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _lightTheme(),
      darkTheme: _darkTheme(),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      themeAnimationDuration: const Duration(milliseconds: 350),
      home: SplashScreen(
        database: widget.database,
        isDarkMode: _isDarkMode,
        onThemeToggle: _toggleTheme,
      ),
    );
  }
}

ThemeData _lightTheme() {
  final ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: tealColor,
    brightness: Brightness.light,
    surface: Colors.white,
  );

  return ThemeData(
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
    ),
  );
}

ThemeData _darkTheme() {
  final ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF65B8A5),
    brightness: Brightness.dark,
    surface: darkSurfaceColor,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: darkCanvasColor,
    textTheme: ThemeData.dark().textTheme.apply(
      bodyColor: darkInkColor,
      displayColor: darkInkColor,
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      side: const BorderSide(color: Color(0xFF71827D), width: 1.5),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF65B8A5),
      foregroundColor: Color(0xFF102B2B),
      elevation: 5,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: darkSurfaceColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
    ),
  );
}
