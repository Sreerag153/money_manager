import 'package:flutter/material.dart';
import 'package:money_manager_app/provider/transation_form_provider.dart';
import 'package:provider/provider.dart';

class TransactionPage extends StatelessWidget {
  final String title;
  final Color color;
  final List<String> categories;
  final VoidCallback onSave;
  final TextEditingController amountController;
  final TextEditingController noteController;

  const TransactionPage({
    super.key,
    required this.title,
    required this.color,
    required this.categories,
    required this.onSave,
    required this.amountController,
    required this.noteController,
  });

  @override
  Widget build(BuildContext context) {
    final form = context.watch<TransactionFormProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: color),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Amount", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: categories.contains(form.selectedCategory) ? form.selectedCategory : categories.first,
              decoration: const InputDecoration(labelText: "Category", border: OutlineInputBorder()),
              items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => form.setCategory(v!),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text("Cash"),
                    value: "Cash",
                    groupValue: form.selectedAccount,
                    onChanged: (v) => form.setAccount(v!),
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text("Account"),
                    value: "Account",
                    groupValue: form.selectedAccount,
                    onChanged: (v) => form.setAccount(v!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(labelText: "Note", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text("Date: ${form.selectedDate.toString().split(' ')[0]}", style: const TextStyle(fontSize: 16)),
                const Spacer(),
                TextButton.icon(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: form.selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) form.setDate(date);
                  },
                  icon: const Icon(Icons.calendar_month),
                  label: const Text("Pick Date"),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(55), backgroundColor: color),
              onPressed: onSave,
              child: const Text("Save", style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}