import 'package:flutter/material.dart';

class DateFilterRow extends StatelessWidget {
  final String dropdownValue;
  final String formattedDate;
  final ValueChanged<String> onDropdownChanged;
  final VoidCallback onDateTap;

  const DateFilterRow({
    super.key,
    required this.dropdownValue,
    required this.formattedDate,
    required this.onDropdownChanged,
    required this.onDateTap,
  });

  static const List<String> _options = [
    'Monthly',
    'Yearly',
    'Weekly',
    'Daily',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xff6366F1), Color(0xff8B5CF6)],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DropdownButton<String>(
            value: dropdownValue,
            dropdownColor: const Color(0xff1E293B),
            underline: const SizedBox(),
            iconEnabledColor: Colors.white,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            items: _options
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                onDropdownChanged(value);
              }
            },
          ),
          GestureDetector(
            onTap: onDateTap,
            child: Row(
              children: [
                const Icon(Icons.calendar_month,
                    color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  formattedDate,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
