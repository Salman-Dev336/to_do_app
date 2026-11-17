import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoTile extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  final ValueChanged<bool?>? onChanged;
  final VoidCallback onDelete;

  const ToDoTile({
    super.key,
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.zero,
      child: Slidable(
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          extentRatio: 0.27,
          children: [
            SlidableAction(
              onPressed: (_) => onDelete(),
              backgroundColor: const Color(0xFFC9514A),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(20),
            ),
          ],
        ),
        child: Material(
          color: colors.surface,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colors.outlineVariant),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 14,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Checkbox(
                  value: taskCompleted,
                  onChanged: onChanged,
                  activeColor: colors.primary,
                  checkColor: colors.onPrimary,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    taskName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: taskCompleted
                          ? colors.onSurfaceVariant
                          : colors.onSurface,
                      decoration: taskCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.drag_indicator_rounded,
                  color: colors.onSurfaceVariant.withValues(alpha: 0.55),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
