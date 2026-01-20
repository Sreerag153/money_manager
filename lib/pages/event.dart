import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager_app/database/transactiondb.dart';
import 'package:money_manager_app/model/eventmodel.dart';
import 'package:money_manager_app/model/transaction_model.dart';
import 'package:money_manager_app/pages/event_summery.dart';
import 'package:money_manager_app/widget/eventdialog.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  late Box<EventModel> eventBox;
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    eventBox = Hive.box<EventModel>('eventsBox');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xff0F172A),
        elevation: 0,
        title: const Text(
          "Events",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(0, 255, 98, 0.871),
          ),
        ),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              dropdownColor: const Color(0xff1E293B),
              value: selectedFilter,
              icon: const Icon(Icons.filter_list, color: Colors.white),
              items: ['All', 'Pending', 'Closed']
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedFilter = value!;
                });
              },
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: () async {
          final event = await eventDialog(context);
          if (event != null) {
            eventBox.add(event);
          }
        },
        child: const Icon(Icons.add),
      ),
      body: ValueListenableBuilder(
        valueListenable: eventBox.listenable(),
        builder: (context, Box<EventModel> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text("No Events", style: TextStyle(color: Colors.white70)),
            );
          }

          final events = box.values.toList();

          final filteredEvents = selectedFilter == 'All'
              ? events
              : events.where((e) => e.status == selectedFilter).toList();

          if (filteredEvents.isEmpty) {
            return const Center(
              child: Text("No Events", style: TextStyle(color: Colors.white70)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredEvents.length,
            itemBuilder: (context, index) {
              final event = filteredEvents[index];
              final isClosed = event.status == 'Closed';

              return Slidable(
                key: ValueKey(event.key),
                startActionPane: ActionPane(
                  motion: const StretchMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) async {
                        final updated = await eventDialog(
                          context,
                          event: event,
                        );
                        if (updated == null) return;

                        if (event.status != 'Closed' &&
                            updated.status == 'Closed' &&
                            !(event.expenceAdd ?? false)) {
                          final amount =
                              (updated.splitAmount ?? 0) * updated.members;

                          TransactionDB.add(
                            TransactionModel(
                              amount: amount,
                              category: (updated.category ?? 'General').trim(),
                              type: 'expense',
                              account: updated.paymentType,
                              date: DateTime.now(),
                              note: 'Event: ${updated.name}',
                            ),
                          );

                          updated.expenceAdd = true;
                          await updated.save();
                        }

                        eventBox.put(event.key, updated);
                      },
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                  ],
                ),
                endActionPane: ActionPane(
                  motion: const StretchMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) => eventBox.delete(event.key),
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EventSummaryScreen(event: event),
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xff1E293B),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: isClosed ? Colors.red : Colors.green,
                          child: const Icon(Icons.event, color: Colors.white),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "₹${event.totalAmount.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          event.status,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isClosed
                                ? Colors.redAccent
                                : Colors.greenAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
