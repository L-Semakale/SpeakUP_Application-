import 'package:flutter/material.dart';

class ResourcesPage extends StatelessWidget {
  const ResourcesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Resources"),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
          const CircleAvatar(
            radius: 16,
            backgroundImage: AssetImage('assets/profile.jpg'), // Replace with your image
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Feeling Overwhelmed Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.indigo.shade400,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Feeling Overwhelmed?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Explore our curated guide to calm your mind and find inner peace.",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: () {},
                    child: const Text("Start Your Journey", style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Daily Insights
            _sectionTitle("Daily Insights", onTap: () {}),
            const SizedBox(height: 8),
            _resourceCards(),

            const SizedBox(height: 24),

            // Coping Strategies
            _sectionTitle("Coping Strategies", onTap: () {}),
            const SizedBox(height: 8),
            _resourceCards(),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, {required VoidCallback onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        GestureDetector(
          onTap: onTap,
          child: const Text("Show More", style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }

  Widget _resourceCards() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 120,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(child: Icon(Icons.image, size: 40, color: Colors.grey)),
          ),
        ),
        Expanded(
          child: Container(
            height: 120,
            margin: const EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(child: Icon(Icons.image, size: 40, color: Colors.grey)),
          ),
        ),
      ],
    );
  }
}
