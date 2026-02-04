import 'package:flutter/material.dart';

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({super.key});

  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final newPasswordController = TextEditingController();
  final retypePasswordController = TextEditingController();

  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Password')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _passwordField(
              controller: newPasswordController,
              label: 'New Password',
            ),

            const SizedBox(height: 16),

            _passwordField(
              controller: retypePasswordController,
              label: 'Retype New Password',
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: update password
                },
                child: const Text('Update Password'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      obscureText: hidePassword,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade100,
        suffixIcon: IconButton(
          icon: Icon(hidePassword ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              hidePassword = !hidePassword;
            });
          },
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
