import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  final String username;
  final String password;

  Auth({required this.username, required this.password});

  // Convert Auth to JSON
  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };

  // Create Auth from JSON
  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth(
      username: json['username'],
      password: json['password'],
    );
  }

  /// ✅ Save student to SharedPreferences
  static Future<void> saveStudent(Auth auth) async {
    final prefs = await SharedPreferences.getInstance();
    final studentJson = jsonEncode(auth.toJson());
    await prefs.setString('student', studentJson);
  }

  /// ✅ Delete student from SharedPreferences
  static Future<void> deleteStudent() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('student');
  }

  /// ✅ Get saved student from SharedPreferences
  static Future<Auth?> getStudent() async {
    final prefs = await SharedPreferences.getInstance();
    final studentJson = prefs.getString('student');
    if (studentJson == null) return null;

    try {
      final Map<String, dynamic> jsonMap = jsonDecode(studentJson);
      return Auth.fromJson(jsonMap);
    } catch (e) {
      // Handle corrupt or invalid data
      return null;
    }
  }

  /// ✅ Check if a student is saved (logged in)
  static Future<bool> isStudentActive() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('student');
  }
}
