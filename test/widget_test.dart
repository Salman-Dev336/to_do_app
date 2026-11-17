import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_app/data/database.dart';
import 'package:to_do_app/main.dart';

void main() {
  testWidgets('home screen displays saved tasks', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(database: _FakeToDoDatabase()));
    await tester.pump(const Duration(milliseconds: 1450));
    await tester.pumpAndSettle();

    expect(find.text('My tasks'), findsOneWidget);
    expect(find.text('Make a tutorial'), findsOneWidget);
  });
}

class _FakeToDoDatabase extends ToDoDatabase {
  final List<List<Object>> _tasks = [
    ['Make a tutorial', false],
    ['Do some exercise', false],
    ['Build a todo app', false],
  ];

  @override
  List<List<Object>> loadTasks() =>
      _tasks.map((task) => List<Object>.from(task)).toList();

  @override
  bool loadDarkMode() => false;

  @override
  Future<void> saveTasks(List<List<Object>> tasks) async {
    _tasks
      ..clear()
      ..addAll(tasks.map((task) => List<Object>.from(task)));
  }
}
