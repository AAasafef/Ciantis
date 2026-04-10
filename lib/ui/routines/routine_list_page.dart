import 'package:flutter/material.dart';
import '../../data/services/routine_service.dart';
import '../../data/models/routine_model.dart';
import 'widgets/routine_tile.dart';
import 'routine_creation_page.dart';
import 'routine_detail_page.dart';

class RoutineListPage extends StatefulWidget {
  final RoutineService routineService;

  const RoutineListPage({super.key, required this.routineService});

  @override
  State<RoutineListPage> createState() => _RoutineListPageState();
}

class _RoutineListPageState extends State<RoutineListPage> {
  bool _loading = true;
  List<RoutineModel> _routines = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await widget.routineService.getAllRoutines();
    setState(() {
      _routines = list;
      _loading = false;
    });
  }

  Future<void> _openCreation() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RoutineCreationPage(
          routineService: widget.routineService,
        ),
      ),
    );
    _load();
  }

  Future<void> _openDetail(RoutineModel routine) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RoutineDetailPage(
          routine: routine,
          routineService: widget.routineService,
        ),
      ),
    );
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Routines",
          style: TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF8A4FFF)),
            onPressed: _openCreation,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _routines.isEmpty
              ? const Center(
                  child: Text(
                    "No routines yet",
                    style: TextStyle(
                      color: Color(0xFF7A6F8F),
                      fontSize: 16,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _routines.length,
                  itemBuilder: (context, i) {
                    final routine = _routines[i];
                    return RoutineTile(
                      routine: routine,
                      onTap: () => _openDetail(routine),
                    );
                  },
                ),
    );
  }
}
