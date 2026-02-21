import 'package:flutter/material.dart';
import 'package:money_manager_app/pages/profile.dart';
import 'package:money_manager_app/provider/profile_provider.dart';
import 'package:provider/provider.dart';


class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>();

    return Drawer(
      child: Column(
        children: [
          const SizedBox(height: 60),
          CircleAvatar(
            radius: 40,
            backgroundImage:
                profile.image != null ? FileImage(profile.image!) : null,
            child: profile.image == null
                ? const Icon(Icons.person)
                : null,
          ),
          const SizedBox(height: 10),
          Text(profile.name),
          const SizedBox(height: 20),
          ListTile(
            title: const Text("Edit Profile"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfilePage(),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}