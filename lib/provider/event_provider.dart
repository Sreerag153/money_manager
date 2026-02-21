import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager_app/model/eventmodel.dart';
import 'package:money_manager_app/model/transaction_model.dart';

class EventProvider extends ChangeNotifier {
  final _box = Hive.box<EventModel>('eventsBox');
  String _selectedFilter = 'All';

  String get selectedFilter => _selectedFilter;

  List<EventModel> get events {
    final list = _box.values.toList();
    if (_selectedFilter == 'All') return list;
    return list.where((e) => e.status == _selectedFilter).toList();
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  void addEvent(EventModel event) {
    _box.add(event);
    notifyListeners();
  }

  void deleteEvent(dynamic key) {
    _box.delete(key);
    notifyListeners();
  }

  Future<void> updateEvent(dynamic key, EventModel event) async {
    await _box.put(key, event);
    notifyListeners();
  }

  Future<void> closeEvent(EventModel event) async {
    event.status = 'Closed';
    if (event.expenceAdd != true) {
      final txBox = Hive.box<TransactionModel>('transactions');
      await txBox.add(
        TransactionModel(
          amount: event.splitAmount ?? 0,
          category: event.category ?? 'General',
          type: 'expense',
          account: event.paymentType,
          date: DateTime.now(),
          note: 'Event: ${event.name}',
        ),
      );
      event.expenceAdd = true;
    }
    await event.save();
    notifyListeners();
  }
}