import 'package:flutter/material.dart';

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
  final TextEditingController retypePasswordController =
      TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: inputStyle('Name'),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: surnameController,
              decoration: inputStyle('Surname'),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: inputStyle('Phone Number'),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: birthdateController,
              readOnly: true,
              decoration: inputStyle('Birthdate'),
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2000),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  birthdateController.text =
                      "${picked.day}/${picked.month}/${picked.year}";
                }
              },
            ),
            const SizedBox(height: 12),

            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: inputStyle('Email (optional)'),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: inputStyle('Password'),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: retypePasswordController,
              obscureText: true,
              decoration: inputStyle('Retype Password'),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                if (passwordController.text != retypePasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Passwords do not match')),
                  );
                  return;
                }

                // submit logic here
                print(nameController.text);
                print(surnameController.text);
                print(phoneController.text);
                print(birthdateController.text);
                print(emailController.text);
              },
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}
