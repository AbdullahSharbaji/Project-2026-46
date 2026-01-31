import 'package:flutter/material.dart';
import 'package:project46/Creds/forgot_password.dart';
import 'package:project46/Pages/App_select.dart';
import 'Creds/login_page.dart';
import 'Creds/signup_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hizmet Uygulaması')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              child: const Text('Giriş Yap'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text('Üye Ol'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignupPage()),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text("Şifremi Unuttum"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text("Skip For Test (Direct App)"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AppSelect(userId: 1), // ✅ test için
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
