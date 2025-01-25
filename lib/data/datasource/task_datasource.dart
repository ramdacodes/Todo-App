import 'dart:convert';

import 'package:todo/data/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskDatasource {
  static final TaskDatasource _instance = TaskDatasource._();

  factory TaskDatasource() => _instance;

  TaskDatasource._();

  static const String _tasksKey = 'tasks';
  static const String _lastIdKey = 'last_task_id';

  Future<SharedPreferences> _prefs() async => SharedPreferences.getInstance();

  Future<void> addTask(Task task) async {
    final prefs = await _prefs();

    // Ambil ID terakhir
    int lastId = prefs.getInt(_lastIdKey) ?? 0;

    // Tingkatkan ID
    lastId++;

    // Set ID baru untuk task
    final newTask = task.copyWith(id: lastId);

    // Simpan ID terakhir ke SharedPreferences
    await prefs.setInt(_lastIdKey, lastId);

    // Ambil data lama
    final List<Task> tasks = await getAllTasks();

    // Tambahkan task baru
    tasks.insert(0, newTask);

    // Simpan ke SharedPreferences
    await prefs.setString(
        _tasksKey, jsonEncode(tasks.map((t) => t.toJson()).toList()));
  }

  Future<List<Task>> getAllTasks() async {
    final prefs = await _prefs();

    // Ambil data JSON dari SharedPreferences
    final String? tasksJson = prefs.getString(_tasksKey);
    if (tasksJson == null) return []; // Jika belum ada data

    // Decode dari JSON ke List<Task>
    final List<dynamic> jsonList = jsonDecode(tasksJson);

    return jsonList.map((json) => Task.fromJson(json)).toList();
  }

  Future<int> updateTask(Task task) async {
    final prefs = await _prefs();

    // Ambil semua data
    final List<Task> tasks = await getAllTasks();

    // Cari index task yang akan diupdate
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index == -1) return 0; // Task tidak ditemukan

    // Update task di list
    tasks[index] = task;

    // Simpan kembali ke SharedPreferences
    await prefs.setString(
        _tasksKey, jsonEncode(tasks.map((t) => t.toJson()).toList()));

    return 1; // Return 1 jika berhasil diupdate
  }

  Future<int> deleteTask(Task task) async {
    final prefs = await _prefs();

    // Ambil semua data
    final List<Task> tasks = await getAllTasks();

    // Hapus task dari list
    tasks.removeWhere((t) => t.id == task.id);

    // Simpan kembali ke SharedPreferences
    await prefs.setString(
        _tasksKey, jsonEncode(tasks.map((t) => t.toJson()).toList()));

    return 1; // Return 1 jika berhasil dihapus
  }

  Future<int> getLastId() async {
    final prefs = await _prefs();
    return prefs.getInt(_lastIdKey) ?? 0;
  }
}
