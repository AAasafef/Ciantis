import 'package:flutter/material.dart';

import '../task_facade.dart';
import '../models/task.dart';
import '../logic/task_suggestions_engine.dart';
import 'task_tile.dart';

/// SmartSuggestionsPanel is a lightweight UI component that shows:
/// - Next Best Action
/// - Top 5 suggestions
/// - Mode-aware suggestions (later)
///
/// This is used in:
/// - Quick Actions
/// - Mode Engine overlays
/// - Bottom sheets
class SmartSuggestionsPanel extends StatelessWidget {
  final String? mode; // "focus", "fatigue", "recovery", or null

  const SmartSuggestionsPanel({super.key, this.mode});

  @override
  Widget build(BuildContext context) {
    final facade = TaskFacade.instance;
    final suggest = TaskSuggestionsEngine.instance;

    final now = DateTime.now();

    // Mode-aware if provided
    final List<Task> suggestions = mode != null
        ? suggest.modeAwareSuggestions(
            tasks: facade.all,
            now: now,
            mode: mode!,
          )
        : suggest.suggestions(facade.all, now);

    final next = suggest.nextBestAction(facade.all, now);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TITLE
          Text(
            mode == null
                ? "Smart Suggestions"
                : "Suggestions (${mode!.toUpperCase()})",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 20),

          // NEXT BEST ACTION
          if (next != null) ...[
            const Text(
              "Next Best Action",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            TaskTile(task: next),
            const SizedBox(height: 30),
          ],

          // TOP SUGGESTIONS
          const Text(
            "Top Suggestions",
            style: TextStyle(
              color: Colors.white54,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),

          if (suggestions.isEmpty)
            const Text(
              "No suggestions right now",
              style: TextStyle(color: Colors.white38),
            )
          else
            Column(
              children: suggestions
                  .map((t) => TaskTile(task: t))
                  .toList(),
            ),
        ],
      ),
    );
  }
}
