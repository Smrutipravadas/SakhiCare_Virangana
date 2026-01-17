// // import 'dart:ui';
// // import 'package:flutter/material.dart';
// // import '../services/auth_services.dart';

// // class HealthLogScreen extends StatefulWidget {
// //   const HealthLogScreen({super.key});

// //   @override
// //   State<HealthLogScreen> createState() => _HealthLogScreenState();
// // }

// // class _HealthLogScreenState extends State<HealthLogScreen> {
// //   double mood = 3;
// //   int sleepHours = 8;
// //   int workHours = 6;
// //   int? heightCm;
// //   int? weightKg;
// //   String? bloodGroup;

// //   final List<String> bloodGroups = [
// //     "A+",
// //     "A-",
// //     "B+",
// //     "B-",
// //     "AB+",
// //     "AB-",
// //     "O+",
// //     "O-",
// //   ];

// //   @override
// //   Widget build(BuildContext context) {
// //     final size = MediaQuery.of(context).size;

// //     return Scaffold(
// //       backgroundColor: const Color(0xFFF5F3FF),
// //       appBar: AppBar(
// //         title: const Text("Health Log", style: TextStyle(color: Colors.white)),
// //         backgroundColor: const Color.fromARGB(255, 140, 87, 233),
// //       ),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           children: [
// //             // -------- MOOD --------
// //             _glassCard(
// //               title: "Mood Tracker",
// //               child: Column(
// //                 children: [
// //                   Text(
// //                     _moodText(mood.toInt()),
// //                     style: const TextStyle(
// //                       fontSize: 18,
// //                       fontWeight: FontWeight.bold,
// //                       color: Colors.deepPurple,
// //                     ),
// //                   ),
// //                   Slider(
// //                     value: mood,
// //                     min: 1,
// //                     max: 5,
// //                     divisions: 4,
// //                     activeColor: Colors.deepPurple,
// //                     label: mood.toInt().toString(),
// //                     onChanged: (value) {
// //                       setState(() => mood = value);
// //                     },
// //                   ),
// //                   const Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     children: [
// //                       Text("😔"),
// //                       Text("😐"),
// //                       Text("😊"),
// //                       Text("😄"),
// //                       Text("🤩"),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             ),

// //             const SizedBox(height: 20),

// //             // -------- SLEEP --------
// //             _glassCard(
// //               title: "Sleep Hours",
// //               child: _hourDropdown(
// //                 value: sleepHours,
// //                 icon: Icons.bedtime,
// //                 onChanged: (val) {
// //                   setState(() => sleepHours = val!);
// //                 },
// //               ),
// //             ),

// //             const SizedBox(height: 20),

// //             // -------- WORK --------
// //             _glassCard(
// //               title: "Workload Hours",
// //               child: _hourDropdown(
// //                 value: workHours,
// //                 icon: Icons.work_outline,
// //                 onChanged: (val) {
// //                   setState(() => workHours = val!);
// //                 },
// //               ),
// //             ),

// //             // -------- Height --------
// //             _glassCard(
// //               title: "Height(cm)",
// //               child: _hourDropdown(
// //                 value: heightCm,
// //                 icon: Icons.height_outlined,
// //                 onChanged: (val) {
// //                   setState(() => heightCm = val!);
// //                 },
// //               ),
// //             ),

// //             // -------- Weight --------
// //             _glassCard(
// //               title: "Weight(kg)",
// //               child: _hourDropdown(
// //                 value: weightKg,
// //                 icon: Icons.monitor_weight_outlined,
// //                 onChanged: (val) {
// //                   setState(() => weightKg = val!);
// //                 },
// //               ),
// //             ),
// //             // -------- BLOOD GROUP --------
// //             _glassCard(
// //               title: "Blood Group",
// //               child: DropdownButtonFormField(
// //                 value: bloodGroup,
// //                 icon: const Icon(Icons.bloodtype_outlined),
// //                 decoration: const InputDecoration(border: InputBorder.none),
// //                 items: bloodGroups.map((group) {
// //                   return DropdownMenuItem(value: group, child: Text(group));
// //                 }).toList(),
// //                 onChanged: (val) {
// //                   setState(() => bloodGroup = val);
// //                 },
// //                 hint: const Text("Select blood group"),
// //               ),
// //             ),

// //             const SizedBox(height: 30),

// //             // -------- SAVE BUTTON --------
// //             ElevatedButton(
// //               onPressed: () async {
// //                 try {
// //                   await ApiService.addHealthLog(
// //                     mood: mood.toInt(),
// //                     workHours: workHours,
// //                     sleepHours: sleepHours,
// //                     heightCm: heightCm,
// //                     weightKg: weightKg,
// //                     bloodGroup: bloodGroup!,
// //                   );

// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     const SnackBar(
// //                       content: Text("Health log saved successfully 💜"),
// //                     ),
// //                   );
// //                 } catch (e) {
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     SnackBar(content: Text("Failed to save health log: $e")),
// //                   );
// //                 }
// //               },

// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: const Color.fromARGB(255, 140, 87, 233),
// //                 minimumSize: Size(size.width, 52),
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(14),
// //                 ),
// //               ),
// //               child: const Text(
// //                 "Save Health Log",
// //                 style: TextStyle(fontSize: 18, color: Colors.white),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   // ---------------- GLASS CARD ----------------
// //   Widget _glassCard({required String title, required Widget child}) {
// //     return ClipRRect(
// //       borderRadius: BorderRadius.circular(20),
// //       child: BackdropFilter(
// //         filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
// //         child: Container(
// //           padding: const EdgeInsets.all(18),
// //           decoration: BoxDecoration(
// //             color: Colors.white.withOpacity(0.7),
// //             borderRadius: BorderRadius.circular(20),
// //             boxShadow: [
// //               BoxShadow(
// //                 color: Colors.black.withOpacity(0.1),
// //                 blurRadius: 15,
// //                 offset: const Offset(0, 8),
// //               ),
// //             ],
// //           ),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text(
// //                 title,
// //                 style: const TextStyle(
// //                   fontSize: 20,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.deepPurple,
// //                 ),
// //               ),
// //               const SizedBox(height: 14),
// //               child,
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   // ---------------- DROPDOWN ----------------
// //   Widget _hourDropdown({
// //     required int? value,
// //     required Function(int?) onChanged,
// //     required IconData icon,
// //   }) {
// //     return DropdownButtonFormField<int>(
// //       value: value,
// //       decoration: InputDecoration(
// //         prefixIcon: Icon(icon, color: Colors.deepPurple),
// //         filled: true,
// //         fillColor: Colors.white,
// //         border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
// //       ),
// //       items: List.generate(
// //         24,
// //         (index) => DropdownMenuItem(
// //           value: index + 1,
// //           child: Text("${index + 1} hour${index == 0 ? '' : 's'}"),
// //         ),
// //       ),
// //       onChanged: onChanged,
// //     );
// //   }

// //   // ---------------- MOOD TEXT ----------------
// //   String _moodText(int mood) {
// //     switch (mood) {
// //       case 1:
// //         return "Not feeling okay 😔";
// //       case 2:
// //         return "Feeling low 😕";
// //       case 3:
// //         return "Neutral 🙂";
// //       case 4:
// //         return "Good mood 😊";
// //       case 5:
// //         return "Great mood 🤩";
// //       default:
// //         return "";
// //     }
// //   }
// // }
// import 'dart:ffi';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import '../services/auth_services.dart';

// class HealthLogScreen extends StatefulWidget {
//   const HealthLogScreen({super.key});

//   @override
//   State<HealthLogScreen> createState() => _HealthLogScreenState();
// }

// class _HealthLogScreenState extends State<HealthLogScreen> {
//   double mood = 3;
//   double sleepHours = 8;
//   double workHours = 6;
//   double? heightCm;
//   double? weightKg;
//   String? bloodGroup;

//   final List<String> bloodGroups = [
//     "A+",
//     "A-",
//     "B+",
//     "B-",
//     "AB+",
//     "AB-",
//     "O+",
//     "O-",
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F3FF),
//       appBar: AppBar(
//         title: const Text("Health Log", style: TextStyle(color: Colors.white)),
//         backgroundColor: const Color.fromARGB(255, 140, 87, 233),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // -------- MOOD --------
//             _glassCard(
//               title: "Mood Tracker",
//               child: Column(
//                 children: [
//                   Text(
//                     _moodText(mood.toInt()),
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.deepPurple,
//                     ),
//                   ),
//                   Slider(
//                     value: mood,
//                     min: 1,
//                     max: 5,
//                     divisions: 4,
//                     activeColor: Colors.deepPurple,
//                     label: mood.toInt().toString(),
//                     onChanged: (value) {
//                       setState(() => mood = value);
//                     },
//                   ),
//                   const Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("😔"),
//                       Text("😐"),
//                       Text("😊"),
//                       Text("😄"),
//                       Text("🤩"),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 20),

//             // -------- SLEEP --------
//             _glassCard(
//               title: "Sleep Hours",
//               child: _hourDropdown(
//                 value: sleepHours,
//                 icon: Icons.bedtime,
//                 onChanged: (val) {
//                   setState(() => sleepHours = val!);
//                 },
//               ),
//             ),

//             const SizedBox(height: 20),

//             // -------- WORK --------
//             _glassCard(
//               title: "Work Hours",
//               child: _hourDropdown(
//                 value: workHours,
//                 icon: Icons.work_outline,
//                 onChanged: (val) {
//                   setState(() => workHours = val!);
//                 },
//               ),
//             ),

//             const SizedBox(height: 20),

//             // -------- HEIGHT --------
//             _glassCard(
//               title: "Height (cm)",
//               child: _numberDropdown(
//                 value: heightCm,
//                 start: 100,
//                 end: 220,
//                 icon: Icons.height_outlined,
//                 unit: "cm",
//                 onChanged: (val) => setState(() => heightCm = val),
//               ),
//             ),

//             const SizedBox(height: 20),

//             // -------- WEIGHT --------
//             _glassCard(
//               title: "Weight (kg)",
//               child: _numberDropdown(
//                 value: weightKg,
//                 start: 30,
//                 end: 150,
//                 icon: Icons.monitor_weight_outlined,
//                 unit: "kg",
//                 onChanged: (val) => setState(() => weightKg = val),
//               ),
//             ),

//             const SizedBox(height: 20),

//             // -------- BLOOD GROUP --------
//             _glassCard(
//               title: "Blood Group",
//               child: DropdownButtonFormField<String>(
//                 value: bloodGroup,
//                 icon: const Icon(Icons.bloodtype_outlined),
//                 decoration: const InputDecoration(border: InputBorder.none),
//                 items: bloodGroups.map((group) {
//                   return DropdownMenuItem(value: group, child: Text(group));
//                 }).toList(),
//                 onChanged: (val) => setState(() => bloodGroup = val),
//                 hint: const Text("Select blood group"),
//               ),
//             ),

//             const SizedBox(height: 30),

//             // -------- SAVE BUTTON --------
//             ElevatedButton(
//               onPressed: () async {
//                 if (heightCm == null ||
//                     weightKg == null ||
//                     bloodGroup == null) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text("Please fill all fields")),
//                   );
//                   return;
//                 }

//                 try {
//                   await ApiService.addHealthLog(
//                     mood: mood.toInt(),
//                     workHours: workHours,
//                     sleepHours: sleepHours,
//                     heightCm: heightCm!,
//                     weightKg: weightKg!,
//                     bloodGroup: bloodGroup!,
//                   );

//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text("Health log saved successfully 💜"),
//                     ),
//                   );
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text("Failed to save health log: $e")),
//                   );
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color.fromARGB(255, 140, 87, 233),
//                 minimumSize: Size(size.width, 52),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//               ),
//               child: const Text(
//                 "Save Health Log",
//                 style: TextStyle(fontSize: 18, color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ---------------- GLASS CARD ----------------
//   Widget _glassCard({required String title, required Widget child}) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(20),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
//         child: Container(
//           padding: const EdgeInsets.all(18),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.7),
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 15,
//                 offset: const Offset(0, 8),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.deepPurple,
//                 ),
//               ),
//               const SizedBox(height: 14),
//               child,
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ---------------- HOURS DROPDOWN ----------------
//   Widget _hourDropdown({
//     required double value,
//     required Function(double?) onChanged,
//     required IconData icon,
//   }) {
//     return DropdownButtonFormField<double>(
//       value: value,
//       decoration: InputDecoration(
//         prefixIcon: Icon(icon, color: Colors.deepPurple),
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
//       ),
//       items: List.generate(
//         24,
//         (index) => DropdownMenuItem(
//           value: index + 1,
//           child: Text("${index + 1} hours"),
//         ),
//       ),
//       onChanged: onChanged,
//     );
//   }

//   // ---------------- NUMBER RANGE DROPDOWN ----------------
//   Widget _numberDropdown({
//     required double? value,
//     required double start,
//     required double end,
//     required String unit,
//     required IconData icon,
//     required Function(double?) onChanged,
//   }) {
//     return DropdownButtonFormField<double>(
//       value: value,
//       decoration: InputDecoration(
//         prefixIcon: Icon(icon, color: Colors.deepPurple),
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
//       ),
//       items: List.generate(
//         (end - start + 1).toInt,
//         (index) => {
//          final double value: start + index.toDouble();
//          return DropdownMenuItem<double>(
//           value:value,
//           child: Text("${start + index} $unit"),
//         );
//         },
//       ),
//       onChanged: onChanged,
//     );
//   }

//   // ---------------- MOOD TEXT ----------------
//   String _moodText(int mood) {
//     switch (mood) {
//       case 1:
//         return "Not feeling okay 😔";
//       case 2:
//         return "Feeling low 😕";
//       case 3:
//         return "Neutral 🙂";
//       case 4:
//         return "Good mood 😊";
//       case 5:
//         return "Great mood 🤩";
//       default:
//         return "";
//     }
//   }
// }
import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/auth_services.dart';

class HealthLogScreen extends StatefulWidget {
  const HealthLogScreen({super.key});

  @override
  State<HealthLogScreen> createState() => _HealthLogScreenState();
}

class _HealthLogScreenState extends State<HealthLogScreen> {
  double mood = 3;
  double sleepHours = 8;
  double workHours = 6;
  double? heightCm;
  double? weightKg;
  String? bloodGroup;

  final List<String> bloodGroups = [
    "A+",
    "A-",
    "B+",
    "B-",
    "AB+",
    "AB-",
    "O+",
    "O-",
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      appBar: AppBar(
        title: const Text("Health Log", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 140, 87, 233),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _glassCard(
              title: "Mood Tracker",
              child: Column(
                children: [
                  Text(
                    _moodText(mood.toInt()),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  Slider(
                    value: mood,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    activeColor: Colors.deepPurple,
                    label: mood.toInt().toString(),
                    onChanged: (value) {
                      setState(() => mood = value);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _glassCard(
              title: "Sleep Hours",
              child: _hourDropdown(
                value: sleepHours,
                icon: Icons.bedtime,
                onChanged: (val) {
                  setState(() => sleepHours = val!);
                },
              ),
            ),

            const SizedBox(height: 20),

            _glassCard(
              title: "Work Hours",
              child: _hourDropdown(
                value: workHours,
                icon: Icons.work_outline,
                onChanged: (val) {
                  setState(() => workHours = val!);
                },
              ),
            ),

            const SizedBox(height: 20),

            _glassCard(
              title: "Height (cm)",
              child: _numberDropdown(
                value: heightCm,
                start: 100,
                end: 220,
                icon: Icons.height_outlined,
                unit: "cm",
                onChanged: (val) => setState(() => heightCm = val),
              ),
            ),

            const SizedBox(height: 20),

            _glassCard(
              title: "Weight (kg)",
              child: _numberDropdown(
                value: weightKg,
                start: 30,
                end: 150,
                icon: Icons.monitor_weight_outlined,
                unit: "kg",
                onChanged: (val) => setState(() => weightKg = val),
              ),
            ),

            const SizedBox(height: 20),

            _glassCard(
              title: "Blood Group",
              child: DropdownButtonFormField<String>(
                value: bloodGroup,
                icon: const Icon(Icons.bloodtype_outlined),
                decoration: const InputDecoration(border: InputBorder.none),
                items: bloodGroups
                    .map(
                      (group) =>
                          DropdownMenuItem(value: group, child: Text(group)),
                    )
                    .toList(),
                onChanged: (val) => setState(() => bloodGroup = val),
                hint: const Text("Select blood group"),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () async {
                if (heightCm == null ||
                    weightKg == null ||
                    bloodGroup == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill all fields")),
                  );
                  return;
                }

                await ApiService.addHealthLog(
                  mood: mood.toInt(),
                  workHours: workHours, // ✅ double
                  sleepHours: sleepHours, // ✅ double
                  heightCm: heightCm!, // ✅ double
                  weightKg: weightKg!, // ✅ double
                  bloodGroup: bloodGroup!,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Health log saved successfully 💜"),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 140, 87, 233),
                minimumSize: Size(size.width, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Save Health Log",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glassCard({required String title, required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 14),
              child,
            ],
          ),
        ),
      ),
    );
  }

  Widget _hourDropdown({
    required double value,
    required Function(double?) onChanged,
    required IconData icon,
  }) {
    return DropdownButtonFormField<double>(
      value: value,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      items: List.generate(
        24,
        (index) => DropdownMenuItem<double>(
          value: (index + 1).toDouble(),
          child: Text("${index + 1} hours"),
        ),
      ),
      onChanged: onChanged,
    );
  }

  Widget _numberDropdown({
    required double? value,
    required double start,
    required double end,
    required String unit,
    required IconData icon,
    required Function(double?) onChanged,
  }) {
    return DropdownButtonFormField<double>(
      value: value,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      items: List.generate((end - start + 1).toInt(), (index) {
        final double val = start + index.toDouble();
        return DropdownMenuItem<double>(value: val, child: Text("$val $unit"));
      }),
      onChanged: onChanged,
    );
  }

  String _moodText(int mood) {
    switch (mood) {
      case 1:
        return "Not feeling okay 😔";
      case 2:
        return "Feeling low 😕";
      case 3:
        return "Neutral 🙂";
      case 4:
        return "Good mood 😊";
      case 5:
        return "Great mood 🤩";
      default:
        return "";
    }
  }
}
