import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager_app/widget/colors.dart';
import 'package:money_manager_app/widget/inc_exp_circle.dart';

class SummaryCard extends StatelessWidget {
  final String dropdownValue;
  final List<String> dropDownList;
  final DateTime selectedDate;
  final double income;
  final double expense;
  final VoidCallback onDateTap;
  final Function(String?) onDropdownChanged;

  const SummaryCard({
    super.key,
    required this.dropdownValue,
    required this.dropDownList,
    required this.selectedDate,
    required this.income,
    required this.expense,
    required this.onDateTap,
    required this.onDropdownChanged,
  });

  String get formattedDate {
    if (dropdownValue == 'Yearly') {
      return DateFormat('yyyy').format(selectedDate);
    }
    if (dropdownValue == 'Daily') {
      return DateFormat('dd MMM yyyy').format(selectedDate);
    }
    if (dropdownValue == 'Weekly') {
      final start =
          selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
      final end = start.add(const Duration(days: 6));
      return "${DateFormat('dd MMM').format(start)} - ${DateFormat('dd MMM yyyy').format(end)}";
    }
    return DateFormat('MMM yyyy').format(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final total = income + expense;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: Container(
        key: ValueKey('$dropdownValue-$formattedDate'),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            colors: [
              AppColors.primaryGradientStart,
              AppColors.primaryGradientEnd,
            ],
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: dropdownValue,
                  underline: const SizedBox(),
                  dropdownColor: const Color(0xff1E293B),
                  items: dropDownList
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: const Text(
                            '',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                      .toList(),
                  selectedItemBuilder: (context) {
                    return dropDownList.map((e) {
                      return Text(
                        e,
                        style: const TextStyle(color: Colors.white),
                      );
                    }).toList();
                  },
                  onChanged: onDropdownChanged,
                ),
                GestureDetector(
                  onTap: onDateTap,
                  child: Text(
                    formattedDate,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircularTile(
                  title: 'Income',
                  value: income,
                  percent: total == 0 ? 0 : income / total,
                  color: AppColors.income,
                ),
                CircularTile(
                  title: 'Expense',
                  value: expense,
                  percent: total == 0 ? 0 : expense / total,
                  color: AppColors.expense,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}