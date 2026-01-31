import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiService {
  static String get baseUrl {
    return kIsWeb ? "https://localhost:7289/api" : "https://10.0.2.2:7289/api";
  }

  // 🔹 Login
  Future<dynamic> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "Email": email,
          "Password": password,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Giriş Hatası: ${response.statusCode}");
        print(response.body);
        return null;
      }
    } catch (e) {
      print("Bağlantı Hatası (Login): $e");
      return null;
    }
  }

  // 🔹 Register
  Future<bool> register({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required DateTime? birthDate,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/auth/register');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "FirstName": firstName,
          "LastName": lastName,
          "PhoneNumber": phoneNumber.isEmpty ? null : phoneNumber,
          "BirthDate": birthDate?.toIso8601String(),
          "Email": email,
          "Password": password,
        }),
      );

      if (response.statusCode != 200) {
        print("Register Hatası: ${response.statusCode}");
        print(response.body);
      }

      return response.statusCode == 200;
    } catch (e) {
      print("Bağlantı Hatası (Register): $e");
      return false;
    }
  }

  // 🔹 Profil bilgisi getir (GET /api/users/{id})
  Future<Map<String, dynamic>?> getUserById(int userId) async {
    final url = Uri.parse('$baseUrl/users/$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        print("Profil Hatası: ${response.statusCode}");
        print(response.body);
        return null;
      }
    } catch (e) {
      print("Bağlantı Hatası (Profile): $e");
      return null;
    }
  }
}
