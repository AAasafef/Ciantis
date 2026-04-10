/// Task Modes define the different mental, emotional, and productivity
/// states the user can operate in.
///
/// Each mode has:
/// - name
/// - description
/// - strengths
/// - weaknesses
/// - best task types
/// - avoid task types
/// - activation conditions (lightweight)
///
/// The Mode Engine will use these definitions to:
/// - select the best mode
/// - filter tasks
/// - rank tasks within a mode
/// - generate explanations
/// - generate narratives
/// - adapt to user context
class TaskMode {
  final String id;
  final String name;
  final String description;

  final List<String> strengths;
  final List<String> weaknesses;

  final List<String> bestFor;
  final List<String> avoidFor;

  final Map<String, dynamic> activationRules;

  const TaskMode({
    required this.id,
    required this.name,
    required this.description,
    required this.strengths,
    required this.weaknesses,
    required this.bestFor,
    required this.avoidFor,
    required this.activationRules,
  });
}

class TaskModes {
  // -----------------------------
  // FOCUS MODE
  // -----------------------------
  static const focus = TaskMode(
    id: "focus",
    name: "Focus Mode",
    description:
        "Deep concentration mode for tasks requiring attention, clarity, and uninterrupted effort.",
    strengths: [
      "High concentration",
      "Strong attention to detail",
      "Good for long tasks",
      "Good for complex tasks",
    ],
    weaknesses: [
      "Not ideal when fatigued",
      "Emotionally heavy tasks may feel overwhelming",
    ],
    bestFor: [
      "High difficulty tasks",
      "High priority tasks",
      "Long tasks",
      "Analytical tasks",
    ],
    avoidFor: [
      "Emotionally heavy tasks",
      "High fatigue tasks",
      "Quick wins",
    ],
    activationRules: {
      "energyMin": 6,
      "fatigueMax": 5,
      "emotionalMax": 6,
    },
  );

  // -----------------------------
  // LIGHT MODE
  // -----------------------------
  static const light = TaskMode(
    id: "light",
    name: "Light Mode",
    description:
        "Gentle mode for low‑effort tasks when energy or emotional bandwidth is limited.",
    strengths: [
      "Low resistance",
      "Good for momentum",
      "Emotionally safe",
    ],
    weaknesses: [
      "Not ideal for high‑impact tasks",
      "May avoid important work",
    ],
    bestFor: [
      "Quick wins",
      "Emotionally light tasks",
      "Low fatigue tasks",
      "Short tasks",
    ],
    avoidFor: [
      "High difficulty tasks",
      "High stress tasks",
    ],
    activationRules: {
      "energyMax": 6,
      "emotionalMax": 6,
    },
  );

  // -----------------------------
  // POWER MODE
  // -----------------------------
  static const power = TaskMode(
    id: "power",
    name: "Power Mode",
    description:
        "High‑energy, high‑momentum mode for knocking out tasks rapidly.",
    strengths: [
      "Fast execution",
      "High motivation",
      "Good for batching tasks",
    ],
    weaknesses: [
      "May rush complex tasks",
      "Not ideal for emotional tasks",
    ],
    bestFor: [
      "Short tasks",
      "Medium difficulty tasks",
      "Momentum tasks",
      "Batching tasks",
    ],
    avoidFor: [
      "Emotionally heavy tasks",
      "High fatigue tasks",
    ],
    activationRules: {
      "energyMin": 7,
      "fatigueMax": 4,
    },
  );

  // -----------------------------
  // RESET MODE
  // -----------------------------
  static const reset = TaskMode(
    id: "reset",
    name: "Reset Mode",
    description:
        "A restorative mode for clearing mental clutter, organizing, and reducing stress.",
    strengths: [
      "Stress reduction",
      "Emotional grounding",
      "Good for cleanup tasks",
    ],
    weaknesses: [
      "Not ideal for high‑impact tasks",
      "Not ideal for long tasks",
    ],
    bestFor: [
      "Organizing",
      "Cleaning",
      "Administrative tasks",
      "Low emotional load tasks",
    ],
    avoidFor: [
      "High difficulty tasks",
      "High priority tasks",
    ],
    activationRules: {
      "stressMin": 6,
      "burnoutMin": 5,
    },
  );

  // -----------------------------
  // EMOTIONAL MODE
  // -----------------------------
  static const emotional = TaskMode(
    id: "emotional",
    name: "Emotional Mode",
    description:
        "A mode for tasks that require emotional presence, reflection, or vulnerability.",
    strengths: [
      "Emotional clarity",
      "Good for relationship tasks",
      "Good for personal reflection",
    ],
    weaknesses: [
      "Not ideal when fatigued",
      "Not ideal for analytical tasks",
    ],
    bestFor: [
      "Journaling",
      "Relationship tasks",
      "Therapeutic tasks",
      "Personal reflection",
    ],
    avoidFor: [
      "High difficulty tasks",
      "High stress tasks",
    ],
    activationRules: {
      "emotionalMin": 7,
    },
  );

  // -----------------------------
  // ALL MODES
  // -----------------------------
  static const all = [
    focus,
    light,
    power,
    reset,
    emotional,
  ];
}
