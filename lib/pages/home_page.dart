import 'package:flutter/material.dart';
import 'package:to_do_app/data/database.dart';
import 'package:to_do_app/theme/app_colors.dart';
import 'package:to_do_app/utils/dialog_box.dart';
import 'package:to_do_app/utils/todo_tile.dart';

class HomePage extends StatefulWidget {
  final ToDoDatabase database;
  final VoidCallback onThemeToggle;

  const HomePage({
    super.key,
    required this.database,
    required this.onThemeToggle,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  late final List<List<Object>> toDoList;

  @override
  void initState() {
    super.initState();
    toDoList = widget.database.loadTasks();
  }

  int get _completedCount => toDoList.where((task) => task[1] as bool).length;

  Future<void> checkBoxChanged(bool? value, int index) async {
    setState(() {
      toDoList[index][1] = value ?? false;
    });
    await widget.database.saveTasks(toDoList);
  }

  Future<void> deleteTask(int index) async {
    setState(() {
      toDoList.removeAt(index);
    });
    await widget.database.saveTasks(toDoList);
  }

  Future<void> saveNewTask() async {
    final String task = _controller.text.trim();
    if (task.isEmpty) return;

    setState(() {
      toDoList.add([task, false]);
      _controller.clear();
    });
    final Future<void> saveOperation = widget.database.saveTasks(toDoList);
    Navigator.of(context).pop();
    await saveOperation;
  }

  void createTask() {
    _controller.clear();
    showDialog<void>(
      context: context,
      builder: (context) => DialogBox(
        controller: _controller,
        onSave: saveNewTask,
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int totalTasks = toDoList.length;
    final double progress = totalTasks == 0 ? 0 : _completedCount / totalTasks;
    final ColorScheme colors = Theme.of(context).colorScheme;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: createTask,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add task'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MAKE TODAY COUNT',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: colors.primary,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.6,
                              ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'My tasks',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.8,
                              ),
                        ),
                      ],
                    ),
                  ),
                  IconButton.filledTonal(
                    onPressed: widget.onThemeToggle,
                    tooltip: isDarkMode
                        ? 'Switch to light mode'
                        : 'Switch to dark mode',
                    icon: Icon(
                      isDarkMode
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              _ProgressCard(
                completed: _completedCount,
                total: totalTasks,
                progress: progress,
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Text(
                    'Your list',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colors.secondaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$totalTasks ${totalTasks == 1 ? 'task' : 'tasks'}',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: colors.onSecondaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Expanded(
                child: totalTasks == 0
                    ? const _EmptyTasks()
                    : ListView.separated(
                        padding: const EdgeInsets.only(bottom: 84),
                        itemCount: totalTasks,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 11),
                        itemBuilder: (context, index) => ToDoTile(
                          taskName: toDoList[index][0] as String,
                          taskCompleted: toDoList[index][1] as bool,
                          onDelete: () => deleteTask(index),
                          onChanged: (value) => checkBoxChanged(value, index),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final int completed;
  final int total;
  final double progress;

  const _ProgressCard({
    required this.completed,
    required this.total,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF245B57), Color(0xFF193E4A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: tealColor.withValues(alpha: 0.18),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DAILY PROGRESS',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white70,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  completed == total && total > 0
                      ? 'All done.\nAmazing work!'
                      : 'Small steps,\nbig progress.',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  '$completed of $total completed',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 68,
            height: 68,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox.expand(
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 6,
                    strokeCap: StrokeCap.round,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation<Color>(goldColor),
                  ),
                ),
                Text(
                  '${(progress * 100).round()}%',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyTasks extends StatelessWidget {
  const _EmptyTasks();

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: colors.secondaryContainer,
              borderRadius: BorderRadius.circular(26),
            ),
            child: Icon(
              Icons.checklist_rounded,
              size: 38,
              color: colors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Nothing on your list',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            'Tap “Add task” to plan your next step.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
