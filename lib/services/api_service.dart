import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ApiService {
  static const String baseUrl = "http://37.140.242.178/api";

  Map<String, String> get _headers => {
    "Content-Type": "application/json",
    if (!kIsWeb) "ngrok-skip-browser-warning": "true",
  };

  Future<dynamic> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode({"Email": email, "Password": password}),
      );
      if (response.statusCode == 200) return jsonDecode(response.body);

      print("Giriş Hatası: ${response.statusCode}");
      print(response.body);
      return null;
    } catch (e) {
      print("Bağlantı Hatası (Login): $e");
      return null;
    }
  }

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

      if (response.statusCode == 200) return true;

      print("Register Hatası: ${response.statusCode}");
      print(response.body);
      return false;
    } catch (e) {
      print("Bağlantı Hatası (Register): $e");
      return false;
    }
  }

  Future<Map<String, dynamic>?> getUserById(int userId) async {
    final url = Uri.parse('$baseUrl/users/$userId');
    try {
      final response = await http.get(url, headers: _headers);
      if (response.statusCode == 200) return jsonDecode(response.body);

      print("Profil Hatası: ${response.statusCode}");
      print(response.body);
      return null;
    } catch (e) {
      print("Bağlantı Hatası (Profile): $e");
      return null;
    }
  }

  Future<List<dynamic>> getActiveRequests(int userId) async {
    final url = Uri.parse('$baseUrl/requests/active?userId=$userId');
    try {
      final response = await http.get(url, headers: _headers);
      if (response.statusCode == 200) return (jsonDecode(response.body) as List);

      print("ActiveRequests Hatası: ${response.statusCode}");
      print(response.body);
      return [];
    } catch (e) {
      print("Bağlantı Hatası (ActiveRequests): $e");
      return [];
    }
  }

  Future<List<dynamic>> getCategories() async {
    final url = Uri.parse('$baseUrl/categories');
    try {
      final response = await http.get(url, headers: _headers);
      if (response.statusCode == 200) return (jsonDecode(response.body) as List);

      print("Categories Hatası: ${response.statusCode}");
      print(response.body);
      return [];
    } catch (e) {
      print("Bağlantı Hatası (Categories): $e");
      return [];
    }
  }

  Future<List<dynamic>> getProvidersByCategory(int categoryId) async {
    final url = Uri.parse('$baseUrl/providers?categoryId=$categoryId');
    try {
      final response = await http.get(url, headers: _headers);
      if (response.statusCode == 200) return (jsonDecode(response.body) as List);

      print("Providers Hatası: ${response.statusCode}");
      print(response.body);
      return [];
    } catch (e) {
      print("Bağlantı Hatası (Providers): $e");
      return [];
    }
  }

  Future<bool> createRequest({
    required int userId,
    required int categoryId,
    required String description,
    XFile? image,
  }) async {
    try {
      final bool hasImage = image != null;
      final uri = Uri.parse('$baseUrl/requests${hasImage ? "/with-image" : ""}');

      if (!hasImage) {
        final res = await http.post(
          uri,
          headers: _headers,
          body: jsonEncode({
            "UserId": userId,
            "CategoryId": categoryId,
            "Description": description,
          }),
        );
        if (res.statusCode == 200) return true;

        print("CreateRequest JSON Hatası: ${res.statusCode}");
        print(res.body);
        return false;
      }

      final req = http.MultipartRequest("POST", uri);
      req.headers["Accept"] = "application/json";

      req.fields["userId"] = userId.toString();
      req.fields["categoryId"] = categoryId.toString();
      req.fields["description"] = description;

      if (kIsWeb) {
        final bytes = await image!.readAsBytes();
        req.files.add(http.MultipartFile.fromBytes("image", bytes, filename: image.name));
      } else {
        req.files.add(await http.MultipartFile.fromPath("image", image!.path));
      }

      final streamed = await req.send();
      final res = await http.Response.fromStream(streamed);

      if (res.statusCode == 200) return true;

      print("CreateRequest Multipart Hatası: ${res.statusCode}");
      print(res.body);
      return false;
    } catch (e) {
      print("CreateRequest error: $e");
      return false;
    }
  }

  Future<bool> updateProfile({
    required int userId,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    final url = Uri.parse('$baseUrl/users/$userId');
    try {
      final res = await http.put(
        url,
        headers: _headers,
        body: jsonEncode({
          "FirstName": firstName,
          "LastName": lastName,
          "PhoneNumber": phoneNumber.isEmpty ? null : phoneNumber,
        }),
      );

      if (res.statusCode == 200) return true;

      print("UpdateProfile Hatası: ${res.statusCode}");
      print(res.body);
      return false;
    } catch (e) {
      print("Bağlantı Hatası (UpdateProfile): $e");
      return false;
    }
  }

  Future<String?> uploadProfilePhoto({
    required int userId,
    required String imagePath,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/users/$userId/profile-photo');
      final req = http.MultipartRequest('POST', uri);

      req.headers["Accept"] = "application/json";
      if (!kIsWeb) {
        req.headers["ngrok-skip-browser-warning"] = "true";
      }

      req.files.add(await http.MultipartFile.fromPath('image', imagePath));

      final streamed = await req.send();
      final res = await http.Response.fromStream(streamed);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['profileImageUrl']?.toString();
      }

      print('UploadPhoto Hatası: ${res.statusCode}');
      print(res.body);
      return null;
    } catch (e) {
      print('UploadPhoto error: $e');
      return null;
    }
  }

  Future<bool> registerWorker({
    required String firstName,
    required String lastName,
    required String shopName,
    required String taxNumber,
    required String companyName,
    required String companyType,
    required String category,
    required String phoneNumber,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/workers/register');

    try {
      final res = await http.post(
        url,
        headers: _headers,
        body: jsonEncode({
          "FirstName": firstName,
          "LastName": lastName,
          "ShopName": shopName,
          "TaxNumber": taxNumber,
          "CompanyName": companyName,
          "CompanyType": companyType,
          "Category": category,
          "PhoneNumber": phoneNumber,
          "Password": password,
        }),
      );

      if (res.statusCode == 200) return true;

      print("Worker Register Hatası: ${res.statusCode}");
      print(res.body);
      return false;
    } catch (e) {
      print("Bağlantı Hatası (Worker Register): $e");
      return false;
    }
  }

  Future<Map<String, dynamic>?> loginWorker({
    required String taxNumber,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/workers/login');

    try {
      final res = await http.post(
        url,
        headers: _headers,
        body: jsonEncode({
          "TaxNumber": taxNumber,
          "Password": password,
        }),
      );

      if (res.statusCode == 200) return jsonDecode(res.body);

      print("Worker Login Hatası: ${res.statusCode}");
      print(res.body);
      return null;
    } catch (e) {
      print("Bağlantı Hatası (Worker Login): $e");
      return null;
    }
  }

  Future<List<dynamic>> getRequestsForWorkerCategory(String category) async {
    final url = Uri.parse('$baseUrl/requests/for-worker?category=${Uri.encodeComponent(category)}');

    try {
      final res = await http.get(url, headers: _headers);

      if (res.statusCode == 200) {
        return (jsonDecode(res.body) as List);
      }

      print("GetForWorker Hatası: ${res.statusCode}");
      print(res.body);
      return [];
    } catch (e) {
      print("Bağlantı Hatası (GetForWorker): $e");
      return [];
    }
  }

  // =========================
  // ✅ OFFERS (Teklifler)
  // =========================

  Future<bool> createOffer({
    required int requestId,
    required int workerId,
    required String visitDateIso,
    required String timeRange,
    required double price,
    required String note,
  }) async {
    final url = Uri.parse('$baseUrl/offers');
    try {
      final res = await http.post(
        url,
        headers: _headers,
        body: jsonEncode({
          "RequestId": requestId,
          "WorkerId": workerId,
          "VisitDate": visitDateIso,
          "TimeRange": timeRange,
          "Price": price,
          "Note": note,
        }),
      );

      if (res.statusCode == 200) return true;

      print("createOffer Hatası: ${res.statusCode}");
      print(res.body);
      return false;
    } catch (e) {
      print("createOffer error: $e");
      return false;
    }
  }

  Future<List<dynamic>> getOffersByRequest(int requestId) async {
    final url = Uri.parse('$baseUrl/offers/by-request?requestId=$requestId');
    try {
      final res = await http.get(url, headers: _headers);

      if (res.statusCode == 200) {
        return (jsonDecode(res.body) as List);
      }

      print("getOffersByRequest Hatası: ${res.statusCode}");
      print(res.body);
      return [];
    } catch (e) {
      print("getOffersByRequest error: $e");
      return [];
    }
  }
}
