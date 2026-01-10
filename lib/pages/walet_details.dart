import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WalletDetailPage extends StatefulWidget {
  final String title;
  final double balance;
  final double income;
  final double expense;

  const WalletDetailPage({
    super.key,
    required this.title,
    required this.balance, 
    required this.income,
    required this.expense,
  });

  @override
  State<WalletDetailPage> createState() => _WalletDetailPageState();
}

class _WalletDetailPageState extends State<WalletDetailPage> {
  final List<String> filterList = [
    'Monthly',
    'Yearly',
    'Weekly',
    'Daily',
  ];

  String selectedFilter = 'Monthly';
  DateTime selectedDate = DateTime.now();

  Future<void> pickDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  String get formattedDate {
    switch (selectedFilter) {
      case 'Yearly':
        return DateFormat('yyyy').format(selectedDate);

      case 'Weekly':
        final week = DateFormat('w').format(selectedDate);
        return 'Week $week, ${selectedDate.year}';

      case 'Daily':
        return DateFormat('dd MMM yyyy').format(selectedDate);

      default:
        return DateFormat('MMM yyyy').format(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<String>(
                    value: selectedFilter,
                    underline: const SizedBox(),
                    items: filterList
                        .map(
                          (filter) => DropdownMenuItem(
                            value: filter,
                            child: Text(filter),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedFilter = value!;
                      });
                    },
                  ),
                  GestureDetector(
                    onTap: pickDate,
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_month),
                        const SizedBox(width: 8),
                        Text(
                          formattedDate,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  _infoTile(
                    label: 'Balance',
                    value: widget.balance,
                    color: Colors.black,
                  ),
                  _infoTile(
                    label: 'Income',
                    value: widget.income,
                    color: Colors.green,
                  ),
                  _infoTile(
                    label: 'Expense',
                    value: widget.expense,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile({
    required String label,
    required double value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            "₹ ${value.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
