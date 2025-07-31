import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({Key? key}) : super(key: key);

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen>
    with TickerProviderStateMixin {
  final _displayNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _contactNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int _selectedAvatar = 0;
  String _selectedAgeRange = '';
  final List<String> _selectedGoals = [];
  final List<String> _selectedSupport = [];

  final List<Map<String, dynamic>> _avatarOptions = [
    {'emoji': '🌸', 'color': Color(0xFFE91E63)},
    {'emoji': '🌟', 'color': Color(0xFF667EEA)},
    {'emoji': '🧘', 'color': Color(0xFF4CAF50)},
    {'emoji': '💜', 'color': Color(0xFF9C27B0)},
    {'emoji': '🌙', 'color': Color(0xFF3F51B5)},
    {'emoji': '🌱', 'color': Color(0xFF8BC34A)},
  ];

  final List<Map<String, dynamic>> _goals = [
    {
      'title': 'Manage Anxiety',
      'icon': Icons.psychology,
      'color': Color(0xFF667EEA),
    },
    {
      'title': 'Find Community',
      'icon': Icons.group,
      'color': Color(0xFF4CAF50),
    },
    {
      'title': 'Improve Sleep',
      'icon': Icons.bedtime,
      'color': Color(0xFF9C27B0),
    },
    {
      'title': 'Overcome Depression',
      'icon': Icons.favorite,
      'color': Color(0xFFE91E63),
    },
    {
      'title': 'Professional Help',
      'icon': Icons.medical_services,
      'color': Color(0xFFFF9800),
    },
    {
      'title': 'Stress Management',
      'icon': Icons.self_improvement,
      'color': Color(0xFF00BCD4),
    },
  ];

  final List<Map<String, dynamic>> _supportTypes = [
    {
      'title': 'Peer Support',
      'subtitle': 'Connect with others who understand your journey',
      'icon': Icons.group,
      'color': Color(0xFF667EEA),
    },
    {
      'title': 'Professional Guidance',
      'subtitle': 'Access to licensed therapists and counselors',
      'icon': Icons.psychology,
      'color': Color(0xFF4CAF50),
    },
    {
      'title': 'Educational Resources',
      'subtitle': 'Articles, videos, and tools for self-improvement',
      'icon': Icons.school,
      'color': Color(0xFF9C27B0),
    },
    {
      'title': 'Crisis Support',
      'subtitle': '24/7 access to emergency mental health resources',
      'icon': Icons.emergency,
      'color': Color(0xFFE53E3E),
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutQuart,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _displayNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _contactNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(opacity: _fadeAnimation, child: child),
              );
            },
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    _buildHeader(),
                    const SizedBox(height: 32),

                    // Main Content Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Display Name Section
                          _buildPersonalDetailsSection(),
                          const SizedBox(height: 32),

                          // Avatar Selection
                          _buildAvatarSection(),
                          const SizedBox(height: 32),

                          // Age Range Selection
                          _buildAgeRangeSection(),
                          const SizedBox(height: 32),

                          // Goals Section
                          _buildGoalsSection(),
                          const SizedBox(height: 32),

                          // Support Types Section
                          _buildSupportSection(),
                          const SizedBox(height: 32),

                          // Emergency Contacts Section
                          _buildEmergencyContactsSection(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Continue Button
                    _buildContinueButton(),
                    const SizedBox(height: 16),

                    // Skip Option
                    _buildSkipOption(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.person_add,
                color: Colors.white,
                size: 24,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Step 1 of 1',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Let\'s personalize your\nSpeakUp journey! 🌟',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: const Text(
            '🔒 All information is private and secure',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Personal Details',
          'Choose a display name, enter your email, and create your password',
          Icons.person,
          const Color(0xFF667EEA),
        ),
        const SizedBox(height: 16),

        // Display Name Field
        TextFormField(
          controller: _displayNameController,
          decoration: InputDecoration(
            hintText: 'Enter your preferred name',
            prefixIcon: const Icon(
              Icons.person_outline,
              color: Color(0xFF667EEA),
            ),
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF667EEA), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Email Field
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'Enter your email',
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: Color(0xFF667EEA),
            ),
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF667EEA), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Password Field
        TextFormField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Create a password',
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: Color(0xFF667EEA),
            ),
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF667EEA), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Confirm Password Field
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Confirm your password',
            prefixIcon: const Icon(
              Icons.lock_person_outlined,
              color: Color(0xFF667EEA),
            ),
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF667EEA), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Choose your avatar',
          'Pick one that represents you',
          Icons.face,
          Color(0xFF4CAF50),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: _avatarOptions.length,
          itemBuilder: (context, index) {
            final avatar = _avatarOptions[index];
            final isSelected = _selectedAvatar == index;

            return GestureDetector(
              onTap: () => setState(() => _selectedAvatar = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected
                      ? avatar['color'].withOpacity(0.1)
                      : const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? avatar['color'] : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: avatar['color'].withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    avatar['emoji'],
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAgeRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Age range',
          'Help us personalize your experience',
          Icons.calendar_today,
          Color(0xFF9C27B0),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              hint: const Text(
                'Select your age range',
                style: TextStyle(color: Color(0xFF636E72)),
              ),
              value: _selectedAgeRange.isEmpty ? null : _selectedAgeRange,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF667EEA),
              ),
              items: ['18-25', '26-35', '36-45', '46-55', '56-65', '65+'].map((
                String value,
              ) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(color: Color(0xFF2D3436)),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() => _selectedAgeRange = newValue ?? '');
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoalsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'What are your goals?',
          'Select what you\'d like to focus on',
          Icons.flag,
          Color(0xFFE91E63),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _goals.map((goal) {
            final isSelected = _selectedGoals.contains(goal['title']);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedGoals.remove(goal['title']);
                  } else {
                    _selectedGoals.add(goal['title']);
                  }
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? goal['color'].withOpacity(0.1)
                      : const Color(0xFFF8F9FA),
                  border: Border.all(
                    color: isSelected ? goal['color'] : Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      goal['icon'],
                      size: 16,
                      color: isSelected
                          ? goal['color']
                          : const Color(0xFF636E72),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      goal['title'],
                      style: TextStyle(
                        color: isSelected
                            ? goal['color']
                            : const Color(0xFF2D3436),
                        fontSize: 14,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'How can we support you?',
          'Choose the types of support you need',
          Icons.favorite,
          Color(0xFFFF9800),
        ),
        const SizedBox(height: 16),
        Column(
          children: _supportTypes.map((support) {
            final isSelected = _selectedSupport.contains(support['title']);
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedSupport.remove(support['title']);
                    } else {
                      _selectedSupport.add(support['title']);
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? support['color'].withOpacity(0.1)
                        : const Color(0xFFF8F9FA),
                    border: Border.all(
                      color: isSelected
                          ? support['color']
                          : Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? support['color'].withOpacity(0.2)
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          support['icon'],
                          color: isSelected
                              ? support['color']
                              : const Color(0xFF636E72),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              support['title'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? support['color']
                                    : const Color(0xFF2D3436),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              support['subtitle'],
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF636E72),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check_circle,
                          color: support['color'],
                          size: 20,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEmergencyContactsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Emergency contacts',
          'Optional but recommended for safety',
          Icons.emergency,
          Color(0xFFE53E3E),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _contactNameController,
          decoration: InputDecoration(
            hintText: 'Trusted contact name',
            prefixIcon: const Icon(
              Icons.person_outline,
              color: Color(0xFFE53E3E),
            ),
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE53E3E), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: 'Phone number',
            prefixIcon: const Icon(
              Icons.phone_outlined,
              color: Color(0xFFE53E3E),
            ),
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE53E3E), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 14, color: Color(0xFF636E72)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () async {
          if (!_formKey.currentState!.validate()) return;

          // Show loading indicator here if you want

          try {
            // 1. Register user with Firebase Auth
            UserCredential credential = await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim(),
                );

            User? user = credential.user;

            // 2. Update display name in Firebase Auth profile
            await user?.updateDisplayName(_displayNameController.text.trim());

            // 3. Prepare user profile data for Firestore
            Map<String, dynamic> userProfile = {
              'displayName': _displayNameController.text.trim(),
              'email': _emailController.text.trim(),
              'avatar': _avatarOptions[_selectedAvatar]['emoji'],
              'ageRange': _selectedAgeRange,
              'goals': _selectedGoals,
              'supportTypes': _selectedSupport,
              'emergencyContact': {
                'name': _contactNameController.text.trim(),
                'phone': _phoneController.text.trim(),
              },
              'createdAt': FieldValue.serverTimestamp(),
            };

            // 4. Save user profile to Firestore under this UID
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user!.uid)
                .set(userProfile);

            // 5. Navigate to HomeScreen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(
                  userName: _displayNameController.text.isNotEmpty
                      ? _displayNameController.text
                      : 'Anonymous',
                ),
              ),
            );
          } on FirebaseAuthException catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.message ?? 'Registration failed')),
            );
          } catch (e) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Setup failed: $e')));
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Complete Setup',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSkipOption() {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(userName: 'Anonymous'),
            ),
          );
        },
        child: const Text(
          'Skip for now',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
