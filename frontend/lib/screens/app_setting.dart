import 'package:flutter/material.dart';
import 'profile_update.dart';

class AppSettingsScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const AppSettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  late bool isDark;

  @override
  void initState() {
    super.initState();
    isDark = widget.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("App Setting")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text("Appearance"),
              value: isDark,
              onChanged: (value) {
                setState(() => isDark = value);
                widget.onThemeChanged(value);
              },
              activeColor: Colors.purple,
            ),
            ListTile(
              title: const Text("Profile Update"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfileUpdateScreen(),
                  ),
                );
              },
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () {
              },
              icon: const Icon(Icons.delete, color: Colors.red),
              label: const Text(
                "Delete Account",
                style: TextStyle(color: Colors.red),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade100,
                foregroundColor: Colors.purple,
              ),
              child: const Text("Log Out"),
            ),
          ],
        ),
      ),
    );
  }
}
