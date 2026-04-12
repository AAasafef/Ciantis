import 'package:flutter/material.dart';

/// TaskSettingsScreen allows the user to configure:
/// - Task defaults
/// - Intelligence settings
/// - Notification preferences
/// - Planning reminders
///
/// This mirrors Calendar Settings for perfect symmetry.
class TaskSettingsScreen extends StatefulWidget {
  const TaskSettingsScreen({super.key});

  @override
  State<TaskSettingsScreen> createState() => _TaskSettingsScreenState();
}

class _TaskSettingsScreenState extends State<TaskSettingsScreen> {
  // DEFAULTS
  String _defaultPriority = "Medium";
  String _defaultEnergy = "Medium";
  String _defaultFlexibility = "Flexible";

  // INTELLIGENCE
  bool _smartSuggestions = true;
  bool _nextBestAction = true;
  bool _modeAware = true;
  bool _autoSchedule = false;

  // NOTIFICATIONS
  bool _overdueNudges = true;
  bool _dueTodayAlerts = true;
  bool _dailyBriefing = true;
  bool _endOfDaySummary = true;
  bool _modePrompts = true;

  // PLANNING
  bool _dailyPlanningReminder = false;
  bool _weeklyReviewReminder = false;
  bool _monthlyReviewReminder = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Task Settings"),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _sectionTitle("Defaults"),
          _dropdown("Default Priority", _defaultPriority, [
            "Low",
            "Medium",
            "High",
          ], (v) => setState(() => _defaultPriority = v)),

          _dropdown("Default Energy", _defaultEnergy, [
            "Low",
            "Medium",
            "High",
          ], (v) => setState(() => _defaultEnergy = v)),

          _dropdown("Default Flexibility", _defaultFlexibility, [
            "Rigid",
            "Flexible",
          ], (v) => setState(() => _defaultFlexibility = v)),

          const SizedBox(height: 30),

          _sectionTitle("Intelligence"),
          _toggle("Smart Suggestions", _smartSuggestions,
              (v) => setState(() => _smartSuggestions = v)),
          _toggle("Next Best Action", _nextBestAction,
              (v) => setState(() => _nextBestAction = v)),
          _toggle("Mode-Aware Suggestions", _modeAware,
              (v) => setState(() => _modeAware = v)),
          _toggle("Auto-Schedule Tasks", _autoSchedule,
              (v) => setState(() => _autoSchedule = v)),

          const SizedBox(height: 30),

          _sectionTitle("Notifications"),
          _toggle("Overdue Nudges", _overdueNudges,
              (v) => setState(() => _overdueNudges = v)),
          _toggle("Due Today Alerts", _dueTodayAlerts,
              (v) => setState(() => _dueTodayAlerts = v)),
          _toggle("Daily Briefing", _dailyBriefing,
              (v) => setState(() => _dailyBriefing = v)),
          _toggle("End of Day Summary", _endOfDaySummary,
              (v) => setState(() => _endOfDaySummary = v)),
          _toggle("Mode-Aware Prompts", _modePrompts,
              (v) => setState(() => _modePrompts = v)),

          const SizedBox(height: 30),

          _sectionTitle("Planning"),
          _toggle("Daily Planning Reminder", _dailyPlanningReminder,
              (v) => setState(() => _dailyPlanningReminder = v)),
          _toggle("Weekly Review Reminder", _weeklyReviewReminder,
              (v) => setState(() => _weeklyReviewReminder = v)),
          _toggle("Monthly Review Reminder", _monthlyReviewReminder,
              (v) => setState(() => _monthlyReviewReminder = v)),
        ],
      ),
    );
  }

  // -----------------------------
  // SECTION TITLE
  // -----------------------------
  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // -----------------------------
  // DROPDOWN
  // -----------------------------
  Widget _dropdown(
    String label,
    String value,
    List<String> options,
    void Function(String) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 15),
            ),
          ),
          DropdownButton<String>(
            value: value,
            dropdownColor: Colors.black,
            style: const TextStyle(color: Colors.white),
            items: options
                .map((o) => DropdownMenuItem(
                      value: o,
                      child: Text(o),
                    ))
                .toList(),
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
          ),
        ],
      ),
    );
  }

  // -----------------------------
  // TOGGLE
  // -----------------------------
  Widget _toggle(
    String label,
    bool value,
    void Function(bool) onChanged,
  ) {
    return SwitchListTile(
      title: Text(
        label,
        style: const TextStyle(color: Colors.white70),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.tealAccent,
      contentPadding: EdgeInsets.zero,
    );
  }
}
