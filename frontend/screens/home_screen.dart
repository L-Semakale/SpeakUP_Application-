import 'package:flutter/material.dart';

/// Home screen for the SpeakUp mental health app
/// Features mood tracking, quick actions, motivational content, and progress tracking
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // State variables for mood tracking and UI
  double _moodValue = 5; // Current mood value (0-10 scale)
  int _currentIndex = 0; // Bottom navigation current index
  late AnimationController _animationController; // For fade animations
  late Animation<double> _fadeAnimation; // Fade animation for screen entrance
  bool _moodSaved = false; // Tracks if current mood has been saved

  // Mood labels corresponding to values 0-10
  final List<String> moodLabels = [
    "😞 Very Low",
    "😔 Low",
    "😕 Below Average",
    "😐 Neutral",
    "🙂 Okay",
    "😊 Good",
    "😄 Great",
    "🤗 Very Good",
    "😁 Excellent",
    "🥰 Amazing",
    "🌟 Outstanding"
  ];

  // Motivational quotes based on mood ranges
  final List<Map<String, dynamic>> motivationalQuotes = [
    {
      "quote": "Every small step forward is progress worth celebrating.",
      "mood_range": [0, 3]
    },
    {
      "quote": "You are stronger than you think, braver than you feel.",
      "mood_range": [0, 4]
    },
    {
      "quote": "It's okay to not be okay. Tomorrow is a new day.",
      "mood_range": [0, 5]
    },
    {
      "quote": "Your feelings are valid, and you deserve support.",
      "mood_range": [3, 7]
    },
    {
      "quote": "Taking care of yourself is not selfish—it's necessary.",
      "mood_range": [4, 8]
    },
    {
      "quote": "You're doing better than you think you are.",
      "mood_range": [5, 8]
    },
    {
      "quote": "Your positive energy is contagious. Keep shining!",
      "mood_range": [7, 10]
    },
    {
      "quote": "Great job taking care of your mental health today!",
      "mood_range": [8, 10]
    },
  ];

  // Quick action buttons configuration
  final List<Map<String, dynamic>> quickActions = [
    {
      "icon": Icons.chat_bubble_outline,
      "title": "Start Chat",
      "subtitle": "Connect with community",
      "route": "/community_feed",
      "color": Colors.blue,
      "urgent": false
    },
    {
      "icon": Icons.psychology,
      "title": "Get Support",
      "subtitle": "Professional help",
      "route": "/professional_support",
      "color": Colors.green,
      "urgent": false
    },
    {
      "icon": Icons.insights,
      "title": "Daily Insights",
      "subtitle": "Track your progress",
      "route": "/mood_insights",
      "color": Colors.purple,
      "urgent": false
    },
    {
      "icon": Icons.emergency,
      "title": "Crisis Help",
      "subtitle": "24/7 support available",
      "route": "/crisis_support",
      "color": Colors.red,
      "urgent": true // Marked as urgent for special styling
    },
  ];

  @override
  void initState() {
    super.initState();
    // Initialize fade animation for smooth screen entrance
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Returns the mood label for a given mood value
  String getMoodLabel(double value) {
    int index = value.clamp(0, 10).round();
    return moodLabels[index];
  }

  /// Returns an appropriate motivational quote based on mood value
  String getMoodQuote(double value) {
    var suitableQuotes = motivationalQuotes.where((quote) {
      return value >= quote["mood_range"][0] && value <= quote["mood_range"][1];
    }).toList();

    if (suitableQuotes.isEmpty) {
      return "You are not alone. You are seen. You are heard.";
    }

    // Use day of month to rotate through quotes
    return suitableQuotes[DateTime.now().day % suitableQuotes.length]["quote"];
  }

  /// Returns color based on mood value (red for low, green for high)
  Color getMoodColor(double value) {
    if (value <= 3) return Colors.red.shade300;
    if (value <= 5) return Colors.orange.shade300;
    if (value <= 7) return Colors.yellow.shade300;
    if (value <= 8) return Colors.lightGreen.shade300;
    return Colors.green.shade300;
  }

  /// Saves the current mood entry and shows confirmation
  void _saveMoodEntry() {
    setState(() {
      _moodSaved = true;
    });

    // Show success snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text("Mood saved: ${getMoodLabel(_moodValue)}"),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );

    // Reset saved state after 3 seconds to allow saving again
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _moodSaved = false;
        });
      }
    });
  }

  /// Handles navigation to different screens
  void _navigateToScreen(String route) {
    if (route == "/crisis_support") {
      // Show emergency dialog first for crisis support
      _showCrisisDialog();
    } else {
      Navigator.pushNamed(context, route);
    }
  }

  /// Shows crisis support dialog with emergency information
  void _showCrisisDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Crisis Support"),
        content: const Text(
          "If you're in immediate danger, please call emergency services (911).\n\nWould you like to access crisis support resources?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/crisis_support");
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child:
            const Text("Get Help", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Extract user name from navigation arguments
    final String fullName =
        ModalRoute.of(context)?.settings.arguments as String? ?? 'User';

    // Determine time of day for greeting
    final DateTime now = DateTime.now();
    final String timeOfDay = now.hour < 12
        ? 'Morning'
        : now.hour < 17
        ? 'Afternoon'
        : 'Evening';

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("SpeakUp",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: RefreshIndicator(
          onRefresh: () async {
            // Simulate refresh with 1 second delay
            await Future.delayed(const Duration(seconds: 1));
            setState(() {});
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                _buildWelcomeSection(fullName, timeOfDay),
                const SizedBox(height: 24),

                // Mood Tracking Section
                _buildMoodTrackingSection(),
                const SizedBox(height: 24),

                // Quick Actions Section
                _buildQuickActionsSection(),
                const SizedBox(height: 24),

                // Daily Motivation Section
                _buildMotivationSection(),
                const SizedBox(height: 24),

                // Recent Activity Summary
                _buildRecentActivitySection(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  /// Builds the welcome section with personalized greeting
  Widget _buildWelcomeSection(String fullName, String timeOfDay) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.shade400, Colors.indigo.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good $timeOfDay, $fullName! 👋',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "How are you feeling today?",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the mood tracking section with slider and save button
  Widget _buildMoodTrackingSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Daily Mood Check-in",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // Mood Slider with custom styling
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
            ),
            child: Slider(
              value: _moodValue,
              min: 0,
              max: 10,
              divisions: 10,
              label: _moodValue.toStringAsFixed(0),
              activeColor: getMoodColor(_moodValue),
              inactiveColor: Colors.grey.shade300,
              onChanged: (value) {
                setState(() {
                  _moodValue = value;
                  _moodSaved = false; // Reset saved state when mood changes
                });
              },
            ),
          ),

          // Mood display and save button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Mood: ${getMoodLabel(_moodValue)}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _moodSaved ? null : _saveMoodEntry,
                icon: Icon(_moodSaved ? Icons.check : Icons.save_alt),
                label: Text(_moodSaved ? "Saved" : "Save"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _moodSaved ? Colors.green : Colors.indigo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the quick actions grid section
  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Quick Actions",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.1, // Adjusted for better content fit
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: quickActions.length,
          itemBuilder: (context, index) {
            final action = quickActions[index];
            return _buildQuickActionCard(action);
          },
        ),
      ],
    );
  }

  /// Builds individual quick action cards for the home screen grid
  /// Fixes overflow issues by properly constraining content and reducing sizes
  Widget _buildQuickActionCard(Map<String, dynamic> action) {
    return GestureDetector(
      onTap: () => _navigateToScreen(action["route"]),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          // Add red border for urgent actions (like Crisis Help)
          border: action["urgent"]
              ? Border.all(color: Colors.red.shade300, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              // Different shadow colors for urgent vs normal actions
              color: action["urgent"]
                  ? Colors.red.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding:
          const EdgeInsets.all(12), // Reduced from 16 to 12 to save space
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize
                .min, // CRITICAL: Prevents overflow by using minimum space
            children: [
              // Icon container with background color
              Container(
                padding: const EdgeInsets.all(
                    10), // Reduced from 12 to 10 to save space
                decoration: BoxDecoration(
                  color: action["color"].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  action["icon"],
                  size: 24, // Reduced from 28 to 24 to save space
                  color: action["color"],
                ),
              ),
              const SizedBox(height: 8), // Reduced from 12 to 8 to save space

              // Title text - wrapped in Flexible to prevent overflow
              Flexible(
                // CRITICAL: Allows text to shrink if needed
                child: Text(
                  action["title"],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13, // Reduced from 14 to 13 to save space
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2, // Limit to 2 lines to prevent overflow
                  overflow:
                  TextOverflow.ellipsis, // Show "..." if text is too long
                ),
              ),
              const SizedBox(height: 2), // Reduced from 4 to 2 to save space

              // Subtitle text - wrapped in Flexible to prevent overflow
              Flexible(
                // CRITICAL: Allows text to shrink if needed
                child: Text(
                  action["subtitle"],
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 11, // Reduced from 12 to 11 to save space
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2, // Limit to 2 lines to prevent overflow
                  overflow:
                  TextOverflow.ellipsis, // Show "..." if text is too long
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the motivation section with mood-based quotes
  Widget _buildMotivationSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [getMoodColor(_moodValue).withOpacity(0.1), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: getMoodColor(_moodValue).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.format_quote,
                color: getMoodColor(_moodValue),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                "Today's Motivation",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            getMoodQuote(_moodValue),
            style: const TextStyle(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the recent activity/progress section
  Widget _buildRecentActivitySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Your Progress",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildProgressItem("Days Active", "7", Icons.calendar_today),
              _buildProgressItem("Mood Entries", "5", Icons.mood),
              _buildProgressItem("Support Used", "3", Icons.support_agent),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds individual progress items for the activity section
  Widget _buildProgressItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.indigo.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.indigo, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  /// Builds the bottom navigation bar
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() => _currentIndex = index);

          // Navigate based on selected tab
          switch (index) {
            case 0:
            // Already on home - no action needed
              break;
            case 1:
              Navigator.pushNamed(context, '/profile');
              break;
            case 2:
              Navigator.pushNamed(context, '/settings');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
