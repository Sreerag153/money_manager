import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:money_manager_app/widget/eventdialog.dart';
import 'package:provider/provider.dart';
import 'package:money_manager_app/provider/event_provider.dart';
import 'package:money_manager_app/pages/event_summery.dart';
import 'package:money_manager_app/widget/colors.dart';

class EventPage extends StatelessWidget {
  const EventPage({super.key});

  @override
  Widget build(BuildContext context) {
    final eventProvider = context.watch<EventProvider>();
    final events = eventProvider.events;

    return Scaffold(
      backgroundColor: const Color(0xff0F172A),
      appBar: AppBar(
        title: const Text("Events", style: TextStyle(color: Color(0xff00FF62), fontWeight: FontWeight.bold)),
        actions: [
          DropdownButton<String>(
            dropdownColor: const Color(0xff1E293B),
            value: eventProvider.selectedFilter,
            underline: const SizedBox(),
            items: ['All', 'Pending', 'Closed']
                .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(color: Colors.white))))
                .toList(),
            onChanged: (v) => eventProvider.setFilter(v!),
          ),
          const SizedBox(width: 12),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: () => showEventDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: events.isEmpty
          ? const Center(child: Text("No Events Found", style: TextStyle(color: Colors.white70)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                final isClosed = event.status == 'Closed';

                return Slidable(
                  key: ValueKey(event.key),
                  startActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (_) => showEventDialog(context, event: event),
                        backgroundColor: Colors.blueAccent,
                        icon: Icons.edit,
                        label: 'Edit',
                      ),
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (_) => eventProvider.deleteEvent(event.key),
                        backgroundColor: Colors.redAccent,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EventSummaryScreen(event: event))),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: const Color(0xff1E293B), borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: isClosed ? AppColors.expense : AppColors.income,
                            child: const Icon(Icons.event, color: Colors.white),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(event.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                                Text("₹ ${event.totalAmount.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white70, fontSize: 13)),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (!isClosed) {
                                eventProvider.closeEvent(event);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: isClosed ? AppColors.expense : AppColors.income,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(event.status, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}