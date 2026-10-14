import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/privacy_checker.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController textController = TextEditingController();

  ImagePicker imagePicker = ImagePicker();

  XFile? selectedImage;

  String selectedAudience = 'Public';

  bool postingNow = true;

  Future<void> chooseImage() async {
    XFile? image = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        selectedImage = image;
      });
    }
  }

  void analysePost() {
    PrivacyChecker checker = PrivacyChecker();

    var risks = checker.checkPost(
      textController.text,
      selectedAudience,
      postingNow,
      selectedImage != null,
    );

    int score = checker.calculateOverallScore(risks);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ResultScreen(
            risks: risks,
            score: score,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Checker'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Check your post before sharing',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: textController,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: 'Write your social media post...',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: chooseImage,
              icon: const Icon(Icons.image),
              label: const Text('Choose Image'),
            ),

            const SizedBox(height: 10),

            if (selectedImage != null)
              Image.file(
                File(selectedImage!.path),
                height: 200,
              ),

            const SizedBox(height: 20),

            const Text(
              'Who can see the post?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            DropdownButton<String>(
              value: selectedAudience,
              items: const [
                DropdownMenuItem(
                  value: 'Public',
                  child: Text('Public'),
                ),
                DropdownMenuItem(
                  value: 'Friends',
                  child: Text('Friends'),
                ),
                DropdownMenuItem(
                  value: 'Private',
                  child: Text('Private'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedAudience = value;
                  });
                }
              },
            ),

            const SizedBox(height: 10),

            SwitchListTile(
              title: const Text('Posting right now?'),
              value: postingNow,
              onChanged: (value) {
                setState(() {
                  postingNow = value;
                });
              },
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: analysePost,
                child: const Text(
                  'Analyse Privacy Risk',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}