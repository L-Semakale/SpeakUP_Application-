import 'package:flutter/material.dart';
import 'professional_support.dart';

class YourSupportScreen extends StatelessWidget {
  const YourSupportScreen({super.key});

  void _showReplySheet(BuildContext context, String replyingTo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Replying to $replyingTo',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  hintText: "Type your reply...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.white,
                  foregroundColor: Colors.deepPurple,
                ),
                child: const Text("Send"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Support"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "You",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "2 hrs ago",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "It has been a long week, I feel anxious.",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.favorite_border),
                          onPressed: () {},
                        ),
                        const Text("24"),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.mode_comment_outlined),
                          onPressed: () {},
                        ),
                        const Text("8"),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.share),
                          onPressed: () {},
                        ),
                        const Text("Share"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Replies",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...List.generate(replies.length, (index) {
              final reply = replies[index];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(reply['name']!),
                        subtitle: Text(reply['comment']!),
                        trailing: Text(
                          reply['time']!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showReplySheet(context, reply['name']!);
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(left: 16, top: 8),
                          child: Text(
                            "Reply",
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
            Center(
              child: TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SupportScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.support_agent),
                label: const Text("Seek Professional Support"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final List<Map<String, String>> replies = [
  {
    "name": "Alex",
    "comment": "You're not alone, stay strong!",
    "time": "1h ago",
  },
  {"name": "Maria", "comment": "Same here, sending love", "time": "45m ago"},
  {
    "name": "John",
    "comment": "Have you tried the calming exercises posted?",
    "time": "30m ago",
  },
];
