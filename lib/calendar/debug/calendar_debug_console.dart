import 'package:flutter/material.dart';

import '../calendar_facade.dart';
import '../analytics/calendar_insights_orchestrator.dart';
import '../export/calendar_export_engine.dart';
import '../export/calendar_backup_service.dart';
import '../sync/calendar_sync_service.dart';

/// CalendarDebugConsole is a developer-only screen that exposes:
/// - Event list
/// - Insights snapshot
/// - Heatmap snapshot
/// - Export (JSON/CSV)
/// - Backup
/// - Sync
///
/// This is not shown to end users.
class CalendarDebugConsole extends StatelessWidget {
  const CalendarDebugConsole({super.key});

  @override
  Widget build(BuildContext context) {
    final events = CalendarFacade.instance.events;
    final insights = CalendarInsightsOrchestrator.instance.latest;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendar Debug Console"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section("Events (${events.length})"),
          ...events.map((e) => _eventTile(e)),

          const SizedBox(height: 20),
          _section("Insights Snapshot"),
          if (insights == null)
            const Text("No insights yet", style: TextStyle(color: Colors.white70))
          else
            Text(
              insights.toString(),
              style: const TextStyle(color: Colors.white70),
            ),

          const SizedBox(height: 20),
          _section("Actions"),
          _actionButton(
            label: "Export JSON",
            onTap: () {
              final json = CalendarExportEngine.instance.exportAllAsJson();
              _show(context, json);
            },
          ),
          _actionButton(
            label: "Export CSV",
            onTap: () {
              final csv = CalendarExportEngine.instance.exportAllAsCsv();
              _show(context, csv);
            },
          ),
          _actionButton(
            label: "Backup Now",
            onTap: () async {
              final ok = await CalendarBackupService.instance.backupNow();
              _toast(context, ok ? "Backup complete" : "Backup failed");
            },
          ),
          _actionButton(
            label: "Restore Backup",
            onTap: () async {
              final ok = await CalendarBackupService.instance.restore();
              _toast(context, ok ? "Restore complete" : "Restore failed");
            },
          ),
          _actionButton(
            label: "Sync All",
            onTap: () async {
              await CalendarSyncService.instance.syncAll();
              _toast(context, "Sync complete");
            },
          ),
        ],
      ),
    );
  }

  // -----------------------------
  // SECTION HEADER
  // -----------------------------
  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.tealAccent,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // -----------------------------
  // EVENT TILE
  // -----------------------------
  Widget _eventTile(event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "${event.title} — ${event.start} → ${event.end}",
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }

  // -----------------------------
  // ACTION BUTTON
  // -----------------------------
  Widget _actionButton({required String label, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.tealAccent.withOpacity(0.2),
          foregroundColor: Colors.tealAccent,
        ),
        child: Text(label),
      ),
    );
  }

  // -----------------------------
  // SHOW RAW OUTPUT
  // -----------------------------
  void _show(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text("Output", style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        );
      },
    );
  }

  // -----------------------------
  // TOAST
  // -----------------------------
  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.tealAccent.shade700,
      ),
    );
  }
}
