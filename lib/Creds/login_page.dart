import 'package:flutter/material.dart';
import '../services/api_service.dart'; // ApiService dosyanın doğru yolunu ekle
import '../Pages/App_select.dart'; // Başarılı girişte gidilecek sayfa


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Backend "Email" beklediği için isimlendirmeyi emailController yapman daha iyi olur
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService _apiService = ApiService(); // Servis nesnemizi oluşturduk

  InputDecoration inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey.shade100,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
    );
  }

  // Giriş işlemini yöneten yeni fonksiyon
  void _handleLogin() async {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanları doldurun')),
      );
      return;
    }

    // Backend'e istek atıyoruz
    final user = await _apiService.login(email, password);

    if (user != null && user["id"] != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AppSelect(userId: user["id"]), // ❗ const YOK
        ),
      );
    }
    else {
      // Hata durumunda uyarı ver
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('E-posta veya şifre hatalı!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giriş Yap')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: inputStyle('E-posta Adresi'), // Backend Email bekliyor
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: inputStyle('Şifre'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleLogin, // Fonksiyonu buraya bağladık
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Giriş Yap'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}