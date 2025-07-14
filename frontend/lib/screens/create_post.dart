import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final _titleController = TextEditingController();
  final _thoughtsController = TextEditingController();

  String? selectedMood;
  List<String> selectedSupport = [];
  bool allowComments = true;
  String visibility = 'Public';
  PlatformFile? selectedFile;

  final moods = ['Hopeful', 'Anxious', 'Sad'];
  final supportOptions = ['Listening Ear', 'Advice', 'Shared Experience'];

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'mp4'],
    );

    if (result != null) {
      setState(() {
        selectedFile = result.files.first;
      });
    }
  }

  Widget _buildSelectableChips(
    List<String> options,
    List<String> selectedList,
    Function(String) onTap,
  ) {
    return Wrap(
      spacing: 8,
      children: options.map((option) {
        final isSelected = selectedList.contains(option);
        return ChoiceChip(
          label: Text(option),
          selected: isSelected,
          onSelected: (_) => onTap(option),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Post")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post Title
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Post Title",
                hintText: "Share a concise summary of your experience",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Share Your Thoughts
            TextField(
              controller: _thoughtsController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Share Your Thoughts",
                hintText:
                    "Describe your feelings and how the community can support you...",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Select Mood
            Text(
              "Select Your Mood",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 8,
              children: moods.map((mood) {
                return ChoiceChip(
                  label: Text(mood),
                  selected: selectedMood == mood,
                  onSelected: (_) {
                    setState(() => selectedMood = mood);
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 16),

            // Type of Support Needed
            Text(
              "Type of Support Needed",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            _buildSelectableChips(supportOptions, selectedSupport, (value) {
              setState(() {
                if (selectedSupport.contains(value)) {
                  selectedSupport.remove(value);
                } else {
                  selectedSupport.add(value);
                }
              });
            }),
            SizedBox(height: 16),

            // Media File Picker
            Text(
              "Add Photos or Videos",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ElevatedButton.icon(
              onPressed: pickFile,
              icon: Icon(Icons.attach_file),
              label: Text(selectedFile?.name ?? "Choose File"),
            ),
            if (selectedFile != null)
              Text(
                "Selected: ${selectedFile!.name} (${(selectedFile!.size / 1024).toStringAsFixed(1)} KB)",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            SizedBox(height: 16),

            // Allow Comments Toggle
            SwitchListTile(
              title: Text("Allow Comments"),
              value: allowComments,
              onChanged: (val) {
                setState(() => allowComments = val);
              },
            ),
            SizedBox(height: 8),

            // Post Visibility Dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Post Visibility",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: visibility,
                  onChanged: (String? newValue) {
                    setState(() => visibility = newValue!);
                  },
                  items: <String>['Public', 'Private']
                      .map<DropdownMenuItem<String>>((String val) {
                        return DropdownMenuItem<String>(
                          value: val,
                          child: Text(val),
                        );
                      })
                      .toList(),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () {
                    // Save draft logic
                  },
                  child: Text("Save Draft"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Share post logic
                  },
                  child: Text("Share Post"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
