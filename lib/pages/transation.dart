import 'package:flutter/material.dart';

class TransactionPage extends StatelessWidget {
  final String title;
  final Color color;
  final List<String> categories;
  final DateTime selectedDate;
  final VoidCallback onPickDate;
  final VoidCallback onSave;

  final TextEditingController amountController;
  final TextEditingController noteController;
  final String selectedCategory;
  final ValueChanged<String?> onCategoryChanged;

  final String selectedAccount;
  final ValueChanged<String> onAccountChanged;

  const TransactionPage({
    super.key,
    required this.title,
    required this.color,
    required this.categories,
    required this.selectedDate,
    required this.onPickDate,
    required this.onSave,
    required this.amountController,
    required this.noteController,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.selectedAccount,
    required this.onAccountChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: color),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Amount"),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              initialValue: selectedCategory,
              decoration: const InputDecoration(labelText: "Category"),
              items: categories
                  .map(
                    (c) => DropdownMenuItem<String>(value: c, child: Text(c)),
                  )
                  .toList(),
              onChanged: onCategoryChanged,
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: const Text("Cash"),
                    value: "Cash",
                    groupValue: selectedAccount,
                    onChanged: (v) => onAccountChanged(v!),
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: const Text("Account"),
                    value: "Account",
                    groupValue: selectedAccount,
                    onChanged: (v) => onAccountChanged(v!),
                  ),
                ),
              ],
            ),

            TextField(
              controller: noteController,
              decoration: const InputDecoration(labelText: "Note"),
            ),

            Row(
              children: [
                Text("Date: ${selectedDate.toString().split(' ')[0]}"),
                TextButton(
                  onPressed: onPickDate,
                  child: const Text("Pick Date"),
                ),
              ],
            ),

            const Spacer(),

            ElevatedButton(onPressed: onSave, child: const Text("Save")),
          ],
        ),
      ),
    );
  }
}
