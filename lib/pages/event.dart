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
      appBar: AppBar(title: const Text("Events")),
      floatingActionButton: FloatingActionButton(
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
            return const Center(child: Text("No Events"));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final event = box.getAt(index)!;

              return Slidable(
                endActionPane: ActionPane(
                  motion: const StretchMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) =>
                          eventBox.deleteAt(index),
                      backgroundColor: Colors.red,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(event.name),
                  subtitle: Text("₹${event.totalAmount}"),
                  trailing: Text(
                    event.status,
                    style: TextStyle(
                      color: event.status == 'Closed'
                          ? Colors.red
                          : Colors.green,
                    ),
                  ),
                  onLongPress: () async {
                    final updated =
                        await eventDialog(context, event: event);

                    if (updated == null) return;

                    if (event.status != 'Closed' &&
                        updated.status == 'Closed' &&
                        !event.expenceAdd) {
                      TransactionDB.add(
                        TransactionModel(
                          amount: updated.totalAmount,
                          category: updated.category ?? 'General',
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
