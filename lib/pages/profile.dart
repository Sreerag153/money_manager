import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final jobController = TextEditingController();

  bool isEdit = false;
  bool profileCreated = false;

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
    if (nameController.text.isNotEmpty) {
      setState(() => profileCreated = true);
    }
  }

  Future<void> saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', nameController.text);
    await prefs.setString('email', emailController.text);
    await prefs.setString('job', jobController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          if (profileCreated)
            IconButton(
              icon: Icon(isEdit ? Icons.check : Icons.edit),
              onPressed: () async {
                if (isEdit) {
                  await saveProfile();
                }
                setState(() => isEdit = !isEdit);
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 55,
              child: Icon(Icons.person, size: 60),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: nameController,
              enabled: isEdit || !profileCreated,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: emailController,
              enabled: isEdit || !profileCreated,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: jobController,
              enabled: isEdit || !profileCreated,
              decoration: const InputDecoration(labelText: 'Job'),
            ),
            const SizedBox(height: 30),
            if (!profileCreated)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await saveProfile();
                    setState(() => profileCreated = true);
                  },
                  child: const Text('Create Profile'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
