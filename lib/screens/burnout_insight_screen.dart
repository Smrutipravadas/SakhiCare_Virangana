import 'package:flutter/material.dart';
import '../services/auth_services.dart';

class BurnoutInsightScreen extends StatefulWidget {
  const BurnoutInsightScreen({Key? key}) : super(key: key);

  @override
  State<BurnoutInsightScreen> createState() => _BurnoutInsightScreenState();
}

class _BurnoutInsightScreenState extends State<BurnoutInsightScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool loading = true;

  double avgSleep = 0;
  double avgWork = 0;
  double avgMood = 0;

  String burnoutLevel = "";
  String burnoutSuggestion = "";
  bool alertCareCircle = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = const AlwaysStoppedAnimation(0.0);
    fetchInsights();
  }

  Future<void> fetchInsights() async {
    try {
      final data = await ApiService.getInsights();

      setState(() {
        burnoutLevel = data["burnout_level"];
        burnoutSuggestion = data["burnout_suggestion"];
        avgSleep = (data["avg_sleep"] as num).toDouble();
        avgWork = (data["avg_physical_work_hours"] as num).toDouble();
        avgMood = (data["avg_mood"] as num).toDouble();
        alertCareCircle = data["alert_care_circle"];
        loading = false;
      });

      _animation = Tween<double>(
        begin: 0,
        end: _getTargetValue(),
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

      _controller.forward();
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  double _getTargetValue() {
    switch (burnoutLevel) {
      case "Low":
        return 0.3;
      case "Medium":
        return 0.6;
      case "High":
        return 0.9;
      default:
        return 0.0;
    }
  }

  Color _getColor() {
    switch (burnoutLevel) {
      case "Low":
        return Colors.green;
      case "Medium":
        return Colors.orange;
      case "High":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _infoCard(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Row(
        children: [
          Icon(icon, size: 28, color: Colors.purple),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 13)),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Burnout Insight"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// 🔥 Burnout Meter
            AnimatedBuilder(
              animation: _animation,
              builder: (_, __) {
                return Column(
                  children: [
                    SizedBox(
                      width: 180,
                      height: 180,
                      child: CircularProgressIndicator(
                        value: _animation.value,
                        strokeWidth: 14,
                        backgroundColor: Colors.grey.shade300,
                        color: _getColor(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      burnoutLevel.toUpperCase(),
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: _getColor(),
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            _infoCard(Icons.bedtime, "Avg Sleep", "$avgSleep hrs"),
            _infoCard(Icons.work, "Avg Work", "$avgWork hrs"),
            _infoCard(Icons.emoji_emotions, "Avg Mood", "$avgMood / 5"),

            const SizedBox(height: 16),

            Text(
              burnoutSuggestion,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 24),

            /// 🚨 CARE CIRCLE TRIGGER
            if (alertCareCircle)
              ElevatedButton.icon(
                icon: const Icon(Icons.people),
                label: const Text("Add Care Circle Contacts"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.all(14),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/care-circle');
                },
              ),
          ],
        ),
      ),
    );
  }
}
