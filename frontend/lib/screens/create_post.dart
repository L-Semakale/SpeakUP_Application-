import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> with TickerProviderStateMixin {
  final _titleController = TextEditingController();
  final _thoughtsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  String? selectedMood;
  List<String> selectedSupport = [];
  bool allowComments = true;
  String visibility = 'Public';
  PlatformFile? selectedFile;
  bool isPosting = false;

  final moods = [
    {'name': 'Hopeful', 'emoji': '🌟', 'color': Color(0xFF4CAF50)},
    {'name': 'Anxious', 'emoji': '😰', 'color': Color(0xFFFF9800)},
    {'name': 'Sad', 'emoji': '😢', 'color': Color(0xFF2196F3)},
    {'name': 'Grateful', 'emoji': '🙏', 'color': Color(0xFF9C27B0)},
    {'name': 'Confused', 'emoji': '😕', 'color': Color(0xFF607D8B)},
    {'name': 'Excited', 'emoji': '😊', 'color': Color(0xFFE91E63)},
  ];

  final supportOptions = [
    {'name': 'Listening Ear', 'icon': Icons.hearing, 'desc': 'Someone to listen'},
    {'name': 'Advice', 'icon': Icons.lightbulb_outline, 'desc': 'Practical guidance'},
    {'name': 'Shared Experience', 'icon': Icons.group, 'desc': 'Similar stories'},
    {'name': 'Professional Help', 'icon': Icons.medical_services, 'desc': 'Expert resources'},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuart),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _titleController.dispose();
    _thoughtsController.dispose();
    super.dispose();
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'mp4', 'jpeg'],
    );

    if (result != null) {
      setState(() {
        selectedFile = result.files.first;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('File "${result.files.first.name}" selected'),
          backgroundColor: const Color(0xFF667EEA),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _sharePost() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (selectedMood == null) {
      _showErrorSnackBar('Please select your current mood');
      return;
    }
    
    if (_thoughtsController.text.trim().isEmpty) {
      _showErrorSnackBar('Please share your thoughts');
      return;
    }

    setState(() => isPosting = true);
    
    // Simulate posting delay
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() => isPosting = false);
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Your post has been shared successfully!'),
          ],
        ),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    
    // Navigate back
    Navigator.pop(context);
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF2D3436)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Share Your Story',
          style: TextStyle(
            color: Color(0xFF2D3436),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _thoughtsController.text.isNotEmpty ? () {
              // Save draft logic
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Draft saved'),
                  backgroundColor: const Color(0xFF667EEA),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            } : null,
            child: const Text(
              'Save Draft',
              style: TextStyle(color: Color(0xFF667EEA)),
            ),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: child,
            ),
          );
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Encouragement message
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.favorite, color: Colors.white, size: 24),
                      SizedBox(height: 8),
                      Text(
                        'Your voice matters',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Share your experience to help others feel less alone',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),

                // Post Title
                _buildSectionTitle('Give your post a title'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: _buildInputDecoration(
                    'What\'s on your mind?',
                    Icons.title,
                  ),
                  validator: (value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Please add a title';
                    }
                    return null;
                  },
                  onChanged: (value) => setState(() {}),
                ),
                
                const SizedBox(height: 24),

                // Share Your Thoughts
                _buildSectionTitle('Share your thoughts'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _thoughtsController,
                  maxLines: 6,
                  decoration: _buildInputDecoration(
                    'Describe how you\'re feeling and what kind of support would help you...',
                    Icons.edit_note,
                  ),
                  validator: (value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Please share your thoughts';
                    }
                    return null;
                  },
                  onChanged: (value) => setState(() {}),
                ),
                
                const SizedBox(height: 24),

                // Select Mood
                _buildSectionTitle('How are you feeling right now?'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: moods.map((mood) {
                    final isSelected = selectedMood == mood['name'];
                    return GestureDetector(
                      onTap: () => setState(() => selectedMood = mood['name'] as String),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? (mood['color'] as Color).withOpacity(0.1)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: isSelected 
                                ? (mood['color'] as Color)
                                : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: isSelected ? [
                            BoxShadow(
                              color: (mood['color'] as Color).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ] : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              mood['emoji'] as String,
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              mood['name'] as String,
                              style: TextStyle(
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected 
                                    ? (mood['color'] as Color)
                                    : const Color(0xFF2D3436),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                
                const SizedBox(height: 24),

                // Type of Support Needed
                _buildSectionTitle('What kind of support do you need?'),
                const SizedBox(height: 12),
                Column(
                  children: supportOptions.map((support) {
                    final isSelected = selectedSupport.contains(support['name']);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedSupport.remove(support['name']);
                            } else {
                              selectedSupport.add(support['name'] as String);
                            }
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? const Color(0xFF667EEA).withOpacity(0.1)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected 
                                  ? const Color(0xFF667EEA)
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                support['icon'] as IconData,
                                color: isSelected 
                                    ? const Color(0xFF667EEA)
                                    : const Color(0xFF636E72),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      support['name'] as String,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: isSelected 
                                            ? const Color(0xFF667EEA)
                                            : const Color(0xFF2D3436),
                                      ),
                                    ),
                                    Text(
                                      support['desc'] as String,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF636E72),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle,
                                  color: Color(0xFF667EEA),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                
                const SizedBox(height: 24),

                // Media File Picker
                _buildSectionTitle('Add a photo or video (optional)'),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: pickFile,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          selectedFile != null ? Icons.check_circle : Icons.cloud_upload_outlined,
                          size: 32,
                          color: selectedFile != null 
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFF636E72),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          selectedFile?.name ?? 'Tap to select a file',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: selectedFile != null 
                                ? const Color(0xFF4CAF50)
                                : const Color(0xFF2D3436),
                          ),
                        ),
                        if (selectedFile != null)
                          Text(
                            '${(selectedFile!.size / 1024).toStringAsFixed(1)} KB',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF636E72),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),

                // Settings
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Allow Comments'),
                        subtitle: const Text('Let others respond to your post'),
                        value: allowComments,
                        activeColor: const Color(0xFF667EEA),
                        onChanged: (val) => setState(() => allowComments = val),
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Post Visibility',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Choose who can see your post',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF636E72),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: visibility,
                                onChanged: (String? newValue) {
                                  setState(() => visibility = newValue!);
                                },
                                items: ['Public', 'Private']
                                    .map<DropdownMenuItem<String>>((String val) {
                                  return DropdownMenuItem<String>(
                                    value: val,
                                    child: Text(val),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),

                // Share Button
                Container(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isPosting ? null : _sharePost,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF667EEA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: isPosting
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Sharing...',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.send, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Share Your Story',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Privacy note
                const Text(
                  '🔒 Your post will be shared anonymously. We prioritize your privacy and safety.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF636E72),
                  ),
                ),
                
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2D3436),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF636E72)),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF667EEA), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }
}