import 'package:flutter/material.dart';

import '../../data/dao/task_dao.dart';
import '../../data/repositories/task_repository.dart';
import '../../data/services/task_service.dart';

import '../../data/dao/routine_dao.dart';
import '../../data/repositories/routine_repository.dart';
import '../../data/services/routine_service.dart';

import '../tasks/task_list_page.dart';
import '../routines/routine_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // -----------------------------
    // SERVICES
    // -----------------------------
    final taskService = TaskService(
      TaskRepository(
        TaskDao(),
      ),
    );

    final routineService = RoutineService(
      RoutineRepository(
        RoutineDao(),
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Ciantis",
          style: TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // ---------------------------
          // TASKS ENTRY TILE
          // ---------------------------
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TaskListPage(
                    taskService: taskService,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE8E2F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle,
                      color: Color(0xFF8A4FFF), size: 28),
                  const SizedBox(width: 16),
                  const Text(
                    "Tasks",
                    style: TextStyle(
                      color: Color(0xFF5A4A6A),
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right,
                      color: Color(0xFF7A6F8F), size: 26),
                ],
              ),
            ),
          ),

          // ---------------------------
          // ROUTINES ENTRY TILE
          // ---------------------------
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RoutineListPage(
                    routineService: routineService,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE8E2F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.repeat, color: Color(0xFF8A4FFF), size: 28),
                  const SizedBox(width: 16),
                  const Text(
                    "Routines",
                    style: TextStyle(
                      color: Color(0xFF5A4A6A),
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right,
                      color: Color(0xFF7A6F8F), size: 26),
                ],
              ),
            ),
          ),

          // ---------------------------
          // Add additional tiles later
          // ---------------------------
        ],
      ),
    );
  }
}
