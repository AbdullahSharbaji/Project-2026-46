import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:project46/Creds/edit_profile.dart';

class ProfilePage extends StatefulWidget {
  final int userId;
  const ProfilePage({super.key, required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _apiService.getUserById(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Profil bilgisi yüklenemedi"));
          }

          final user = snapshot.data!;
          final fullName = (user["fullName"] ?? "").toString();
          final email = (user["email"] ?? "").toString();
          final phone = (user["phoneNumber"] ?? "—").toString();

          final birthDate = user["birthDate"] != null
              ? DateTime.tryParse(user["birthDate"].toString())
              : null;

          final birthDateText = birthDate != null
              ? "${birthDate.day}/${birthDate.month}/${birthDate.year}"
              : "—";

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue.shade100,
                  child: const Icon(Icons.person, size: 60, color: Colors.blue),
                ),
                const SizedBox(height: 16),

                Text(
                  fullName,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),

                Text(email, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 24),

                _infoTile(Icons.phone, 'Phone', phone),
                _infoTile(Icons.cake, 'Birthdate', birthDateText),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EditProfilePage()),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Profile'),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}
