
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:money_manager_app/model/category_model.dart';
import 'package:money_manager_app/model/eventmodel.dart';

Future<EventModel?> editEventDialog(
    BuildContext context, EventModel event) {

  final TextEditingController nameController =
      TextEditingController(text: event.name);

  final TextEditingController membersController =
      TextEditingController(text: event.members.toString());

  final TextEditingController amountController =
      TextEditingController(text: event.totalAmount.toString());

  String selectedStatus = event.status;
  String selectedPayment = event.paymentType;
  String? attachmentPath = event.attachmentPath;

  final categoryBox = Hive.box<CategoryModel>('categoryBox');

  final expenseCategories = categoryBox.values.where((c) => c.type == 'expense').map((c) => c.name).toList();

  String selectedCategory =
      expenseCategories.contains(event.category)
          ? event.category!
          : (expenseCategories.isNotEmpty
              ? expenseCategories.first
              : '');

  return showDialog<EventModel>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {

          final double totalAmount =
              double.tryParse(amountController.text) ?? 0;

          final int members =
              int.tryParse(membersController.text) ?? 0;

          final double splitAmount =
              members > 0 ? totalAmount / members : 0;

          return Dialog(
            insetPadding: const EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    const Text(
                      "Edit Event",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Event Name",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 10),

                    
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text("Cash"),
                              value: 'Cash',
                              groupValue: selectedPayment,
                              onChanged: (v) =>
                                  setState(() => selectedPayment = v!),
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text("Account"),
                              value: 'Account',
                              groupValue: selectedPayment,
                              onChanged: (v) =>
                                  setState(() => selectedPayment = v!),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      items: expenseCategories
                          .map(
                            (c) => DropdownMenuItem(
                              value: c,
                              child: Text(c),
                            ),
                          )
                          .toList(),
                      onChanged: (v) =>
                          setState(() => selectedCategory = v!),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        labelText: "Category",
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Total Amount",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: membersController,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Members Count",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Split Amount: ₹${splitAmount.toStringAsFixed(2)}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),

                    const SizedBox(height: 10),

                   
                    InkWell(
                      onTap: ()
                       {},
                      child: Container(
                        height: 55,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.attach_file,
                                color: Colors.grey),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                 "Attach file"
                                  ,style:
                                    const TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                   
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      items: const [
                        DropdownMenuItem(
                            value: 'Pending', child: Text('Pending')),
                        DropdownMenuItem(
                            value: 'Closed', child: Text('Closed')),
                      ],
                      onChanged: (v) =>
                          setState(() => selectedStatus = v!),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        labelText: "Status",
                      ),
                    ),

                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () =>
                              Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(
                              context,
                              EventModel(
                                name: nameController.text.trim(),
                                members: members,
                                totalAmount: totalAmount,
                                status: selectedStatus,
                                category: selectedCategory,
                                splitAmount: splitAmount,
                                attachmentPath: attachmentPath,
                                paymentType: selectedPayment,
                              ),
                            );
                          }, 
                          child: const Text("Update"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
