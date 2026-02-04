import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final phoneController = TextEditingController();
  final birthdateController = TextEditingController();
  final otpController = TextEditingController();

  DateTime? selectedDate;

  Future<void> _pickBirthdate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        birthdateController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Phone + Send Code
            Row(
              children: [
                Expanded(
                  child: _inputField(
                    controller: phoneController,
                    label: 'Phone Number',
                    keyboardType: TextInputType.phone,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // TODO: send OTP
                  },
                  child: const Text('Send'),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Birthdate picker
            TextField(
              controller: birthdateController,
              readOnly: true,
              onTap: _pickBirthdate,
              decoration: InputDecoration(
                labelText: 'Birthdate',
                filled: true,
                fillColor: Colors.grey.shade100,
                suffixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// OTP
            _inputField(
              controller: otpController,
              label: 'OTP Code',
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: verify OTP
                },
                child: const Text('Verify'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
