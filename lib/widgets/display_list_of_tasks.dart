import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/data/data.dart';
import 'package:todo/providers/providers.dart';
import 'package:todo/utils/utils.dart';
import 'package:todo/widgets/widgets.dart';

class DisplayListOfTasks extends ConsumerWidget {
  const DisplayListOfTasks({
    super.key,
    this.isCompletedTasks = false,
    required this.tasks,
  });
  final bool isCompletedTasks;
  final List<Task> tasks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceSize = context.deviceSize;
    final height =
        isCompletedTasks ? deviceSize.height * 0.25 : deviceSize.height * 0.3;
    final emptyTasksAlert = isCompletedTasks
        ? 'Tidak ada tugas yang selesai!'
        : 'Tidak ada tugas yang belum selesai!';

    return CommonContainer(
      height: height,
      child: tasks.isEmpty
          ? Center(
              child: Text(
                emptyTasksAlert,
                style: context.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            )
          : ListView.separated(
              shrinkWrap: true,
              itemCount: tasks.length,
              padding: EdgeInsets.zero,
              itemBuilder: (ctx, index) {
                final task = tasks[index];

                return InkWell(
                  onLongPress: () async {
                    await AppAlerts.showAlertDeleteDialog(
                      context: context,
                      ref: ref,
                      task: task,
                    );
                  },
                  onTap: () async {
                    await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (ctx) {
                        return DraggableScrollableSheet(
                          expand: false,
                          initialChildSize: 0.7,
                          minChildSize: 0.5,
                          maxChildSize: 0.9,
                          builder: (ctx, scrollController) {
                            return TaskDetails(task: task);
                          },
                        );
                      },
                    );
                  },
                  child: TaskTile(
                    task: task,
                    onCompleted: (value) async {
                      await ref
                          .read(tasksProvider.notifier)
                          .updateTask(task)
                          .then((value) {
                        AppAlerts.displaySnackbar(
                          context,
                          task.isCompleted
                              ? 'Tugas ditandai belum selesai'
                              : 'Tugas ditandai selesai',
                        );
                      });
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(
                thickness: 1.5,
              ),
            ),
    );
  }
}
