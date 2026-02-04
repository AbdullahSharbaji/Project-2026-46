import 'package:flutter/material.dart';

class KategorikTemp extends StatefulWidget {
  final String categoryName;

  const KategorikTemp({super.key, required this.categoryName});

  @override
  State<KategorikTemp> createState() => _KategorikTempState();
}

class _KategorikTempState extends State<KategorikTemp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 100, color: Colors.blue.shade200),
            const SizedBox(height: 20),
            Text(
              '${widget.categoryName} Hizmeti',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text('Lütfen bir alt kategori seçin veya talep oluşturun.'),
          ],
        ),
      ),
    );
  }
}
