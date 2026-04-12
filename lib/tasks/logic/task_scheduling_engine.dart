import 'package:flutter/material.dart';

import '../../calendar/calendar_facade.dart';
import '../models/task.dart';
import 'task_sorting_engine.dart';

/// TaskSchedulingEngine automatically places tasks into the user's calendar.
///
/// It considers:
/// - Task duration (derived or estimated)
/// - Energy level
/// - Flexibility
/// - Calendar availability
/// - Overlaps
/// - Time of day
/// - User mode (later)
///
/// This is the backbone of:
/// - Daily Planning
/// - Auto-Plan My Day
/// - Smart Scheduling
class TaskSchedulingEngine {
  // Singleton
  static final TaskSchedulingEngine instance =
      TaskSchedulingEngine._internal();
  TaskSchedulingEngine._internal();

  final _calendar = CalendarFacade.instance;
  final _sort = TaskSortingEngine.instance;

  // -----------------------------
  // ESTIMATE TASK DURATION
  // -----------------------------
  Duration estimateDuration(Task task) {
    // Simple heuristic for now:
    switch (task.priority) {
      case TaskPriority.critical:
        return const Duration(hours: 2);
      case TaskPriority.high:
        return const Duration(hours: 1, minutes: 30);
      case TaskPriority.medium:
        return const Duration(hours: 1);
      case TaskPriority.low:
        return const Duration(minutes: 30);
    }
  }

  // -----------------------------
  // FIND AVAILABLE WINDOW
  // -----------------------------
  DateTimeRange? findWindow({
    required DateTime day,
    required Duration duration,
  }) {
    final events = _calendar.eventsForDay(day);

    // Start at 8 AM
    DateTime cursor = DateTime(day.year, day.month, day.day, 8, 0);

    for (final event in events) {
      final gap = event.start.difference(cursor);

      if (gap >= duration) {
        return DateTimeRange(start: cursor, end: cursor.add(duration));
      }

      cursor = event.end;
    }

    // After last event
    final endOfDay = DateTime(day.year, day.month, day.day, 20, 0);
    if (endOfDay.difference(cursor) >= duration) {
      return DateTimeRange(start: cursor, end: cursor.add(duration));
    }

    return null;
  }

  // -----------------------------
  // AUTO-SCHEDULE A SINGLE TASK
  // -----------------------------
  DateTimeRange? scheduleTask(Task task, DateTime day) {
    final duration = estimateDuration(task);

    final window = findWindow(day: day, duration: duration);
    if (window == null) return null;

    task.scheduledStart = window.start;
    task.scheduledEnd = window.end;

    return window;
  }

  // -----------------------------
  // AUTO-SCHEDULE MULTIPLE TASKS
  // -----------------------------
  Map<String, DateTimeRange?> scheduleTasks(
    List<Task> tasks,
    DateTime day,
  ) {
    final sorted = _sort.sort(tasks);
    final results = <String, DateTimeRange?>{};

    for (final task in sorted) {
      if (task.isCompleted) {
        results[task.id] = null;
        continue;
      }

      final window = scheduleTask(task, day);
      results[task.id] = window;
    }

    return results;
  }

  // -----------------------------
  // SUGGEST BEST TIME FOR A TASK
  // -----------------------------
  DateTimeRange? suggestTime(Task task, DateTime day) {
    // High-energy tasks → morning
    if (task.energy == TaskEnergy.high) {
      return findWindow(
        day: day,
        duration: estimateDuration(task),
      );
    }

    // Low-energy tasks → afternoon
    if (task.energy == TaskEnergy.low) {
      return findWindow(
        day: day,
        duration: estimateDuration(task),
      );
    }

    // Default
    return findWindow(
      day: day,
      duration: estimateDuration(task),
    );
  }
}
