import 'ciantis_context.dart';
import 'developer_logger.dart';
import 'ai_state.dart';

/// NextBestActionEngine
/// ---------------------
/// Determines the single most important task
/// the user should do next based on:
/// - Mode
/// - Task load
/// - Context
/// - Priorities
class NextBestActionEngine {
  static final NextBestActionEngine instance =
      NextBestActionEngine._internal();
  NextBestActionEngine._internal();

  final _context = CiantisContext.instance;

  Map<String, dynamic>? compute() {
    final mode = _context.mode;

    // Placeholder logic — real logic will be added later
    final task = {
      "title": "Example Task",
      "reason": "Placeholder until task engine is implemented"
    };

    AiState.instance.nextBestActionReason =
        "Selected '${task["title"]}' because mode=$mode and placeholder logic.";

    DeveloperLogger.log("Next Best Action computed: ${task["title"]}");

    return task;
  }
}
