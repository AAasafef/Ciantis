import 'package:flutter/widgets.dart';
import '../data/services/task_service.dart';
import '../data/services/calendar_event_service.dart';
import '../data/services/appointment_service.dart';
import '../data/services/client_service.dart';
import '../data/services/habit_service.dart';
import '../data/services/routine_service.dart';
import '../data/services/service_service.dart';
import '../data/services/mode_engine_service.dart';

class AppProviders extends StatefulWidget {
  final Widget child;

  const AppProviders({super.key, required this.child});

  @override
  State<AppProviders> createState() => _AppProvidersState();
}

class _AppProvidersState extends State<AppProviders> {
  late final TaskService taskService;
  late final CalendarEventService calendarEventService;
  late final AppointmentService appointmentService;
  late final ClientService clientService;
  late final HabitService habitService;
  late final RoutineService routineService;
  late final ServiceService serviceService;
  late final ModeEngineService modeEngineService;

  @override
  void initState() {
    super.initState();
    taskService = TaskService();
    calendarEventService = CalendarEventService();
    appointmentService = AppointmentService();
    clientService = ClientService();
    habitService = HabitService();
    routineService = RoutineService();
    serviceService = ServiceService();
    modeEngineService = ModeEngineService();
  }

  @override
  Widget build(BuildContext context) {
    return _AppServiceScope(
      taskService: taskService,
      calendarEventService: calendarEventService,
      appointmentService: appointmentService,
      clientService: clientService,
      habitService: habitService,
      routineService: routineService,
      serviceService: serviceService,
      modeEngineService: modeEngineService,
      child: widget.child,
    );
  }
}

class _AppServiceScope extends InheritedWidget {
  final TaskService taskService;
  final CalendarEventService calendarEventService;
  final AppointmentService appointmentService;
  final ClientService clientService;
  final HabitService habitService;
  final RoutineService routineService;
  final ServiceService serviceService;
  final ModeEngineService modeEngineService;

  const _AppServiceScope({
    required this.taskService,
    required this.calendarEventService,
    required this.appointmentService,
    required this.clientService,
    required this.habitService,
    required this.routineService,
    required this.serviceService,
    required this.modeEngineService,
    required super.child,
    super.key,
  });

  static _AppServiceScope of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<_AppServiceScope>();
    assert(result != null, 'App service scope not found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant _AppServiceScope oldWidget) => false;
}
