import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

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
    await prefs.setString('name', nameController.text.trim());
    await prefs.setString('email', emailController.text.trim());
    await prefs.setString('job', jobController.text.trim());
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    jobController.dispose();
    super.dispose();
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const CircleAvatar(
                radius: 55,
                child: Icon(Icons.person, size: 60),
              ),
              const SizedBox(height: 30),

              TextFormField(
                controller: nameController,
                enabled: isEdit || !profileCreated,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: emailController,
                enabled: isEdit || !profileCreated,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email is required';
                  }
                  if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              /// Job
              TextFormField(
                controller: jobController,
                enabled: isEdit || !profileCreated,
                decoration: const InputDecoration(
                  labelText: 'Job',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Job is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30),

              if (!profileCreated)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await saveProfile();
                        setState(() => profileCreated = true);
                      }
                    },
                    child: const Text('Create Profile'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
