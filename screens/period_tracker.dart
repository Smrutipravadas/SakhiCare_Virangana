// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';
// import '../services/auth_services.dart';

// class PeriodTrackerScreen extends StatefulWidget {
//   const PeriodTrackerScreen({Key? key}) : super(key: key);

//   @override
//   State<PeriodTrackerScreen> createState() => _PeriodTrackerScreenState();
// }

// class _PeriodTrackerScreenState extends State<PeriodTrackerScreen> {
//   DateTime focusedDay = DateTime.now();
//   DateTime? lastPeriodDate;

//   int? cycleLength;
//   int? periodLength;

//   // BACKEND DATA
//   String currentPhase = "--";
//   String nextPeriodDate = "--";
//   int daysRemaining = 0;

//   bool loading = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadPeriodFromBackend();
//   }

//   /// ---------------- LOAD FROM BACKEND ----------------
//   Future<void> _loadPeriodFromBackend() async {
//     try {
//       final data = await ApiService.getPeriod();

//       if (data.containsKey("last_period_start")) {
//         setState(() {
//           lastPeriodDate = DateTime.parse(data["last_period_start"]);
//           nextPeriodDate = data["expected_next_period"];
//           currentPhase = data["current_phase"];
//           daysRemaining = data["days_remaining"];
//         });
//       }
//     } catch (_) {}
//   }

//   /// ---------------- SAVE TO BACKEND ----------------
//   Future<void> _savePeriod() async {
//     if (lastPeriodDate == null || cycleLength == null || periodLength == null) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Please fill all details")));
//       return;
//     }

//     setState(() => loading = true);

//     try {
//       await ApiService.savePeriod(
//         lastPeriodStart: lastPeriodDate!,
//         cycleLength: cycleLength!,
//         periodLength: periodLength!,
//       );

//       await _loadPeriodFromBackend();

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Period data saved 💗")));
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Failed to save period data")),
//       );
//     }

//     setState(() => loading = false);
//   }

//   /// ---------------- UI ----------------
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF6F3FF),
//       appBar: AppBar(
//         title: const Text("Period Tracker"),
//         backgroundColor: const Color(0xFFEB5C8C),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             /// USER INPUT CARD
//             Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Cycle Details",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 12),

//                     DropdownButtonFormField<int>(
//                       decoration: const InputDecoration(
//                         labelText: "Period length (days)",
//                       ),
//                       items: List.generate(
//                         7,
//                         (i) => DropdownMenuItem(
//                           value: i + 2,
//                           child: Text("${i + 2} days"),
//                         ),
//                       ),
//                       onChanged: (v) => periodLength = v,
//                     ),

//                     const SizedBox(height: 12),

//                     DropdownButtonFormField<int>(
//                       decoration: const InputDecoration(
//                         labelText: "Cycle length",
//                       ),
//                       items: List.generate(
//                         20,
//                         (i) => DropdownMenuItem(
//                           value: i + 21,
//                           child: Text("${i + 21} days"),
//                         ),
//                       ),
//                       onChanged: (v) => cycleLength = v,
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             /// CALENDAR
//             _glassCard(
//               child: TableCalendar(
//                 focusedDay: focusedDay,
//                 firstDay: DateTime.utc(2020, 1, 1),
//                 lastDay: DateTime.utc(2030, 12, 31),
//                 selectedDayPredicate: (day) =>
//                     lastPeriodDate != null && isSameDay(lastPeriodDate, day),
//                 onDaySelected: (selected, focused) {
//                   setState(() {
//                     lastPeriodDate = selected;
//                     focusedDay = focused;
//                   });
//                 },
//               ),
//             ),

//             const SizedBox(height: 20),

//             /// RESULT FROM BACKEND
//             _infoCard("Current Phase", currentPhase),
//             _infoCard("Next Period Date", nextPeriodDate),
//             _infoCard("Days Remaining", "$daysRemaining days"),

//             const SizedBox(height: 20),

//             /// SAVE BUTTON
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: loading ? null : _savePeriod,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFFEB5C8C),
//                   padding: const EdgeInsets.all(14),
//                 ),
//                 child: loading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : const Text("Save Period Data"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// ---------------- WIDGETS ----------------
//   Widget _glassCard({required Widget child}) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(20),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.8),
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: child,
//         ),
//       ),
//     );
//   }

//   Widget _infoCard(String title, String value) {
//     return Card(
//       child: ListTile(
//         title: Text(title),
//         trailing: Text(
//           value,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/auth_services.dart';

class PeriodTrackerScreen extends StatefulWidget {
  const PeriodTrackerScreen({Key? key}) : super(key: key);

  @override
  State<PeriodTrackerScreen> createState() => _PeriodTrackerScreenState();
}

class _PeriodTrackerScreenState extends State<PeriodTrackerScreen> {
  DateTime focusedDay = DateTime.now();
  DateTime? lastPeriodDate;

  int? cycleLength;
  int? periodLength;

  // BACKEND DATA
  String currentPhase = "Not set";
  String nextPeriodDate = "--";
  int daysRemaining = 0;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    _loadPeriodFromBackend();
  }

  // ---------------- LOAD FROM BACKEND ----------------
  Future<void> _loadPeriodFromBackend() async {
    try {
      final data = await ApiService.getPeriod();

      if (data.containsKey("expected_next_period")) {
        final nextDate = DateTime.parse(data["expected_next_period"]);

        setState(() {
          currentPhase = data["current_phase"];
          nextPeriodDate = data["expected_next_period"];

          daysRemaining = nextDate
              .difference(DateTime.now())
              .inDays
              .clamp(0, 999);
        });
      }
    } catch (e) {
      debugPrint("Failed to load period: $e");
    }
  }

  // ---------------- SAVE TO BACKEND ----------------
  Future<void> _savePeriod() async {
    if (lastPeriodDate == null || cycleLength == null || periodLength == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all details")));
      return;
    }

    setState(() => loading = true);

    try {
      await ApiService.savePeriod(
        lastPeriodStart: lastPeriodDate!,
        cycleLength: cycleLength!,
        periodLength: periodLength!,
      );

      await _loadPeriodFromBackend();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Period data saved 💗")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save period data")),
      );
    }

    setState(() => loading = false);
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F3FF),
      appBar: AppBar(
        title: const Text("Period Tracker"),
        backgroundColor: const Color(0xFFEB5C8C),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ---------------- USER INPUT CARD ----------------
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Cycle Details",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: "Period length (days)",
                      ),
                      items: List.generate(
                        7,
                        (i) => DropdownMenuItem(
                          value: i + 2,
                          child: Text("${i + 2} days"),
                        ),
                      ),
                      onChanged: (v) => periodLength = v,
                    ),

                    const SizedBox(height: 12),

                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: "Cycle length (days)",
                      ),
                      items: List.generate(
                        20,
                        (i) => DropdownMenuItem(
                          value: i + 21,
                          child: Text("${i + 21} days"),
                        ),
                      ),
                      onChanged: (v) => cycleLength = v,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ---------------- CALENDAR ----------------
            _glassCard(
              child: TableCalendar(
                focusedDay: focusedDay,
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                selectedDayPredicate: (day) =>
                    lastPeriodDate != null && isSameDay(lastPeriodDate, day),
                onDaySelected: (selected, focused) {
                  setState(() {
                    lastPeriodDate = selected;
                    focusedDay = focused;
                  });
                },
              ),
            ),

            const SizedBox(height: 20),

            // ---------------- RESULT CARDS ----------------
            _infoCard("Current Phase", currentPhase),
            _infoCard("Next Period Date", nextPeriodDate),
            _infoCard("Days Remaining", "$daysRemaining days"),

            const SizedBox(height: 20),

            // ---------------- SAVE BUTTON ----------------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : _savePeriod,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEB5C8C),
                  padding: const EdgeInsets.all(14),
                ),
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Save Period Data"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- WIDGETS ----------------
  Widget _glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(20),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _infoCard(String title, String value) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
