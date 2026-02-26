import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:money_manager_app/provider/event_form_provider.dart';
import 'package:money_manager_app/provider/event_provider.dart';
import 'package:money_manager_app/model/eventmodel.dart';
import 'package:money_manager_app/model/category_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:file_picker/file_picker.dart';

void showEventDialog(BuildContext context, {EventModel? event}) {
  final nameController = TextEditingController();
  final amountController = TextEditingController();
  final membersController = TextEditingController();

  final expenseCategories = Hive.box<CategoryModel>(
    'categoryBox',
  ).values.where((c) => c.type == 'expense').map((c) => c.name).toList();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xff1E293B),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => ChangeNotifierProvider(
      create: (_) {
        final form = EventFormProvider();
        form.init(
          event,
          expenseCategories.isNotEmpty ? expenseCategories.first : "General",
        );

        nameController.text = form.name;
        amountController.text = form.totalAmount > 0
            ? form.totalAmount.toString()
            : "";
        membersController.text = form.members > 0
            ? form.members.toString()
            : "";

        return form;
      },
      child: Consumer<EventFormProvider>(
        builder: (context, form, _) => Padding(
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
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  onChanged: (v) => form.updateName(v),
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Event Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: form.category,
                  dropdownColor: const Color(0xff1E293B),
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Category",
                    border: OutlineInputBorder(),
                  ),
                  items: expenseCategories
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => form.updateCategory(v!),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        onChanged: (v) => form.updateAmount(v),
                        decoration: const InputDecoration(
                          labelText: "Amount",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: membersController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        onChanged: (v) => form.updateMembers(v),
                        decoration: const InputDecoration(
                          labelText: "Members",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xff0F172A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Split Amount",
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        "₹ ${form.splitAmount.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: form.paymentType,
                  dropdownColor: const Color(0xff1E293B),
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Payment Type",
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                    DropdownMenuItem(value: 'Account', child: Text('Account')),
                  ],
                  onChanged: (v) => form.updatePayment(v!),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.any,
                    );
                    if (result != null)
                      form.updateAttachment(result.files.single.path);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white24),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.attach_file, color: Colors.white),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            form.attachmentPath == null
                                ? "Attach File"
                                : form.attachmentPath!.split('/').last,
                            style: const TextStyle(color: Colors.white70),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (form.attachmentPath != null)
                          const Icon(
                            Icons.check_circle,
                            color: Colors.greenAccent,
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(55),
                    backgroundColor: Colors.indigo,
                  ),
                  onPressed: () {
                    if (form.name.isEmpty || form.totalAmount <= 0) return;

                    final resultEvent =
                        event ??
                        EventModel(
                          name: form.name,
                          members: form.members,
                          totalAmount: form.totalAmount,
                          status: form.status,
                          category: form.category,
                          splitAmount: form.splitAmount,
                          paymentType: form.paymentType,
                          expenceAdd: false,
                        );

                    resultEvent.name = form.name;
                    resultEvent.totalAmount = form.totalAmount;
                    resultEvent.members = form.members;
                    resultEvent.splitAmount = form.splitAmount;
                    resultEvent.category = form.category;
                    resultEvent.paymentType = form.paymentType;
                    resultEvent.attachmentPath = form.attachmentPath;

                    final provider = context.read<EventProvider>();
                    if (event == null) {
                      provider.addEvent(resultEvent);
                    } else {
                      provider.updateEvent(event.key, resultEvent);
                    }

                    Navigator.pop(context);
                  },
                  child: Text(
                    event == null ? "Add Event" : "Update Event",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
