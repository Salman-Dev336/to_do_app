import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase {
  static const String _boxName = 'todoBox';
  static const String _tasksKey = 'tasks';
  static const String _darkModeKey = 'isDarkMode';

  static const List<List<Object>> _initialTasks = [
    ['Make a tutorial', false],
    ['Do some exercise', false],
    ['Build a todo app', false],
  ];

  late final Box<dynamic> _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox<dynamic>(_boxName);

    if (!_box.containsKey(_tasksKey)) {
      await saveTasks(_initialTasks);
    }
  }

  List<List<Object>> loadTasks() {
    final List<dynamic> savedTasks = _box.get(_tasksKey) as List<dynamic>;
    return savedTasks.map((task) {
      final List<dynamic> values = task as List<dynamic>;
      return <Object>[values[0] as String, values[1] as bool];
    }).toList();
  }

  Future<void> saveTasks(List<List<Object>> tasks) {
    return _box.put(_tasksKey, tasks);
  }

  bool loadDarkMode() => _box.get(_darkModeKey, defaultValue: false) as bool;

  Future<void> saveDarkMode(bool isDarkMode) {
    return _box.put(_darkModeKey, isDarkMode);
  }
}
