import 'package:flutter/material.dart';

import 'health_log_screen.dart';
import 'period_tracker.dart';
import 'burnout_insight_screen.dart';
import 'care_circle_screen.dart';
import 'sakhi_chatbot_screen.dart';
import 'setting_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FC),

      /// 🔝 APP BAR
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,

        elevation: 0,
        centerTitle: true,
        title: const Text(
          "SakhiCare",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 247, 242, 244),
          ),
        ),
        //---------DARK MODE ----------
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),

      /// 💬 FLOATING CHATBOT BUTTON
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        child: const Icon(Icons.female, color: Colors.white, size: 35),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SakhiChatbotScreen()),
          );
        },
      ),

      /// 📱 BODY
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 👋 WELCOME TEXT
            const Text(
              "Hello Sakhi",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 92, 2, 108),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "How are you feeling today?",
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),

            const SizedBox(height: 20),

            /// 🧩 GRID MENU
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: size.width > 600 ? 3 : 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.95,
              children: [
                _homeCard(
                  context,
                  title: "Health Log",
                  icon: Icons.favorite,
                  color: Colors.pink,
                  onTap: () => _navigate(context, const HealthLogScreen()),
                ),

                _homeCard(
                  context,
                  title: "Period Tracker",
                  icon: Icons.calendar_month,
                  color: Colors.redAccent,
                  onTap: () => _navigate(context, const PeriodTrackerScreen()),
                ),

                _homeCard(
                  context,
                  title: "Burnout Insight",
                  icon: Icons.insights,
                  color: Colors.orange,
                  onTap: () => _navigate(context, const BurnoutInsightScreen()),
                ),

                _homeCard(
                  context,
                  title: "Care Circle",
                  icon: Icons.group,
                  color: Colors.teal,
                  onTap: () => _navigate(context, const CareCircleScreen()),
                ),
              ],
            ),

            const SizedBox(height: 30),

            /// 🌿 MOTIVATION CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                "🌼 Remember: Taking care of yourself is not selfish.\nSakhiCare is always with you.",
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔀 NAVIGATION HELPER
  void _navigate(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  /// 🧩 HOME CARD WIDGET
  Widget _homeCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
