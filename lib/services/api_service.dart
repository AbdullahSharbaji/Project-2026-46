import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://37.140.242.178/api";

  Map<String, String> get _headers =>
      {
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

  // 🔹 Aktif talepler (GET /api/requests/active?userId=5)
  Future<List<dynamic>> getActiveRequests(int userId) async {
    final url = Uri.parse('$baseUrl/requests/active?userId=$userId');

    try {
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data as List);
      } else {
        print("ActiveRequests Hatası: ${response.statusCode}");
        print(response.body);
        return [];
      }
    } catch (e) {
      print("Bağlantı Hatası (ActiveRequests): $e");
      return [];
    }
  }

  // 🔹 Categories (GET /api/categories)
  Future<List<dynamic>> getCategories() async {
    final url = Uri.parse('$baseUrl/categories');

    try {
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List);
      } else {
        print("Categories Hatası: ${response.statusCode}");
        print(response.body);
        return [];
      }
    } catch (e) {
      print("Bağlantı Hatası (Categories): $e");
      return [];
    }
  }

  // 🔹 Providers by Category (GET /api/providers?categoryId=1)
  Future<List<dynamic>> getProvidersByCategory(int categoryId) async {
    final url = Uri.parse('$baseUrl/providers?categoryId=$categoryId');

    try {
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List);
      } else {
        print("Providers Hatası: ${response.statusCode}");
        print(response.body);
        return [];
      }
    } catch (e) {
      print("Bağlantı Hatası (Providers): $e");
      return [];
    }
  }

  // 🔹 Create Request (POST /api/requests)
  Future<bool> createRequest({
    required int userId,
    required int categoryId,
    required String description,
    String? imagePath,
  }) async {
    final url = Uri.parse('$baseUrl/requests');

    try {
      if (imagePath != null && imagePath.isNotEmpty) {
        // Multipart request for image upload
        var request = http.MultipartRequest('POST', url);
        request.headers.addAll(_headers);
        request.fields['UserId'] = userId.toString();
        request.fields['CategoryId'] = categoryId.toString();
        request.fields['Description'] = description;

        request.files.add(await http.MultipartFile.fromPath('Image', imagePath));

        var response = await request.send();
        return response.statusCode == 200 || response.statusCode == 201;
      } else {
        // Standard JSON request if no image
        final response = await http.post(
          url,
          headers: _headers,
          body: jsonEncode({
            "UserId": userId,
            "CategoryId": categoryId,
            "Description": description,
          }),
        );
        return response.statusCode == 200 || response.statusCode == 201;
      }
    } catch (e) {
      print("Bağlantı Hatası (CreateRequest): $e");
      return false;
    }
  }
}

