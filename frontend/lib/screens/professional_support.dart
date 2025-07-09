import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Professional Support')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Get Professional Help',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _SupportCard(
            title: 'Talk to a Therapist',
            subtitle: 'Connect with a licensed professional',
            icon: Icons.psychology,
            onTap: () => _showTherapistDialog(context),
          ),
          _SupportCard(
            title: 'Crisis Hotlines',
            subtitle: 'National Suicide Prevention Lifeline',
            icon: Icons.phone,
            onTap: () => _showCrisisDialog(context),
          ),
          _SupportCard(
            title: 'SAMHSA',
            subtitle: 'Substance abuse and mental health',
            icon: Icons.local_hospital,
            onTap: () => _showSamhsaDialog(context),
          ),
          _SupportCard(
            title: 'Coping Strategies',
            subtitle: 'Learn healthy coping mechanisms',
            icon: Icons.self_improvement,
            onTap: () => _showCopingDialog(context),
          ),
        ],
      ),
    );
  }

  void _showTherapistDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Find a Therapist'),
        content: const Text(
          'Connect with licensed mental health professionals in your area.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showCrisisDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Crisis Hotlines'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('National Suicide Prevention Lifeline:'),
            Text(
              '1-800-273-8255',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Crisis Text Line:'),
            Text(
              'Text HOME to 741741',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSamhsaDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('SAMHSA'),
        content: const Text(
          'Substance Abuse and Mental Health Services Administration\n\n1-800-662-4357',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showCopingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Coping Strategies'),
        content: const Text(
          '• Deep breathing exercises\n• Mindfulness meditation\n• Regular exercise\n• Healthy sleep schedule\n• Connect with friends and family',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _SupportCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _SupportCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, size: 32, color: Theme.of(context).primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
