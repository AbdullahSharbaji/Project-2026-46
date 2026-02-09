import 'package:flutter/material.dart';
import 'package:project46/services/api_service.dart';
import 'usta_panel_page.dart';
import 'signup_page.dart';

class LoginPage1 extends StatefulWidget {
  const LoginPage1({super.key});

  @override
  State<LoginPage1> createState() => _LoginPage1State();
}

class _LoginPage1State extends State<LoginPage1> {
  final ApiService _api = ApiService();

  final TextEditingController _taxController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool _loading = false;

  Future<void> _doLogin() async {
    final taxNo = _taxController.text.trim();
    final pass = _passController.text.trim();

    if (taxNo.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vergi No ve Şifre zorunlu")),
      );
      return;
    }

    setState(() => _loading = true);

    final data = await _api.loginWorker(taxNumber: taxNo, password: pass);

    setState(() => _loading = false);

    if (!mounted) return;

    if (data != null) {
      final workerId = data["workerId"] ?? data["id"];
      final category = (data["category"] ?? "").toString();

      if (workerId == null || category.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Worker bilgisi eksik (id/category)")),
        );
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => UstaPanelPage(
            workerId: workerId,
            category: category,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vergi No veya şifre yanlış")),
      );
    }
  }

  @override
  void dispose() {
    _taxController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF2B4C8C);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: const BoxDecoration(
                    color: primaryBlue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.build, size: 50, color: Colors.white),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Usta Girişi",
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const Text(
                          "Giriş Yapın Devam Edin",
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 20,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              child: Column(
                children: [
                  _buildTextField(
                    controller: _taxController,
                    hint: "Vergi Numarası",
                    icon: Icons.description_outlined,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _passController,
                    hint: "Şifre",
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text("Şifremi Unuttum?", style: TextStyle(color: primaryBlue, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 5,
                      ),
                      onPressed: _loading ? null : _doLogin,
                      child: _loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("GİRİŞ YAP", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Hesabınız yok mu? ", style: TextStyle(color: Colors.grey)),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupPage())),
                        child: const Text("Kayıt Ol", style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Divider(),

                  TextButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UstaPanelPage(
                          workerId: 1,
                          category: "Elektrikçi",
                        ),
                      ),
                    ),
                    child: const Text("Test için Atla >>", style: TextStyle(color: Colors.grey)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black12),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.grey[600]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}
