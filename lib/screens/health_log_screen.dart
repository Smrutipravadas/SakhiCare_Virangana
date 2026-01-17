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
  int sleepHours = 8;
  int workHours = 6;

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
            // -------- MOOD --------
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("😔"),
                      Text("😐"),
                      Text("😊"),
                      Text("😄"),
                      Text("🤩"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // -------- SLEEP --------
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

            // -------- WORK --------
            _glassCard(
              title: "Workload Hours",
              child: _hourDropdown(
                value: workHours,
                icon: Icons.work_outline,
                onChanged: (val) {
                  setState(() => workHours = val!);
                },
              ),
            ),

            const SizedBox(height: 30),

            // -------- SAVE BUTTON --------
            ElevatedButton(
              onPressed: () async {
                try {
                  await ApiService.authHeaders();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Health log saved successfully 💜"),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Failed to save health log")),
                  );
                }
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

  // ---------------- GLASS CARD ----------------
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
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
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

  // ---------------- DROPDOWN ----------------
  Widget _hourDropdown({
    required int value,
    required Function(int?) onChanged,
    required IconData icon,
  }) {
    return DropdownButtonFormField<int>(
      value: value,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      items: List.generate(
        24,
        (index) => DropdownMenuItem(
          value: index + 1,
          child: Text("${index + 1} hour${index == 0 ? '' : 's'}"),
        ),
      ),
      onChanged: onChanged,
    );
  }

  // ---------------- MOOD TEXT ----------------
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
