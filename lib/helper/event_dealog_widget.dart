import 'package:flutter/material.dart';

Widget sectionTitle(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    ),
  );
}

Widget inputField({
  required TextEditingController controller,
  required String label,
  TextInputType keyboardType = TextInputType.text,
  Function(String)? onChanged,
}) {
  return TextField(
    controller: controller,
    keyboardType: keyboardType,
    onChanged: onChanged,
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    ),
  );
}

Widget dropdownField({
  required String value,
  required List<String> items,
  required String label,
  required Function(String?) onChanged,
}) {
  return DropdownButtonFormField<String>(
    value: value,
    items: items
        .map(
          (e) => DropdownMenuItem(
            value: e,
            child: Text(e),
          ),
        )
        .toList(),
    onChanged: onChanged,
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    ),
  );
}
