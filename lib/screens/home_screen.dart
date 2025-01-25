import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/config/config.dart';
import 'package:todo/data/data.dart';
import 'package:todo/providers/providers.dart';
import 'package:todo/utils/utils.dart';
import 'package:todo/widgets/widgets.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  static HomeScreen builder(
    BuildContext context,
    GoRouterState state,
  ) =>
      const HomeScreen();
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceSize = context.deviceSize;
    final date = ref.watch(dateProvider);
    final taskState = ref.watch(tasksProvider);
    final inCompletedTasks = _incompltedTask(taskState.tasks, ref);
    final completedTasks = _compltedTask(taskState.tasks, ref);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colorScheme.primary,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: deviceSize.height * 0.3,
                child: AppBackground(
                  headerHeight: deviceSize.height * 0.3,
                  header: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () => Helpers.selectDate(context, ref),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              DisplayWhiteText(
                                text: Helpers.dateFormatter(date),
                                size: 20,
                                fontWeight: FontWeight.normal,
                              ),
                              const Gap(10),
                              const Icon(
                                Icons.calendar_month,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                        const DisplayWhiteText(
                            text: 'To-Do List App', size: 30),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tugas Belum Selesai',
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(20),
                    DisplayListOfTasks(
                      tasks: inCompletedTasks,
                    ),
                    const Gap(20),
                    Text(
                      'Tugas Selesai',
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(20),
                    DisplayListOfTasks(
                      isCompletedTasks: true,
                      tasks: completedTasks,
                    ),
                    const Gap(20),
                    ElevatedButton(
                      onPressed: () => context.push(RouteLocation.createTask),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colorScheme.primary,
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: DisplayWhiteText(
                          text: 'Tambah Tugas',
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Task> _incompltedTask(List<Task> tasks, WidgetRef ref) {
    final date = ref.watch(dateProvider);
    final List<Task> filteredTask = [];

    for (var task in tasks) {
      if (!task.isCompleted) {
        final isTaskDay = Helpers.isTaskFromSelectedDate(task, date);
        if (isTaskDay) {
          filteredTask.add(task);
        }
      }
    }
    return filteredTask;
  }

  List<Task> _compltedTask(List<Task> tasks, WidgetRef ref) {
    final date = ref.watch(dateProvider);
    final List<Task> filteredTask = [];

    for (var task in tasks) {
      if (task.isCompleted) {
        final isTaskDay = Helpers.isTaskFromSelectedDate(task, date);
        if (isTaskDay) {
          filteredTask.add(task);
        }
      }
    }
    return filteredTask;
  }
}
