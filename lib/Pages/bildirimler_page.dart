import 'package:flutter/material.dart';

class BildirimlerPage extends StatelessWidget {
  const BildirimlerPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF1E3C72);

    final List<Map<String, String>> bildirimler = [
      {
        "baslik": "Yeni Talep!",
        "mesaj": "Ahmet Yılmaz buzdolabı tamiri için talep oluşturdu.",
        "zaman": "5 dk önce",
        "tur": "yeni"
      },
      {
        "baslik": "Teklif Onaylandı",
        "mesaj": "Selin Demir verdiğiniz 850₺'lik teklifi onayladı.",
        "zaman": "2 saat önce",
        "tur": "onay"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bildirimler", style: TextStyle(color: Colors.white)),
        backgroundColor: primaryBlue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: bildirimler.isEmpty
          ? const Center(child: Text("Henüz bir bildirim yok."))
          : ListView.builder(
        itemCount: bildirimler.length,
        itemBuilder: (context, index) {
          final b = bildirimler[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: b['tur'] == 'yeni' ? Colors.blue.shade100 : Colors.green.shade100,
                child: Icon(
                  b['tur'] == 'yeni' ? Icons.fiber_new : Icons.check_circle,
                  color: b['tur'] == 'yeni' ? Colors.blue : Colors.green,
                ),
              ),
              title: Text(b['baslik']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(b['mesaj']!),
              trailing: Text(b['zaman']!, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              onTap: () {
                // Bildirime tıklayınca yapılacak işlem
              },
            ),
          );
        },
      ),
    );
  }
}