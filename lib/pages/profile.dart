import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_manager_app/app_state.dart';
import 'package:money_manager_app/provider/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<File?> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return null;

    final dir = await getApplicationDocumentsDirectory();
    final newPath = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.png';
    return File(picked.path).copy(newPath);
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>();
    final appState = context.read<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Set Up Profile"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                final image = await _pickImage();
                if (image != null) {
                  await profile.saveProfile(image.path);
                }
              },
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.blueGrey,
                    backgroundImage: profile.image != null 
                        ? FileImage(profile.image!) 
                        : null,
                    child: profile.image == null
                        ? const Icon(Icons.person, size: 60, color: Colors.white)
                        : null,
                  ),
                  const Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.camera_alt, size: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              onChanged: (value) => profile.setTempName(value),
              decoration: InputDecoration(
                labelText: "Your Name",
                hintText: "Enter your name",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                if (profile.tempName.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter your name")),
                  );
                  return;
                }

                await profile.saveProfile(null);
                
                // If this is the initial setup, tell AppState profile is created
                if (!appState.profileCreated) {
                  await appState.createProfile();
                } else {
                  // If just editing, go back
                  Navigator.pop(context);
                }
              },
              child: const Text("Save and Continue", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}