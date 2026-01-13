

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager_app/helper/event_dealog_widget.dart';
import 'package:money_manager_app/model/category_model.dart';
import 'package:money_manager_app/model/eventmodel.dart';

Future<EventModel?> eventDialog(BuildContext context, {EventModel? event}) {
  final nameController = TextEditingController(text: event?.name ?? '');
  final amountController = TextEditingController(
    text: event?.totalAmount.toString() ?? '',
  );
  final membersController = TextEditingController(
    text: event?.members.toString() ?? '',
  );

  String selectedStatus = event?.status ?? 'Pending';
  String selectedPayment = event?.paymentType ?? 'Cash';
  String? attachmentPath = event?.attachmentPath;

  final categoryBox = Hive.box<CategoryModel>('categoryBox');
  final expenseCategories = categoryBox.values
      .where((c) => c.type == 'expense')
      .map((c) => c.name)
      .toList();

  String selectedCategory = event?.category ?? expenseCategories.first;

  return showModalBottomSheet<EventModel>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          final double amount = double.tryParse(amountController.text) ?? 0;
          final int members = int.tryParse(membersController.text) ?? 0;
          final double split = members > 0 ? amount / members : 0;

          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    event == null ? "Add Event" : "Edit Event",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  inputField(controller: nameController, label: "Event Name"),

                  const SizedBox(height: 10),

                  dropdownField(
                    value: selectedCategory,
                    items: expenseCategories,
                    label: "Category",
                    onChanged: (v) => setState(() => selectedCategory = v!),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: inputField(
                          controller: amountController,
                          label: "Amount",
                          keyboardType: TextInputType.number,
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: inputField(
                          controller: membersController,
                          label: "Members",
                          keyboardType: TextInputType.number,
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Split Amount: ₹${split.toStringAsFixed(2)}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 10),

                  dropdownField(
                    value: selectedPayment,
                    items: const ['Cash', 'Account'],
                    label: "Payment Type",
                    onChanged: (v) => setState(() => selectedPayment = v!),
                  ),

                  const SizedBox(height: 10),

                  dropdownField(
                    value: selectedStatus,
                    items: const ['Pending', 'Closed'],
                    label: "Status",
                    onChanged: (v) => setState(() => selectedStatus = v!),
                  ),

                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () async {
                      try {
                        final result = await FilePicker.platform.pickFiles(
                          type: FileType.any,
                          allowMultiple: false,
                          withData: false,
                        );

                        if (result != null &&
                            result.files.single.path != null) {
                          setState(() {
                            attachmentPath = result.files.single.path;
                          });
                        }
                      } catch (e) {
                        debugPrint("File pick error: $e");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Failed to pick file")),
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.attach_file),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              attachmentPath == null
                                  ? "Attach File"
                                  : attachmentPath!.split('/').last,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (attachmentPath != null)
                            const Icon(Icons.check_circle, color: Colors.green),
                        ],
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(
                              context,
                              EventModel(
                                name: nameController.text.trim(),
                                members: members,
                                totalAmount: amount,
                                splitAmount: split,
                                status: selectedStatus,
                                category: selectedCategory,
                                paymentType: selectedPayment,
                                attachmentPath: attachmentPath,
                                expenceAdd: event?.expenceAdd ?? false,
                              ),
                            );
                          },
                          child: Text(event == null ? "Add" : "Update"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
