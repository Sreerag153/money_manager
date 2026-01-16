import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager_app/database/transactiondb.dart';
import 'package:money_manager_app/model/eventmodel.dart';
import 'package:money_manager_app/model/transaction_model.dart';
import 'package:money_manager_app/widget/eventdialog.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  late Box<EventModel> eventBox;

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
            color: Colors.amber,
          ),
        ),
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
              child: Text(
                "No Events",
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: box.length,
            itemBuilder: (context, index) {
              final event = box.getAt(index)!;
              final bool isClosed = event.status == 'Closed';

              return Slidable(
                key: ValueKey(event.key),

                // 👉 EDIT ACTION
                startActionPane: ActionPane(
                  motion: const StretchMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) async {
                        final updated =
                            await eventDialog(context, event: event);

                        if (updated == null) return;

                        if (event.status != 'Closed' &&
                            updated.status == 'Closed' &&
                            !event.expenceAdd) {
                          TransactionDB.add(
                            TransactionModel(
                              amount: updated.totalAmount,
                              category:
                                  updated.category ?? 'General',
                              type: 'expense',
                              account: updated.paymentType,
                              date: DateTime.now(),
                              note: 'Event: ${updated.name}',
                            ),
                          );
                          updated.expenceAdd = true;
                        }

                        eventBox.putAt(index, updated);
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
                      onPressed: (_) => eventBox.deleteAt(index),
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
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
                        backgroundColor:
                            isClosed ? Colors.red : Colors.green,
                        child: const Icon(
                          Icons.event,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
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
              );
            },
          );
        },
      ),
    );
  }
}
