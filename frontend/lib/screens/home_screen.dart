import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../blocs/auth_bloc.dart';
import '../blocs/post_bloc.dart';
import 'welcome_screen.dart';
import 'login_screen.dart';
import 'profile_setup_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _darkMode = false;
  bool _notifications = true;
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
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool('dark_mode') ?? false;
      _notifications = prefs.getBool('notifications') ?? true;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', _darkMode);
    await prefs.setBool('notifications', _notifications);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(['Community', 'Support', 'Profile'][_currentIndex]),
        actions: _currentIndex == 0 ? [
          IconButton(icon: const Icon(Icons.add), onPressed: _showAddPostDialog),
        ] : null,
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Community'),
          BottomNavigationBarItem(icon: Icon(Icons.support_agent), label: 'Support'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0: return _buildCommunityTab();
      case 1: return _buildSupportTab();
      case 2: return _buildProfileTab();
      default: return _buildCommunityTab();
    }
  }

  Widget _buildCommunityTab() {
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
                          Text(post['userName'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(post['time'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
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

  Widget _buildSupportTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Professional Support', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildSupportCard('Crisis Hotlines', 'National Suicide Prevention: 988', Icons.phone),
        _buildSupportCard('Talk to a Therapist', 'Connect with professionals', Icons.psychology),
        _buildSupportCard('Coping Strategies', 'Learn healthy mechanisms', Icons.self_improvement),
      ],
    );
  }

  Widget _buildSupportCard(String title, String subtitle, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, size: 32, color: Theme.of(context).primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title feature')),
        ),
      ),
    );
  }

  Widget _buildProfileTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(radius: 30, child: Text(widget.userName[0].toUpperCase(), style: const TextStyle(fontSize: 24))),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.userName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const Text('Member since today', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              (route) => false,
            ),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Logout'),
          ),
        ),
      ],
    );
  }

  void _showAddPostDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Your Thoughts'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(hintText: 'What\'s on your mind?', border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  _posts.insert(0, {
                    'userName': widget.userName,
                    'content': controller.text,
                    'likes': 0,
                    'time': 'now',
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }
}
