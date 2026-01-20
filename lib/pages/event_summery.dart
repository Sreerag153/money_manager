import 'package:flutter/material.dart';
import 'package:money_manager_app/model/eventmodel.dart';
import 'package:open_file/open_file.dart';

class EventSummaryScreen extends StatelessWidget {
  final EventModel event;

  const EventSummaryScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xff0F172A),
        elevation: 0,
        title: const Text(
          "Event Summary",
          style: TextStyle(color: Colors.amber),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xff1E293B),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              row("Event", event.name),
              row("Category", event.category ?? "General"),
              row("Status", event.status),
              row("Payment", event.paymentType),
              row("Members", event.members.toString()),
              row("Total Amount", "₹${event.totalAmount.toStringAsFixed(2)}"),
              row(
                "Split Amount",
                "₹${event.splitAmount?.toStringAsFixed(2) ?? '0.00'}",
              ),
              row(
                "Total Expense",
                "₹${((event.splitAmount ?? 0) * event.members).toStringAsFixed(2)}",
              ),
              if (event.attachmentPath != null)
                InkWell(
                  onTap: () => OpenFile.open(event.attachmentPath!),
                  child: Row(
                    children: [
                      Text(event.attachmentPath!.split('/').last),
                      const Icon(Icons.open_in_new, size: 16),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

