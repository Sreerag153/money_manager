import 'package:flutter/material.dart';
import 'package:money_manager_app/widget/colors.dart';

class ExpandableFab extends StatefulWidget {
  final Function(String type) onSelect;

  const ExpandableFab({super.key, required this.onSelect});

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab> {
  bool _isOpen = false;
  String? _selectedType;

  void _toggle() {
    setState(() => _isOpen = !_isOpen);
  }

  void _handleTap(String type) {
    setState(() {
      _selectedType = type;
      _isOpen = false;
    });
    widget.onSelect(type);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _miniFab(
          label: "Expense",
          icon: Icons.arrow_downward,
          color: Colors.red,
          visible: _isOpen,
          selected: _selectedType == "expense",
          onTap: () => _handleTap("expense"),
        ),
        const SizedBox(height: 12),
        _miniFab(
          label: "Income",
          icon: Icons.arrow_upward,
          color: Colors.green,
          visible: _isOpen,
          selected: _selectedType == "income",
          onTap: () => _handleTap("income"),
        ),
        const SizedBox(height: 12),
        FloatingActionButton(
          backgroundColor: AppColors.primaryGradientStart,
          onPressed: _toggle,
          child: AnimatedRotation(
            turns: _isOpen ? 0.125 : 0,
            duration: const Duration(milliseconds: 300),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  Widget _miniFab({
    required String label,
    required IconData icon,
    required Color color,
    required bool visible,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return AnimatedScale(
      scale: visible ? 1 : 0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 300),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: selected ? color : Colors.black87,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                label,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            FloatingActionButton(
              heroTag: label,
              mini: true,
              backgroundColor: selected ? color : Colors.grey[800],
              onPressed: onTap,
              child: Icon(icon),
            ),
          ],
        ),
      ),
    );
  }
}