import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager_app/database/transactiondb.dart';
import 'package:money_manager_app/model/eventmodel.dart';
import 'package:money_manager_app/model/transaction_model.dart';
import 'package:money_manager_app/widget/editevent.dart';
import 'package:money_manager_app/widget/eventdialog.dart';

class Event extends StatefulWidget {
  const Event({super.key});

  @override
  State<Event> createState() => _EventState();
}

class _EventState extends State<Event> {
  late Box<EventModel> eventBox;

  @override
  void initState() {
    super.initState();
    eventBox = Hive.box<EventModel>('eventsBox');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 86, 86, 86),
      appBar: AppBar(
        title: const Text('Event',style: TextStyle(color:Colors.black),),
        
        backgroundColor: Colors.white,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newEvent = await addEventDialog(context);
          if (newEvent != null) {
            await eventBox.add(newEvent);
          }
        },
        child: const Icon(Icons.add),
      ),

      body: ValueListenableBuilder(
        valueListenable: eventBox.listenable(),
        builder: (context, Box<EventModel> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text("No Events Added",
                  style: TextStyle(color: Colors.white)),
            );
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final event = box.getAt(index)!;

              return Slidable(
                key: ValueKey(event.key),
                endActionPane: ActionPane(
                  motion: StretchMotion(), 
                  children:[
                  SlidableAction(
                    onPressed: (_) {
                      eventBox.delete(event.key);
                    },
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],),
                child: GestureDetector(
                  onLongPress: () async {
                    final updatedEvent =
                        await editEventDialog(context, event);
                
                    if (updatedEvent != null) {
                
                      
                      if (event.status != 'Closed' &&
                          updatedEvent.status == 'Closed') {
                
                        TransactionDB.add(
                          TransactionModel(
                            amount: updatedEvent.totalAmount,
                            category: updatedEvent.category ?? 'General',
                            type: 'expense',
                            account: updatedEvent.paymentType,
                            date: DateTime.now(),
                            note: 'Event: ${updatedEvent.name}',
                          ),
                        );
                      }
                
                      await eventBox.putAt(index, updatedEvent);
                    }
                  },
                
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(event.name,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text('Members: ${event.members}'),
                            Text('Total: ₹${event.totalAmount}'),
                            Text(
                                'Split: ₹${event.splitAmount?.toStringAsFixed(2) ?? 0}'),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          event.status,
                          style: TextStyle(
                            color: event.status == 'Closed'
                                ? Colors.red
                                : Colors.green,
                            fontWeight: FontWeight.bold,
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
