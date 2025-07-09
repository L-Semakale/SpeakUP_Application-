import 'package:flutter/material.dart';
import 'create_post.dart';
import 'professional_support.dart';
import 'resources_screen.dart';
import 'app_setting.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _posts = [
    {
      'userName': 'Anonymous User',
      'content': 'Feeling anxious today, but trying to stay positive 💪',
      'likes': 5,
      'time': '2h ago',
    },
    {
      'userName': 'Hope Seeker',
      'content': 'Had a great therapy session. Progress is slow but steady.',
      'likes': 8,
      'time': '4h ago',
    },
    {
      'userName': 'Mindful Soul',
      'content': 'Remember: It\'s okay to not be okay sometimes. 🌱',
      'likes': 12,
      'time': '6h ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('SpeakUp'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AppSettingsScreen(
                  isDarkMode: false,
                  onThemeChanged: (val) {},
                ),
              ),
            ),
          ),
        ],
      ),
      body: _buildHomeTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreatePost()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SupportScreen()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ResourcesScreen()),
            );
          }
        },
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Post'),
          BottomNavigationBarItem(icon: Icon(Icons.heat_pump_rounded), label: 'Support'),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Resources',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        final post = _posts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(child: Text(post['userName'][0])),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post['userName'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            post['time'],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(post['content']),
                const SizedBox(height: 12),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {
                        setState(() => post['likes']++);
                      },
                    ),
                    Text('${post['likes']}'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
