import 'package:flutter/material.dart';

class CagirGelsin extends StatefulWidget {
  const CagirGelsin({super.key});

  @override
  State<CagirGelsin> createState() => _CagirGelsinState();
}

class _CagirGelsinState extends State<CagirGelsin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cagir Gelsin')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              child: const Text("Market"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CagirGelsin()),
                );
              },
            ),
            ElevatedButton(
              child: const Text("Restoran"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CagirGelsin()),
                );
              },
            ),
            ElevatedButton(
              child: const Text("Ozel"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CagirGelsin()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
