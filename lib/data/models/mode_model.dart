class ModeModel {
  final String id;
  final String name;
  final String description;

  // UI behavior
  final String theme; // calm, focus, recovery, night, overload, etc.
  final bool reduceNotifications;
  final bool softenUI;
  final bool highlightFocusAreas;

  // Emotional intelligence
  final int emotionalThreshold; // when to suggest this mode
  final int fatigueThreshold;

  ModeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.theme,
    required this.reduceNotifications,
    required this.softenUI,
    required this.highlightFocusAreas,
    required this.emotionalThreshold,
    required this.fatigueThreshold,
  });
}
