import 'package:flutter/material.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF1E3C72);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Bilgileri", style: TextStyle(color: Colors.white)),
        backgroundColor: primaryBlue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 55,
              backgroundColor: primaryBlue,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 30),

            _profilBilgiKarti("Ad Soyad", "Mustafa Yılmaz", Icons.person_outline),
            _profilBilgiKarti("Dükkan Adı", "Lider Teknik Servis", Icons.storefront),
            _profilBilgiKarti("E-Posta", "mustafa@usta.com", Icons.alternate_email),
            _profilBilgiKarti("Telefon", "+90 555 123 4567", Icons.phone_android),
            _profilBilgiKarti("Adres", "Çankaya Mah. 46. Sokak, Ankara", Icons.map_outlined),

            const SizedBox(height: 40),

            // Düzenle Butonu
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: primaryBlue),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("PROFİLİ DÜZENLE", style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 12),

            // Çıkış Butonu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("ÇIKIŞ YAP", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profilBilgiKarti(String baslik, String icerik, IconData ikon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(ikon, color: const Color(0xFF1E3C72)),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(baslik, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(icerik, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}