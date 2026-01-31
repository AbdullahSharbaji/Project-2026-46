import 'package:flutter/material.dart';
import '../services/api_service.dart'; // ApiService yolunu kontrol et
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController retypePasswordController = TextEditingController();

  final ApiService _apiService = ApiService(); // Servis bağlantısı

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

  // Kayıt işlemini yöneten fonksiyon
  void _handleSignup() async {
    // Şifre kontrolü
    if (passwordController.text != retypePasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Şifreler eşleşmiyor!')),
      );
      return;
    }

    // Zorunlu alanlar (istersen phone ve birthdate'i de zorunlu yaparız)
    if (nameController.text.trim().isEmpty ||
        surnameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen zorunlu alanları doldurun')),
      );
      return;
    }

    // Doğum tarihi: "gün/ay/yıl" -> DateTime
    DateTime? parsedBirthDate;
    if (birthdateController.text.trim().isNotEmpty) {
      final parts = birthdateController.text.split('/');
      if (parts.length == 3) {
        final day = int.tryParse(parts[0]);
        final month = int.tryParse(parts[1]);
        final year = int.tryParse(parts[2]);
        if (day != null && month != null && year != null) {
          parsedBirthDate = DateTime(year, month, day);
        }
      }
    }

    // ✅ Yeni Register: Ad/Soyad/Telefon/DoğumTarihi ayrı gönder
    bool success = await _apiService.register(
      firstName: nameController.text.trim(),
      lastName: surnameController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      birthDate: parsedBirthDate,
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kayıt başarılı! Giriş yapabilirsiniz.')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kayıt başarısız. Bağlantıyı veya verileri kontrol edin.')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Üye Ol')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: inputStyle('Ad')),
            const SizedBox(height: 12),
            TextField(controller: surnameController, decoration: inputStyle('Soyad')),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: inputStyle('Telefon Numarası'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: birthdateController,
              readOnly: true,
              decoration: inputStyle('Doğum Tarihi'),
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2000),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() {
                    birthdateController.text = "${picked.day}/${picked.month}/${picked.year}";
                  });
                }
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: inputStyle('E-posta'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: inputStyle('Şifre'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: retypePasswordController,
              obscureText: true,
              decoration: inputStyle('Şifre Tekrar'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _handleSignup, // Fonksiyon bağlandı
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Hesap Oluştur'),
            ),
          ],
        ),
      ),
    );
  }
}