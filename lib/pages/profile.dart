import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_manager_app/home.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:money_manager_app/pages/homepage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  static String routeName = 'profile';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final jobController = TextEditingController();

  bool isEdit = false;
  bool profileCreated = false;

  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    nameController.text = prefs.getString('name') ?? '';
    emailController.text = prefs.getString('email') ?? '';
    jobController.text = prefs.getString('job') ?? '';
    final imagePath = prefs.getString('profileImage');
    if (imagePath != null && File(imagePath).existsSync()) {
      _image = File(imagePath);
    }
    profileCreated = prefs.getBool('profileCreated') ?? false;
    setState(() {});
  }

  Future<void> saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', nameController.text.trim());
    await prefs.setString('email', emailController.text.trim());
    await prefs.setString('job', jobController.text.trim());
    if (_image != null) {
      await prefs.setString('profileImage', _image!.path);
    }
    await prefs.setBool('profileCreated', true);
  }

  Future<void> pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final dir = await getApplicationDocumentsDirectory();
      final newPath = '${dir.path}/${pickedFile.name}';
      final newImage = await File(pickedFile.path).copy(newPath);
      setState(() {
        _image = newImage;
      });
    }
  }

  InputDecoration fieldStyle(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: const Color(0xff1E293B),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xff0F172A),
        elevation: 0,
        title: const Text('My Profile'),
        actions: [
          if (profileCreated)
            IconButton(
              icon: Icon(isEdit ? Icons.check : Icons.edit),
              onPressed: () async {
                if (isEdit) {
                  if (_formKey.currentState!.validate()) {
                    await saveProfile();
                    setState(() => isEdit = false);
                  }
                } else {
                  setState(() => isEdit = true);
                }
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: (isEdit || !profileCreated) ? pickImage : null,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: const Color(0xff1E293B),
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? const Icon(Icons.camera_alt,
                          size: 40, color: Colors.white70)
                      : null,
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: nameController,
                enabled: isEdit || !profileCreated,
                style: const TextStyle(color: Colors.white),
                decoration: fieldStyle('Name'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: emailController,
                enabled: isEdit || !profileCreated,
                style: const TextStyle(color: Colors.white),
                decoration: fieldStyle('Email'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: jobController,
                enabled: isEdit || !profileCreated,
                style: const TextStyle(color: Colors.white),
                decoration: fieldStyle('Job'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 30),
              if (!profileCreated)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff6366F1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await saveProfile();
                        Navigator.pushReplacementNamed(
                          context,
                          Homepage.routeName,
                        );
                      }
                    },
                    child: const Text(
                      'Create Profile',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
