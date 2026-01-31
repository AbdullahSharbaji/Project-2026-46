import 'package:flutter/material.dart';
import 'package:project46/Pages/CagirGelsin_Page.dart';
import 'package:project46/Pages/Hizmet_page.dart';

class AppSelect extends StatefulWidget {
  final int userId;
  const AppSelect({super.key, required this.userId});

  @override
  State<AppSelect> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<AppSelect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text("CagirGelsin"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CagirGelsin()),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text("Hizmet Cagir"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HizmetPage(userId: widget.userId), // ✅
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
