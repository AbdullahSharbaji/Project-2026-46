import 'package:flutter/material.dart';
import 'MenuGridPage.dart';

class CagirGelsin extends StatefulWidget {
  const CagirGelsin({super.key});

  @override
  State<CagirGelsin> createState() => _CagirGelsinState();
}

class _CagirGelsinState extends State<CagirGelsin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Çağır Gelsin"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF141E30), // Dark Blue/Grey
              Color(0xFF243B55), // Lighter Blue/Grey
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Ne İstersin?",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 48),

              // ==============================
              // TRIANGLE LAYOUT
              // ==============================
              
              // 1. TOP BUTTON (Market)
              _buildHexButton(
                context,
                title: "Market",
                icon: Icons.shopping_basket_rounded,
                color: const Color(0xFFF7971E), // Orange/Gold
                gradientColors: [const Color(0xFFFFD200), const Color(0xFFF7971E)],
                onTap: () {
                  // Navigate to Market Menu
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MenuGridPage(pageTitle: "Market"),
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),

              // 2. BOTTOM ROW (Restoran & Ozel)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Restoran
                  _buildHexButton(
                    context,
                    title: "Restoran",
                    icon: Icons.restaurant_menu_rounded, // Fork & Knife alternative
                    color: const Color(0xFFFF512F), // Red/Orange
                    gradientColors: [const Color(0xFFDD2476), const Color(0xFFFF512F)],
                    onTap: () {
                      // Navigate to Restaurant Menu
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MenuGridPage(pageTitle: "Restoran"),
                        ),
                      );
                    },
                  ),

                  const SizedBox(width: 32),

                  // Ozel
                  _buildHexButton(
                    context,
                    title: "Özel",
                    icon: Icons.add_rounded,
                    color: const Color(0xFF1D976C), // Green
                    gradientColors: [const Color(0xFF93F9B9), const Color(0xFF1D976C)],
                    onTap: () {
                      // Placeholder for Ozel (Configured Later)
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Bu özellik yakında eklenecek!")),
                      );
                    },
                  ),
                ],
              ),
              
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHexButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle, // Using Circle for modern look (Hexagon is harder without custom clipper)
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.5),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
            ),
            child: Icon(
              icon,
              size: 48,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
