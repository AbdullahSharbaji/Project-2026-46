import 'package:flutter/material.dart';

class Bildirimler extends StatefulWidget {
  const Bildirimler({super.key});

  @override
  State<Bildirimler> createState() => _BildirimlerState();
}

class _BildirimlerState extends State<Bildirimler> {
  final List<Map<String, dynamic>> _notifications = [
    {
      "title": "Yeni Teklif!",
      "message": "Boya Badana talebiniz için yeni bir teklif geldi.",
      "time": "5 dk önce",
      "isRead": false,
      "icon": Icons.local_offer,
    },
    {
      "title": "Talep Tamamlandı",
      "message": "Su Tesisatı hizmeti başarıyla tamamlandı.",
      "time": "2 saat önce",
      "isRead": true,
      "icon": Icons.check_circle,
    },
    {
      "title": "Hatırlatma",
      "message": "Yarın saat 10:00'da randevunuz bulunmaktadır.",
      "time": "1 gün önce",
      "isRead": true,
      "icon": Icons.access_time,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Bildirimler', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E3C72),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () {
              setState(() {
                for (var n in _notifications) {
                  n['isRead'] = true;
                }
              });
            },
            tooltip: 'Hepsini Okundu İşaretle',
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Bildirim bulunamadı', style: TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final n = _notifications[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: n['isRead'] ? Colors.grey.shade100 : Colors.blue.shade50,
                      child: Icon(n['icon'], color: n['isRead'] ? Colors.grey : Colors.blue),
                    ),
                    title: Text(
                      n['title'],
                      style: TextStyle(
                        fontWeight: n['isRead'] ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(n['message']),
                        const SizedBox(height: 4),
                        Text(
                          n['time'],
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    trailing: n['isRead']
                        ? null
                        : Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                    onTap: () {
                      setState(() {
                        n['isRead'] = true;
                      });
                    },
                  ),
                );
              },
            ),
    );
  }
}
