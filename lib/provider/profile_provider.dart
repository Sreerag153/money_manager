import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider extends ChangeNotifier {
  String _name = 'My Profile';
  String _tempName = '';
  File? _image;

  String get name => _name;
  String get tempName => _tempName;
  File? get image => _image;

  void setTempName(String value) {
    _tempName = value;
    notifyListeners();
  }

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('name') ?? 'My Profile';
    _tempName = _name;

    final path = prefs.getString('profileImage');
    if (path != null && File(path).existsSync()) {
      _image = File(path);
    }
    notifyListeners();
  }

  Future<void> saveProfile(String? imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    _name = _tempName;
    await prefs.setString('name', _name);
    
    if (imagePath != null) {
      await prefs.setString('profileImage', imagePath);
      _image = File(imagePath);
    }
    notifyListeners();
  }
}