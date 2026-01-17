import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sakhi_care/services/token_storage.dart';

class ApiService {
  static const String baseUrl = "http://10.110.195.152:8000";
  // use laptop IP for real phone
  static String? token;
  static Map<String, String> authHeaders() {
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  // ---------------- SIGNUP ----------------
  static Future<void> signup(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );

    if (response.statusCode != 200) {
      throw Exception("Signup failed");
    }
  }

  // ---------------- LOGIN ----------------
  static Future<String?> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${ApiService.token}",
      },
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      token = data["token"];
      print("Token Saved:$token");
      return token; // JWT token
    } else {
      throw Exception("Login failed");
    }
  }

  // ---------------- HEALTH LOG ----------------
  static Future<void> addHealthLog({
    required int mood,
    required int workHours,
    required int sleepHours,
  }) async {
    // final token = await TokenStorage.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/health-log'),
      headers: authHeaders(),

      body: jsonEncode({
        "mood": mood,
        "physical_work_hours": workHours,
        "sleep_hours": sleepHours,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to save health log");
    }
  }

  // ---------------- INSIGHTS ----------------
  static Future<Map<String, dynamic>> getInsights() async {
    final token = await TokenStorage.getToken();

    if (token == null) {
      throw Exception("Token not found!");
    }

    final response = await http.get(
      Uri.parse("$baseUrl/insights"),
      headers: ApiService.authHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load insights");
    }
  }

  // ---------------- PERIOD ----------------
  static Future<void> savePeriod({
    required DateTime lastPeriodStart,
    required int cycleLength,
    required int periodLength,
  }) async {
    final token = await TokenStorage.getToken();

    await http.post(
      Uri.parse("$baseUrl/period"),
      headers: ApiService.authHeaders(),
      //  {
      //   "Authorization": "Bearer $token",
      //   "Content-Type": "application/json",
      // },
      body: jsonEncode({
        "last_period_start": lastPeriodStart.toIso8601String().split("T")[0],
        "cycle_length": cycleLength,
        "period_length": periodLength,
      }),
    );
  }

  // ---------- GET PERIOD ----------
  static Future<Map<String, dynamic>> getPeriod() async {
    final response = await http.get(
      Uri.parse('$baseUrl/period'),
      headers: authHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch period data");
    }
  }

  // ---------------- ASK SAKHI ----------------
  static Future<String> askSakhi(String message) async {
    final token = await TokenStorage.getToken();

    final response = await http.post(
      Uri.parse("$baseUrl/ask-sakhi"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"message": message}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["reply"];
    } else {
      throw Exception("Failed to talk to Sakhi");
    }
  }

  // ---------------- CARE CIRCLE ----------------
  static Future<void> saveCareCircle({
    required String name,
    required String phone,
    required String relation,
  }) async {
    final token = await TokenStorage.getToken();

    final response = await http.post(
      Uri.parse("$baseUrl/care-circle"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"name": name, "phone": phone, "relation": relation}),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to save care circle");
    }
  }
}
