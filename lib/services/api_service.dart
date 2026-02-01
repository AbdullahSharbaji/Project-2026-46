import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "https://brouilla-felicity-needingly.ngrok-free.dev/api";

  Map<String, String> get _headers => {
    "Content-Type": "application/json",
    "ngrok-skip-browser-warning": "true", // ✅ KRİTİK
  };

  // 🔹 Login
  Future<dynamic> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');

    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode({"Email": email, "Password": password}),
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
        headers: _headers,
        body: jsonEncode({
          "FirstName": firstName,
          "LastName": lastName,
          "PhoneNumber": phoneNumber.isEmpty ? null : phoneNumber,
          "BirthDate": birthDate?.toIso8601String(),
          "Email": email,
          "Password": password,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Bağlantı Hatası (Register): $e");
      return false;
    }
  }

  // 🔹 Profil
  Future<Map<String, dynamic>?> getUserById(int userId) async {
    final url = Uri.parse('$baseUrl/users/$userId');

    try {
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Profil Hatası: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Bağlantı Hatası (Profile): $e");
      return null;
    }
  }
}
